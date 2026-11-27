// Enumerate physical permutations and use their literal finite order constraints.
// Compile: c++ -std=c++17 -O2 finite_verify.cpp -o finite-verify
#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <limits>
#include <map>
#include <numeric>
#include <stdexcept>
#include <vector>
#include <unordered_map>

using Bits = std::uint64_t;
using Count = std::uint64_t;
using Pattern = std::array<int, 10>;
struct Group { Pattern pattern{}; Count multiplicity = 0; int m = 0; };

bool admissible(const Pattern& a, int k, int m) {
    int d = k - m;
    for (int i = 0; i < m; ++i)
        for (int h = 0; h < i; ++h)
            if ((a[i] < a[h]) != (a[d + i] < a[d + h])) return false;
    return true;
}

std::vector<Bits> constraints(const Pattern& a, int k, int m, int j) {
    int d = k - m, n = k + (j - 1) * d;
    if (n >= 64) throw std::runtime_error("strip exceeds bit capacity");
    std::vector<Bits> above(n);
    for (int t = 0; t < j; ++t)
        for (int i = 0; i < k; ++i)
            for (int h = 0; h < k; ++h)
                if (a[i] < a[h]) above[t * d + i] |= Bits(1) << (t * d + h);
    return above;
}

bool has_gap(const Pattern& a, int k, int m, int distance) {
    int d = k - m;
    auto above = constraints(a, k, m, distance + 1);
    int n = static_cast<int>(above.size());
    for (int mid = 0; mid < n; ++mid)
        for (int x = 0; x < n; ++x)
            if (above[x] & (Bits(1) << mid)) above[x] |= above[mid];
    for (int x = 0; x < d; ++x)
        for (int y = distance * d + m; y < n; ++y)
            if (!(above[x] & (Bits(1) << y)) && !(above[y] & (Bits(1) << x)))
                return true;
    return false;
}

Count orders(Bits left, const std::vector<Bits>& above, std::unordered_map<Bits, Count>& memo) {
    if (!left) return 1;
    auto found = memo.find(left);
    if (found != memo.end()) return found->second;
    Count sum = 0;
    for (Bits choices = left; choices; choices &= choices - 1) {
        int i = __builtin_ctzll(choices);
        if (above[i] & left) continue;
        auto child = orders(left ^ (Bits(1) << i), above, memo);
        if (child > std::numeric_limits<Count>::max() - sum)
            throw std::runtime_error("count exceeds integer capacity");
        sum += child;
    }
    memo.emplace(left, sum);
    return sum;
}

void run(int k) {
    if (k < 2 || k > 10) throw std::runtime_error("supported lengths are 2 through 10");
    Pattern a{};
    std::iota(a.begin(), a.begin() + k, 1);
    std::map<int, Group> groups;
    do {
        int p = 0, q = 0;
        for (int m = 1; m < k; ++m) {
            p |= 1 << (a[m-1] - 1);
            q |= 1 << (a[k-m] - 1);
            if (!admissible(a, k, m)) continue;
            auto& g = groups[p | (q << k)];
            if (!g.multiplicity) { g.pattern = a; g.m = m; }
            ++g.multiplicity;
        }
    } while (std::next_permutation(a.begin(), a.begin() + k));
    Count total = 0, finite = 0, fails = 0, finite_types = 0;
    std::map<int, Count> spans;
    for (auto& item : groups) {
        auto& g = item.second;
        total += g.multiplicity;
        if (has_gap(g.pattern, k, g.m, g.m + 1)) continue;
        int span = g.m;
        while (span && !has_gap(g.pattern, k, g.m, span)) --span;
        ++finite_types;
        finite += g.multiplicity;
        spans[span] += g.multiplicity;
        Count seq[3];
        for (int j = 3; j <= 5; ++j) {
            auto above = constraints(g.pattern, k, g.m, j);
            std::unordered_map<Bits, Count> memo;
            seq[j-3] = orders((Bits(1) << above.size()) - 1, above, memo);
        }
        using Wide = unsigned __int128;
        if (Wide(seq[0]) * seq[2] != Wide(seq[1]) * seq[1]) {
            fails += g.multiplicity;
            std::cout << "{\"K\":" << k << ",\"m\":" << g.m << ",\"pattern\":[";
            for (int i = 0; i < k; ++i) std::cout << (i ? "," : "") << g.pattern[i];
            std::cout << "],\"span\":" << span << ",\"weight\":" << g.multiplicity
                      << ",\"N3_N4_N5\":[" << seq[0] << "," << seq[1] << "," << seq[2] << "]}\n";
        }
    }
    std::cout << "{\"K\":" << k << ",\"admissible\":" << total << ",\"signatures\":" << groups.size()
              << ",\"finite\":" << finite << ",\"finite_signatures\":" << finite_types
              << ",\"nonzero_minor_pairs\":" << fails << ",\"spans\":{";
    bool comma = false;
    for (const auto& item : spans) {
        if (comma) std::cout << ",";
        std::cout << "\"" << item.first << "\":" << item.second;
        comma = true;
    }
    std::cout << "}}\n" << std::flush;
}

int main(int argc, char** argv) {
    for (int i = 1; i < argc; ++i) run(std::atoi(argv[i]));
}
