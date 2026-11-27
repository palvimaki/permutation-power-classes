// Exhaustive endpoint census for the domain fixed in PROTOCOL.md.
// Build: c++ -std=c++17 -O2 -Wall -Wextra -pedantic census.cpp -o census
// Run: ./census
#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <map>
#include <numeric>
#include <stdexcept>
#include <vector>

using Pattern = std::vector<int>;
using Word = std::uint64_t;
constexpr int max_length = 9;
using Grid = std::array<std::array<char, max_length + 1>, max_length + 1>;
using StripTable = std::vector<Grid>;

// A table entry is indexed by distance, first rank, and last rank.
// '<' or '>' gives the order of the first position relative to the last.
// '?' means incomparable. A zero means that the endpoints are ineligible.

// Literal implementation. Compare physical overlap positions directly.
bool physical_overlap(const Pattern& pattern, int overlap) {
    const int shift = static_cast<int>(pattern.size()) - overlap;
    for (int i = 0; i < overlap; ++i) {
        for (int h = 0; h < i; ++h) {
            if ((pattern[h] < pattern[i]) != (pattern[shift+h] < pattern[shift+i])) {
                return false;
            }
        }
    }
    return true;
}

StripTable literal_strips(const Pattern& pattern, int overlap) {
    const int length = static_cast<int>(pattern.size());
    const int stride = length - overlap;
    std::vector<int> by_rank(length);
    std::iota(by_rank.begin(), by_rank.end(), 0);
    std::sort(by_rank.begin(), by_rank.end(),
              [&](int i, int h) { return pattern[i] < pattern[h]; });

    StripTable result(overlap + 3);
    for (int distance = 1; distance <= overlap + 2; ++distance) {
        const int size = length + distance * stride;
        if (size > 64) throw std::logic_error("strip exceeds the bit mask");
        std::array<Word, 64> reach{};
        for (int window = 0; window <= distance; ++window) {
            const int start = window * stride;
            for (int i = 1; i < length; ++i) {
                reach[start + by_rank[i-1]] |= Word{1} << (start + by_rank[i]);
            }
        }
        // Warshall closure of the union of the physical window chains.
        for (int mid = 0; mid < size; ++mid) {
            const Word mask = Word{1} << mid;
            for (int source = 0; source < size; ++source) {
                if (reach[source] & mask) reach[source] |= reach[mid];
            }
        }
        for (int vertex = 0; vertex < size; ++vertex) {
            if ((reach[vertex] >> vertex) & 1) throw std::logic_error("cyclic literal strip");
        }
        const int last_start = distance * stride;
        for (int left = 0; left < stride; ++left) {
            for (int offset = overlap; offset < length; ++offset) {
                const int right = last_start + offset;
                char order = '?';
                if ((reach[left] >> right) & 1) order = '<';
                if ((reach[right] >> left) & 1) order = '>';
                result[distance][pattern[left]][pattern[offset]] = order;
            }
        }
    }
    return result;
}

// Rank implementation. Standardise each end independently by counting smaller entries.
std::vector<int> standardise(Pattern::const_iterator begin, Pattern::const_iterator end) {
    std::vector<int> result;
    for (auto it = begin; it != end; ++it) {
        result.push_back(static_cast<int>(std::count_if(begin, end, [&](int rank) { return rank < *it; })));
    }
    return result;
}

bool rank_overlap(const Pattern& pattern, int overlap) {
    return standardise(pattern.begin(), pattern.begin() + overlap) ==
           standardise(pattern.end() - overlap, pattern.end());
}

StripTable rank_strips(const Pattern& pattern, int overlap) {
    const int length = static_cast<int>(pattern.size());
    Pattern prefix(pattern.begin(), pattern.begin() + overlap);
    Pattern suffix(pattern.end() - overlap, pattern.end());
    std::sort(prefix.begin(), prefix.end());
    std::sort(suffix.begin(), suffix.end());

    std::array<int, max_length + 2> lower{}, upper{};
    for (int z = 0; z <= length + 1; ++z) {
        upper[z] = length + 1;
        for (int h = 0; h < overlap; ++h) {
            if (suffix[h] <= z) lower[z] = std::max(lower[z], prefix[h]);
            if (suffix[h] >= z) upper[z] = std::min(upper[z], prefix[h]);
        }
    }
    StripTable result(overlap + 3);
    for (int x = 1; x <= length; ++x) {
        if (std::binary_search(suffix.begin(), suffix.end(), x)) continue;
        int low = x, high = x;
        for (int t = 1; t <= overlap + 2; ++t) {
            low = lower[low];
            high = upper[high];
            for (int y = 1; y <= length; ++y) {
                if (std::binary_search(prefix.begin(), prefix.end(), y)) continue;
                char order = '?';
                if (y <= low) order = '>';
                if (y >= high) order = '<';
                result[t][x][y] = order;
            }
        }
    }
    return result;
}

void report_pattern(const Pattern& pattern, int overlap) {
    for (int x : pattern) std::cerr << x;
    std::cerr << " overlap=" << overlap;
}

int main() {
    std::uint64_t differences = 0;
    std::cout << "K,admissible,strips,endpoint_comparisons,finite_span_distribution,infinite_span,disagreements\n";
    for (int k = 2; k <= max_length; ++k) {
        std::uint64_t admissible = 0, strips = 0, endpoints = 0, infinite = 0;
        const auto previous_differences = differences;
        std::map<int, std::uint64_t> finite;
        Pattern pattern(k);
        std::iota(pattern.begin(), pattern.end(), 1);
        do {
            for (int overlap = 1; overlap < k; ++overlap) {
                const bool literal_ok = physical_overlap(pattern, overlap);
                const bool rank_ok = rank_overlap(pattern, overlap);
                if (literal_ok != rank_ok) {
                    ++differences;
                    report_pattern(pattern, overlap);
                    std::cerr << " admissibility disagrees\n";
                }
                if (!literal_ok || !rank_ok) continue;
                ++admissible;
                const auto actual = literal_strips(pattern, overlap);
                const auto predicted = rank_strips(pattern, overlap);
                int largest_witness = 0;
                for (int t = 1; t <= overlap + 2; ++t) {
                    ++strips;
                    for (int x = 1; x <= k; ++x) {
                        for (int y = 1; y <= k; ++y) {
                            const char a = actual[t][x][y], p = predicted[t][x][y];
                            if (a) ++endpoints;
                            if (a != p) {
                                ++differences;
                                report_pattern(pattern, overlap);
                                std::cerr << " t=" << t << " x=" << x << " y=" << y
                                          << " literal=" << (a ? a : '-') << " rank=" << (p ? p : '-') << '\n';
                            }
                            if (a == '?') largest_witness = t;
                            if (t == overlap + 2 && p != predicted[t-1][x][y]) {
                                ++differences;
                                report_pattern(pattern, overlap);
                                std::cerr << " stabilization disagrees at x=" << x << " y=" << y << '\n';
                            }
                        }
                    }
                }
                // The inference from a stabilized gap to infinite span uses Theorem A.
                if (largest_witness >= overlap + 1) ++infinite;
                else ++finite[largest_witness];
            }
        } while (std::next_permutation(pattern.begin(), pattern.end()));
        std::cout << k << ',' << admissible << ',' << strips << ',' << endpoints << ',';
        bool first = true;
        for (const auto& entry : finite) {
            if (!first) std::cout << ' ';
            std::cout << entry.first << '=' << entry.second;
            first = false;
        }
        std::cout << ',' << infinite << ',' << differences - previous_differences << std::endl;
    }
    return differences != 0;
}
