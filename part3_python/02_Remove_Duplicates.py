#!/usr/bin/env python3
"""
02_Remove_Duplicates.py
Remove duplicate characters from a string preserving first occurrence.
Must use a loop (as required).
"""

def unique_string_loop(s: str) -> str:
    if s is None:
        return ""
    seen = set()
    out_chars = []
    for ch in s:
        if ch not in seen:
            seen.add(ch)
            out_chars.append(ch)
    return "".join(out_chars)

if __name__ == "__main__":
    tests = [
        "banana",
        "aabbcc",
        "hello world",
        "1122334455",
        ""
    ]
    for t in tests:
        print(f"'{t}' -> '{unique_string_loop(t)}'")
