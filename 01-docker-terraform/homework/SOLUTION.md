

# Module 1 Homework Solutions

## Question 1: Understanding Docker images
**Question:** What's the version of pip in the python:3.13 image?

**Solution:**
```bash
# Run the container and check pip version
docker run -it --entrypoint bash python:3.13 -c "pip --version"
```

Answer:  25.3

## Question 2: Understanding Docker networking and docker-compose
**Question:** What is the hostname and port that pgadmin should use to connect to the postgres database?

**Solution:**

Within Docker's internal network, services use their service names as hostnames
The correct hostname is db (service name)
PostgreSQL uses default port 5432 internally
Published port 5433 is for external access only

Answer: db:5432

## Question 3: Counting short trips
**Question:** How many trips had a trip_distance of less than or equal to 1 mile?

run below and it will open up the docker interactive postgres terminal

```bash
   docker exec -it postgres psql -U postgres -d ny_taxi 
```
**SQL Query:**

```sql
SELECT COUNT(*)
FROM green_tripdata
WHERE lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance <= 1;
```

Answer: 8,007

## Question 4: Longest trip for each day
**Question:**  Which was the pick up day with the longest trip distance?

**SQL Query:**

```sql
WITH ranked_trips AS (
  SELECT
    DATE(lpep_pickup_datetime) AS pickup_day,
    trip_distance,
    RANK() OVER (ORDER BY trip_distance DESC) as distance_rank
  FROM green_tripdata
  WHERE trip_distance < 100
)
SELECT pickup_day
FROM ranked_trips
WHERE distance_rank = 1;
```

Answer: 2025-11-14

## Question 5: Biggest pickup zone
**Question:** Which was the pickup zone with the largest total_amount on November 18th, 2025?

**SQL Query:**

```sql
SELECT z.Zone AS pickup_zone, SUM(t.total_amount) AS total_amount
FROM green_tripdata t
JOIN taxi_zone_lookup z ON t.pickup_location_id = z.location_id
WHERE DATE(lpep_pickup_datetime) = '2025-11-18'
GROUP BY pickup_zone
ORDER BY total_amount DESC
LIMIT 1;
```

Answer: East Harlem North

## Question 6: Largest tip
**Question:** For passengers picked up in "East Harlem North", which drop off zone had the largest tip?

**SQL Query:**

```sql
SELECT z.Zone, MAX(tip_amount) AS max_tip
FROM green_tripdata t
JOIN taxi_zone_lookup z ON t.dropoff_location_id = z.location_id
JOIN taxi_zone_lookup pu ON t.pickup_location_id = pu.Location_id
WHERE pu.Zone = 'East Harlem North'
  AND t.lpep_pickup_datetime >= '2025-11-01' 
  AND t.lpep_pickup_datetime < '2025-12-01'
GROUP BY z.Zone
ORDER BY max_tip DESC
LIMIT 1;
```
Answer: Yorkville West with max tip of $81.89

## Question 7: Terraform Workflow
**Question:** Which sequence describes the workflow for:

Downloading provider plugins and setting up backend
Generating proposed changes and auto-executing the plan
Removing all resources managed by terraform
**Solution:**
```bash
terraform init - Initializes backend and downloads providers
terraform apply -auto-approve - Applies changes without confirmation
terraform destroy - Removes all managed resources
```

Answer: terraform init, terraform apply -auto-approve, terraform destroy

# Appendix

**Database Setup Commands**

Create tables:

```sql
-- Green taxi trips table
CREATE TABLE green_tripdata (
    vendor_id INTEGER,
    lpep_pickup_datetime TIMESTAMP,
    lpep_dropoff_datetime TIMESTAMP,
    store_and_fwd_flag VARCHAR(1),
    rate_code_id NUMERIC,
    pickup_location_id INTEGER,
    dropoff_location_id INTEGER,
    passenger_count NUMERIC,
    trip_distance NUMERIC,
    fare_amount NUMERIC,
    extra NUMERIC,
    mta_tax NUMERIC,
    tip_amount NUMERIC,
    tolls_amount NUMERIC,
    ehail_fee NUMERIC,
    improvement_surcharge NUMERIC,
    total_amount NUMERIC,
    payment_type NUMERIC,
    trip_type NUMERIC,
    congestion_surcharge NUMERIC,
    cbd_congestion_fee NUMERIC
);
```
```sql
-- Zone lookup table
CREATE TABLE taxi_zone_lookup (
    location_id INTEGER,
    borough VARCHAR,
    zone VARCHAR,
    service_zone VARCHAR
);
Import data (example using psql):
```
```psql
# For CSV data
\copy taxi_zone_lookup FROM 'taxi_zone_lookup.csv' DELIMITER ',' CSV HEADER
```

# For parquet files, you might need to convert to CSV first or use a tool like pandas
```sql
\q
```

```bash
# Convert to CSV
python3 -c "
import pandas as pd
df = pd.read_parquet('green_tripdata_2025-11.parquet')
df.to_csv('green_tripdata_2025-11.csv', index=False)
"

# Copy to container
docker cp green_tripdata_2025-11.csv postgres:/var/lib/postgresql/data/

# Re-enter psql
docker exec -it postgres psql -U postgres -d ny_taxi
```





## Terraform Configuration Example
main.tf:

```bash
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "data_lake" {
  name          = "\${var.project_id}-data-lake"
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "ny_taxi"
  location   = var.region
}
```

variables.tf:

```bash
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}
```