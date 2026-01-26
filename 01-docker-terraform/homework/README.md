# Module 1 Homework: Docker & SQL

This repository contains solutions for the Docker, SQL, and Terraform homework assignment.

## Setup Instructions

### Prerequisites
- Docker installed
- Docker Compose installed
- Terraform installed (for GCP section)
- PostgreSQL client (for database operations)

### 1. Docker Setup
Run the Python 3.13 container with bash entrypoint:
```bash
docker run -it --entrypoint bash python:3.13
```
### 2. Docker Compose Setup
Save the provided docker-compose.yaml configuration
Start the services:
```bash
docker-compose up -d
```

### 3. Data Preparation
Download the required datasets:

```bash
wget https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
``` 

### 4. Database Setup
Connect to PostgreSQL and load the data:

```bash 
# Connect to PostgreSQL
docker exec -it postgres psql -U postgres -d ny_taxi

# Then run SQL commands to create tables and import data
# (See SOLUTION.md for specific SQL commands)
```

### 5. Terraform Setup
Navigate to the terraform directory
Initialize and apply:
``` bash
terraform init
terraform apply
```

Repository Structure

.
├── docker-compose.yaml
├── data/
│   ├── green_tripdata_2025-11.parquet
│   └── taxi_zone_lookup.csv
├── terraform/
│   ├── main.tf
│   └── variables.tf
├── README.md
└── SOLUTION.md
Notes
For detailed solutions to all questions, see SOLUTION.md
Ensure you have proper GCP credentials configured for Terraform
The database credentials are in the docker-compose.yaml file