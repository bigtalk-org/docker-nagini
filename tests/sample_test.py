from nagini_contracts.contracts import *

def max_value(a: int, b: int) -> int:
    Requires(True)
    Ensures(Result() >= a and Result() >= b)
    Ensures(Result() == a or Result() == b)
    if a > b:
        return a
    else:
        return b
