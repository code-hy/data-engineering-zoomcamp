import duckdb
import os

db_path = os.path.join(os.path.dirname(__file__), "taxi_rides_ny.duckdb")
con = duckdb.connect(db_path)
# Set search path to look in dev and prod schemas
con.execute("PRAGMA search_path='dev,prod,main'")

# Q3: Count records in fct_monthly_zone_revenue
print("Q3 - Count of records in fct_monthly_zone_revenue:")
result = con.execute("SELECT COUNT(*) FROM fct_monthly_zone_revenue").fetchall()
print(result)

# Q4: Best performing Green taxi zone in 2020
print("\nQ4 - Best performing Green taxi zone (2020):")
query = """
SELECT 
    pickup_zone as zone,
    SUM(revenue_monthly_total_amount) as total_revenue
FROM fct_monthly_zone_revenue
WHERE service_type = 'Green'
  AND EXTRACT(YEAR FROM revenue_month) = 2020
GROUP BY pickup_zone
ORDER BY total_revenue DESC
LIMIT 1
"""
try:
    result = con.execute(query).fetchall()
    print(result)
except Exception as e:
    print(f"Error executing Q4: {e}")

# Q5: Green taxi trips in October 2019
print("\nQ5 - Green taxi trips in October 2019:")
query = """
SELECT SUM(total_monthly_trips) 
FROM fct_monthly_zone_revenue
WHERE service_type = 'Green'
  AND revenue_month = '2019-10-01'
"""
result = con.execute(query).fetchall()
print(result)

con.close()

# Q6: Count of records in stg_fhv_tripdata (filter dispatching_base_num IS NULL)
print("\nQ6 - Records in stg fhv tripdata:")
query = """
SELECT COUNT(*) as record_count
FROM stg_fhv_tripdata
"""
result = con.execute(query.fetchall()
print(result)
