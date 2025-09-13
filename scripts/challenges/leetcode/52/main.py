"""..."""


def solution(n: int) -> int:
    """...

    Args:
        n:

    Returns:

    """
    # ...
    # Sets to keep track of occupied columns and diagonals
    cols = set()
    pos_diag = set()  # Positive diagonals (r + c)
    neg_diag = set()  # Negative diagonals (r - c)

    # Counter for valid solutions
    result = 0

    def _backtrack(row):
        """...

        Args:
            row:

        Returns:

        """
        nonlocal result

        # Base case: If we've placed queens in all rows, we have a valid solution
        if row == n:
            result += 1
            return

        # Try placing a queen in each column of the current row
        for col in range(n):
            # Check if the position is under attack
            if col in cols or (row + col) in pos_diag or (row - col) in neg_diag:
                continue

            # Place the queen
            cols.add(col)
            pos_diag.add(row + col)
            neg_diag.add(row - col)

            # Move to the next row
            _backtrack(row + 1)

            # Backtrack: remove the queen
            cols.remove(col)
            pos_diag.remove(row + col)
            neg_diag.remove(row - col)

    # Start backtracking from the first row
    _backtrack(0)
    return result


if __name__ == "__main__":
    # Test Example 1:
    example_1 = 1
    expected_output_1 = 1
    actual_output_1 = solution(n=example_1)
    assert actual_output_1 == expected_output_1

    # Test Example 2:
    example_2 = 4
    expected_output_2 = 2
    actual_output_2 = solution(n=example_2)
    assert actual_output_2 == expected_output_2
