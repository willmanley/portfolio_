"""Python solution to LeetCode 120."""

import copy
from typing import List


def solution(triangle: List[List[int]]) -> int:
    """Finds the minimum path sum traversing through a *triangular array*.

    Args:
        triangle: The triangular array being searched for the minimum path.

    Returns: The minimum path sum, traversing through a *triangular array*.
    """
    # Create a copy of the triangular array to store intermediary minimum paths at each node.
    n_rows, min_paths_triangle = len(triangle), copy.deepcopy(triangle)

    # Iterate over elements in each row, starting from the 2nd to last row, building min-paths bottom up.
    for i in range(n_rows - 2, -1, -1):
        for j in range(len(min_paths_triangle[i])):
            # For each index, choose the minimum of the two possible paths below.
            min_paths_triangle[i][j] += min(
                min_paths_triangle[i + 1][j], min_paths_triangle[i + 1][j + 1]
            )

    # The min path is the minimum path from the triangular array vertex.
    min_path = min_paths_triangle[0][0]

    return min_path


if __name__ == "__main__":
    # Test Example 1:
    example_1 = [[2], [3, 4], [6, 5, 7], [4, 1, 8, 3]]
    expected_output_1 = 11
    actual_output_1 = solution(triangle=example_1)
    assert actual_output_1 == expected_output_1

    # Test Example 2:
    example_2 = [[-10]]
    expected_output_2 = -10
    actual_output_2 = solution(triangle=example_2)
    assert actual_output_2 == expected_output_2
