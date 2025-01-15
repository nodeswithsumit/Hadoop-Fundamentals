# Develop a MapReduce program to find the number of products sold in each country by considering sales data containing fields like 

```yaml
Transaction_Date, Product, Price, Payment_Type, Name, City, State, Country, Account_Created, Last_Login, Latitude, and Longitude.
```

## Problem Statement
Given sales data containing the fields mentioned above, the goal is to count the total number of products sold in each Country.

## Input Format

The input data `(sales_data.txt)` should be in the format:

```mathematica
Transaction_Date,Product,Price,Payment_Type,Name,City,State,Country Account_Created,Last_Login,Latitude,Longitude
```

## Prepare the Input Data
Create a file named <code>sales_data.txt</code> with sample input data:

```yaml

2025-01-01,ProductA,100,Card,John Doe,New York,NY,USA,2024-12-01,2025-01-01,40.7128,-74.0060
2025-01-02,ProductB,150,Card,Jane Smith,Los Angeles,CA,USA,2024-12-05,2025-01-02,34.0522,-118.2437
2025-01-03,ProductC,200,Paypal,Alex Brown,London,ENG,UK,2024-11-20,2025-01-03,51.5074,-0.1278
2025-01-04,ProductD,120,Card,Emily White,Berlin,BE,Germany,2024-09-12,2025-01-04,52.52,13.4050
2025-01-05,ProductE,180,Cash,Michael Green,Paris,IDF,France,2024-08-01,2025-01-05,48.8566,2.3522
2025-01-06,ProductF,250,Card,Oliver Black,Tokyo,13,Japan,2024-07-15,2025-01-06,35.6762,139.6503
2025-01-07,ProductG,140,Paypal,Sophia Johnson,Madrid,M,Spain,2024-06-18,2025-01-07,40.4168,-3.7038
2025-01-08,ProductH,90,Card,William Lee,Seoul,11,South Korea,2024-06-01,2025-01-08,37.5665,126.9780
2025-01-09,ProductI,160,Paypal,Emma Scott,Melbourne,VIC,Australia,2024-05-22,2025-01-09,-37.8136,144.9631
2025-01-10,ProductJ,110,Card,Liam Harris,Los Angeles,CA,USA,2024-04-19,2025-01-10,34.0522,-118.2437
2025-01-11,ProductK,140,Cash,Olivia Martinez,Barcelona,Catalonia,Spain,2024-03-25,2025-01-11,41.3784,2.1926
2025-01-12,ProductL,130,Card,James Clark,London,ENG,UK,2024-03-12,2025-01-12,51.5074,-0.1278
2025-01-13,ProductM,190,Card,Lucas Wright,Sydney,NSW,Australia,2024-02-28,2025-01-13,-33.8688,151.2093
2025-01-14,ProductN,170,Paypal,Chloe Lewis,Berlin,BE,Germany,2024-02-01,2025-01-14,52.52,13.4050
2025-01-15,ProductO,120,Card,Daniel Walker,New York,NY,USA,2024-01-23,2025-01-15,40.7128,-74.0060
2025-01-16,ProductP,100,Paypal,Charlotte Young,Paris,IDF,France,2024-01-15,2025-01-16,48.8566,2.3522
2025-01-17,ProductQ,150,Cash,Benjamin Harris,Madrid,M,Spain,2023-12-22,2025-01-17,40.4168,-3.7038
2025-01-18,ProductR,170,Card,Amelia Thomas,Seoul,11,South Korea,2023-12-10,2025-01-18,37.5665,126.9780
2025-01-19,ProductS,190,Paypal,Ethan Robinson,Tokyo,13,Japan,2023-11-15,2025-01-19,35.6762,139.6503
2025-01-20,ProductT,200,Card,Sophie King,London,ENG,UK,2023-11-01,2025-01-20,51.5074,-0.1278
2025-01-21,ProductU,120,Cash,Jackson Hall,Sydney,NSW,Australia,2023-10-12,2025-01-21,-33.8688,151.2093
2025-01-22,ProductV,110,Paypal,Grace Adams,Berlin,BE,Germany,2023-09-30,2025-01-22,52.52,13.4050
2025-01-23,ProductW,130,Card,Mason Nelson,Paris,IDF,France,2023-09-15,2025-01-23,48.8566,2.3522
2025-01-24,ProductX,140,Cash,Jack Carter,New York,NY,USA,2023-08-20,2025-01-24,40.7128,-74.0060
2025-01-25,ProductY,100,Card,Ava King,Tokyo,13,Japan,2023-08-10,2025-01-25,35.6762,139.6503
2025-01-26,ProductZ,200,Paypal,William Scott,Los Angeles,CA,USA,2023-07-30,2025-01-26,34.0522,-118.2437
2025-01-27,ProductAA,150,Card,Sarah White,London,ENG,UK,2023-07-15,2025-01-27,51.5074,-0.1278
2025-01-28,ProductBB,130,Paypal,Michael Lee,Seoul,11,South Korea,2023-06-01,2025-01-28,37.5665,126.9780
2025-01-29,ProductCC,110,Card,James Clark,Barcelona,Catalonia,Spain,2023-05-20,2025-01-29,41.3784,2.1926
2025-01-30,ProductDD,150,Cash,Liam Harris,Sydney,NSW,Australia,2023-05-05,2025-01-30,-33.8688,151.2093
2025-01-31,ProductEE,100,Card,Olivia Walker,Berlin,BE,Germany,2023-04-20,2025-01-31,52.52,13.4050
2025-02-01,ProductFF,200,Paypal,Daniel Wright,Paris,IDF,France,2023-03-15,2025-02-01,48.8566,2.3522
2025-02-02,ProductGG,150,Card,Charlotte Young,Madrid,M,Spain,2023-03-05,2025-02-02,40.4168,-3.7038
2025-02-03,ProductHH,140,Paypal,Jackson Hall,London,ENG,UK,2023-02-25,2025-02-03,51.5074,-0.1278
2025-02-04,ProductII,170,Card,Sophie Adams,Seoul,11,South Korea,2023-02-10,2025-02-04,37.5665,126.9780
2025-02-05,ProductJJ,200,Paypal,Amelia Thomas,New York,NY,USA,2023-01-30,2025-02-05,40.7128,-74.0060
2025-02-06,ProductKK,120,Cash,Mason Carter,Tokyo,13,Japan,2023-01-15,2025-02-06,35.6762,139.6503
2025-02-07,ProductLL,110,Card,Emily White,Berlin,BE,Germany,2023-01-10,2025-02-07,52.52,13.4050
2025-02-08,ProductMM,180,Paypal,Lucas Wright,Paris,IDF,France,2023-01-01,2025-02-08,48.8566,2.3522
2025-02-09,ProductNN,140,Card,James Clark,Sydney,NSW,Australia,2022-12-20,2025-02-09,-33.8688,151.2093
2025-02-10,ProductOO,150,Paypal,Olivia Walker,Madrid,M,Spain,2022-12-15,2025-02-10,40.4168,-3.7038


```

