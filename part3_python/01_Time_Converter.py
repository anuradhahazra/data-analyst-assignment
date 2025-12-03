#!/usr/bin/env python3
"""
01_Time_Converter.py
Convert minutes to human-readable format.

Examples:
130 -> "2 hrs 10 minutes"
110 -> "1 hr 50 minutes"
0   -> "0 minutes"
"""


def minutes_to_human(minutes: int) -> str:
    if minutes is None:
        raise ValueError("minutes must be an integer")
    if minutes < 0:
        raise ValueError("minutes cannot be negative")
    hrs = minutes // 60
    mins = minutes % 60
    parts = []
    if hrs > 0:
        parts.append(f"{hrs} hr" + ("s" if hrs != 1 else ""))
    if mins > 0:
        parts.append(f"{mins} minute" + ("s" if mins != 1 else ""))
    if not parts:
        return "0 minutes"
    return " ".join(parts)


# Take a single input from the user
minutes = int(input("Enter minutes: "))

# Print output
print(f"{minutes} -> {minutes_to_human(minutes)}")
