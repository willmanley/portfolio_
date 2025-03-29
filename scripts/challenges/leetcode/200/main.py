"""Python solution to LeetCode 200.
"""
import copy
from typing import List


def solution(grid: List[List[int]]) -> int:
    """A solution to finding the number of islands in a 2D binary grid.
    The solution works by iterating through each element in the array:
    If an element belongs to an "island", the number of islands is incremented
    and a DFS is performed to "flood" all cells belonging to the associated island
    (implicitly utilizing memoization).

    Args:
        grid: A 2D binary grid to search for islands.

    Returns:
        The number of islands (connected components) present in the provided grid.
    """
    # Create a copy of the grid for mutating as islands are found.
    _grid = copy.deepcopy(grid)

    # Extract the number of grid rows and columns.
    n_rows, n_cols = len(_grid), len(_grid[0])

    # If the grid is empty, return zero islands.
    if (_n_cells := (n_rows * n_cols)) == 0:
        return 0

    # Count islands as they appear.
    n_islands = 0
    for row in range(n_rows):
        for col in range(n_cols):
            # Determine if the cell in consideration belongs to an island.
            if _grid[row][col] == 1:
                # Flood all connected cells belonging to the same island via a DFS.
                _dfs(grid=_grid, row=row, col=col)
                # Increment the number of islands that were found.
                n_islands += 1

    return n_islands


def _dfs(grid: List[List[int]],
         row: int,
         col: int
         ):
    """An auxiliary function, performing a Depth-First Search (DFS) to
    identify and "flood" all cells belonging to the same island as the
    cell at grid[row, col].

    Args:
        grid: A 2D binary grid that is being searched for islands.
        row: The row index of the cell to perform the DFS.
        col: The column index of the cell to perform the DFS at.
    """
    # ...
    cell_index_out_of_bounds = ((row < 0 or row >= len(grid)) or (col < 0 or col >= len(grid[0])))

    # If the cell being searched is out of bounds or if it does not belong to an island, the search can stop.
    if cell_index_out_of_bounds or (_cell_not_island := (grid[row][col] == 0)):
        return

    # Flood the cell identified as belonging to the island being searched for (implicit memoization).
    grid[row][col] = 0

    # Recursively search all 4 neighbours of the cell that was just searched.
    _dfs(grid=grid, row=row + 1, col=col)
    _dfs(grid=grid, row=row - 1, col=col)
    _dfs(grid=grid, row=row, col=col + 1)
    _dfs(grid=grid, row=row, col=col - 1)


if __name__ == "__main__":
    # Test Example 1:
    expected_example_1 = 1
    actual_example_1 = solution(grid=[
        [1, 1, 1, 1, 0],
        [1, 1, 0, 1, 0],
        [1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0]
    ]
    )
    assert actual_example_1 == expected_example_1

    # Test Example 2:
    expected_example_2 = 3
    actual_example_2 = solution(
        grid = [
            [1, 1, 0, 0, 0],
            [1, 1, 0, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 0, 1, 1]
        ]
    )
    assert actual_example_2 == expected_example_2