## Prepare Folder Structure

```graphql
MapReduceSales/
├── input/
│   └── sales_data.txt   # Input data file
├── scripts/
│   ├── mapper.py              # Mapper script
│   ├── reducer.py             # Reducer script
├── output/                    # (Optional) Local output folder for testing
```

## Steps to Set Up in VS Code

### Create the Project Folder:

* Open VS Code.
* Create a new folder named MapReduceSales or any name you prefer.
* Open this folder in VS Code (File > Open Folder).

### Organize the Files:

* Inside the project folder, create the subdirectories input, scripts, and output (optional).
* Place the input data file `(sales_data.txt)` in the input folder.
* Write your `mapper.py` and `reducer.py` scripts and save them in the `scripts` folder.


## Write the Mapper Script
The Mapper will now focus on extracting the Country and Product from each line and emitting them as key-value pairs. Since the dataset has more fields and larger data, we ensure that we only focus on the fields we need.

```python

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


```

## Write the Reducer Script
The Reducer will now receive the keys, which are Country and Product, and the corresponding list of products sold in that country. We need to count the occurrences of each product sold per country.

```python

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


```

## Key Points to Check: 
1. Directory Structure: Ensure that you are executing commands from the `mapreducesaless/` root directory where the folder structure is as described above.
2. Permissions: Make sure both `mapper.py` and `reducer.py` are exectutable:

```bash
chmod +x scripts/mapper.py
chmod +x scripts/reducer.py
chmod +x scripts              #(optional)
```

### Test Locally in Folder Terminal

Run the following command to test your program locally:

```bash
cat input/sales_data.txt | python3 scripts/mapper.py | sort | python3 scripts/reducer.py
```

You should see the output
```yaml
USA    ProductA    3
USA    ProductB    2
Germany ProductC   1
France  ProductD   2
Australia ProductE  3
...

```

## Run on Hadoop
To run this program using Hadoop Streaming, follow these steps:

**Step 1: Upload Input Data to HDFS**
```bash
hdfs dfs -mkdir /user/mapreducesales/input
hdfs dfs -put input/sales_data.txt /user/mapreducesales/input/
```

**Step 2: Execute the Hadoop Streaming Job**
Use the Hadoop Streaming API to run the Python scripts:

```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /user/mapreducesales/input/sales_data.txt \
  -output /user/mapreducesales/output \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"\
  -file scripts/mapper.py \
  -file scripts/reducer.py
```

## Step 3: View the Results
After the job completes, view the output in HDFS:

```bash
hdfs dfs -cat /user/mapreducesales/output/part-00000
```

This will display

```yaml
USA    ProductA    3
USA    ProductB    2
Germany ProductC   1
France  ProductD   2
Australia ProductE  3
...

```


Here is the explanation for your **Sales Data MapReduce** program:

---

## **Explanation of Steps**

### **Mapper**:
1. **Reads the Input**: The mapper processes each record from the sales data.
2. **Extracts the Country**: For each record, it extracts the `Country` field (e.g., USA, UK, Germany).
3. **Emits Key-Value Pair**: It emits the `Country` as the key and a constant value (e.g., `1`) indicating one product sold in that country.

### **Reducer**:
1. **Sums the Counts**: The reducer groups all records by the country key and sums up the product counts for each country.
2. **Outputs the Results**: For each country, the total number of products sold is printed.

### **Hadoop Streaming**:
- Hadoop Streaming allows you to write your **Mapper** and **Reducer** in Python instead of Java, making the development process faster and simpler.
- It enables you to leverage Hadoop's distributed processing capabilities for large datasets, allowing efficient data processing in a scalable way.

---

This approach ensures efficient analysis of large datasets with minimal code complexity while utilizing Hadoop's powerful processing framework.

Let me know if you'd like more details or have additional questions!