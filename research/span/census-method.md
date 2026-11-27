# Literal-window and rank census

Build the program from this directory.

```sh
c++ -std=c++17 -O2 -Wall -Wextra -pedantic census.cpp -o census
./census > census.csv 2> census-errors.log
```

The program tests every permutation of lengths 2 through 9.
For each permutation it tests every positive overlap below its length.
It uses no symmetry or equivalence reductions.

The two methods share the input enumeration and the comparison harness.
They use different tests for admissibility and different algorithms for endpoint comparisons.

1. The literal method compares every pair of prefix positions with the corresponding suffix positions.
   For each distance t, it builds the actual t + 1 windows at their prescribed starts.
   Edges connect consecutive ranks in each window.
   Warshall's algorithm computes their transitive closure.
   The method selects endpoints using their physical positions.
2. The rank method standardises the prefix and suffix separately.
   It sorts the prefix and suffix ranks and iterates the upper and lower transfer maps.
   It selects endpoints from the complements of the suffix and prefix rank sets.

The common table records four values for each endpoint-rank pair.
They mean ineligible, earlier position below later position, earlier position above later position, and incomparable.
The program compares every entry at every distance from 1 through m + 2.
It also compares the last two rank tables to check stabilization.

Each output row gives the length, admissible pairs, strips tested, and eligible endpoint comparisons.
It then gives the finite-span distribution, the infinite-span count, and the discrepancy count.
A distribution entry such as `1=28` means 28 pattern–overlap pairs have span one.
The program reports every discrepancy on standard error and returns a nonzero status on any discrepancy.

The observed distances come from finite calculations.
The labels for finite and infinite span use the stabilization theorem in the accompanying written proof.
