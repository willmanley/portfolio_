# <center> 200. Number of Islands </center>

Problem: https://leetcode.com/problems/number-of-islands/description/

------------------------------------------------------------------------------------------------------------------------
## Problem Statement

Given an m x n 2D binary grid which represents a map of 1's (land) and 0's (water), return the number of islands
that are present in the grid.

An *island* is surrounded by water and is formed by connecting adjacent lands horizontally or vertically.

------------------------------------------------------------------------------------------------------------------------
## Assumptions

You may assume all four edges of the grid are all surrounded by water.

------------------------------------------------------------------------------------------------------------------------

## Constraints

- m == grid.length
- n == grid[i].length
- 0 <= m, n <= 300
- grid[i][j] is 0 or 1.

------------------------------------------------------------------------------------------------------------------------

## Examples

### Example 1

```
>>> grid = [
    [1, 1, 1, 1, 0],
    [1, 1, 0, 1, 0],
    [1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0]
]

< Expected Output: 1
```

### Example 2

```
>>> grid = [
    [1, 1, 0, 0, 0],
    [1, 1, 0, 0, 0],
    [0, 0, 1, 0, 0],
    [0, 0, 0, 1, 1]
]
< Expected Output: 3
```
------------------------------------------------------------------------------------------------------------------------
