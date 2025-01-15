# mapper.py
import sys

for line in sys.stdin:
    line = line.strip()
    matrix, row, col, value = line.split(',')

    row = int(row)
    col = int(col)
    value = float(value)

    if matrix == 'A':
        # Emit all (i, k) for A[i][j]
        for k in range(2):  # Replace '2' with the number of columns in B
            print(f"{row},{k}\tA,{col},{value}")
    elif matrix == 'B':
        # Emit all (i, k) for B[j][k]
        for i in range(2):  # Replace '2' with the number of rows in A
            print(f"{i},{col}\tB,{row},{value}")
