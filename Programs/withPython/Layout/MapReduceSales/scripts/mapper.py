
#!/usr/bin/env python
import sys

# Iterate through the input line by line
for line in sys.stdin:
    # Strip leading/trailing whitespaces and split the fields
    fields = line.strip().split(',')
    
    # Ensure there are enough fields (basic validation)
    if len(fields) >= 12:
        # Extract the required fields: Product and Country
        product = fields[1]
        country = fields[9]
        
        # Emit key-value pair: (Country, Product)
        print(f"{country}\t{product}")

