# <center> 274. H-Index </center>

Problem: https://leetcode.com/problems/h-index/description/

------------------------------------------------------------------------------------------------------------------------
## Problem Statement

Given an array of integers citations where citations[i] is the number of citations a researcher received for their ith
paper, return the researcher's *h-index*.

According to the definition of *h-index* on [Wikipedia](https://en.wikipedia.org/wiki/H-index): The *h-index* is defined
as the maximum value of h such that the given researcher has published at least h papers that have each been cited at
least h times.

------------------------------------------------------------------------------------------------------------------------

## Constraints

- n == citations.length
- 1 <= n <= 5000
- 0 <= citations[i] <= 1000

------------------------------------------------------------------------------------------------------------------------

## Examples

### Example 1

```
>>> citations = [3, 0, 6, 1, 5]

< Expected Output: 3
```

### Example 2

```
>>> citations = [1, 3, 1]
< Expected Output: 1
```
------------------------------------------------------------------------------------------------------------------------
