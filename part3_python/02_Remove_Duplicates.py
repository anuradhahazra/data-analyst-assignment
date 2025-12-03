#!/usr/bin/env python3
"""
02_Remove_Duplicates.py
Remove duplicate characters from a string preserving first occurrence.
Must use a loop (as required).
"""


def unique_string_loop(s: str) -> str:
    if s is None:
        return ""
    seen = set()          # Keep track of characters already added (O(1) lookup)
    out_chars = []        # Store output characters
    for ch in s:
        if ch not in seen:
            seen.add(ch)
            out_chars.append(ch)
    return "".join(out_chars)


# Take single input from the user
user_input = input("Enter a string: ")

# Print the output
print(f"'{user_input}' -> '{unique_string_loop(user_input)}'")
