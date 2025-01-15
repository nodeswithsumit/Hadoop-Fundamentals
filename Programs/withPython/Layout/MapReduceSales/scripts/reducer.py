
#!/usr/bin/env python
import sys
from collections import defaultdict

# Initialize a dictionary to store product counts by country
country_product_counts = defaultdict(int)

# Iterate through the input line by line
for line in sys.stdin:
    # Strip leading/trailing whitespaces and split by the tab delimiter
    country, product = line.strip().split('\t')
    
    # Count the occurrence of each product sold in the given country
    country_product_counts[(country, product)] += 1

# Output the results: Print the country, product, and the count of sales
for (country, product), count in country_product_counts.items():
    print(f"{country}\t{product}\t{count}")

