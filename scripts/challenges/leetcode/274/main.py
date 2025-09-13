"""..."""

from typing import List


def solution(citations: List[int]) -> int:
    """...

    Args:
        citations: ...

    Returns:
        ...
    """
    # Sort the citations into ascending order.
    n = len(citations)
    citations.sort()

    # Search for the first index for which the number of citations exceeds the number of articles with at least n - idx citations.
    for idx, citation in enumerate(citations):
        if n - idx <= citation:
            return n - idx

    return 0


if __name__ == "__main__":
    # Test Example 1:
    example_1 = [3, 0, 6, 1, 5]
    expected_output_1 = 3
    actual_output_1 = solution(citations=example_1)
    assert actual_output_1 == expected_output_1

    # Test Example 2:
    example_2 = [1, 3, 1]
    expected_output_2 = 1
    actual_output_2 = solution(citations=example_2)
    assert actual_output_2 == expected_output_2
