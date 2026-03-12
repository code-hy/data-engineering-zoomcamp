# Module 3 Homework: Data Warehousing & BigQuery

**Course:** Data Engineering Zoomcamp
**Author:** Henry Yao
**Date:** 2026

This repository contains the solution for the Data Warehousing and BigQuery homework, covering external tables, materialized tables, partitioning, clustering, and query optimization.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Data Setup](#data-setup)
3. [BigQuery Setup](#bigquery-setup)
4. [Homework Questions & Solutions](#homework-questions--solutions)
5. [Key Findings](#key-findings)

---

## Prerequisites

- Google Cloud Platform (GCP) account
- BigQuery API enabled
- Google Cloud Storage (GCS) bucket created
- Service Account with GCS Admin and BigQuery Admin privileges
- Python 3.8+ (for data loading scripts)

---

## Data Setup

### Data Source

**Dataset:** Yellow Taxi Trip Records (January 2024 - June 2024)  
**Source:** [NYC Taxi & Limousine Commission](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

**Files Downloaded:**
- `yellow_tripdata_2024-01.parquet`
- `yellow_tripdata_2024-02.parquet`
- `yellow_tripdata_2024-03.parquet`
- `yellow_tripdata_2024-04.parquet`
- `yellow_tripdata_2024-05.parquet`
- `yellow_tripdata_2024-06.parquet`

### Loading Data to GCS

Use the provided Python script to upload data to your GCS bucket:

```bash
python load_yellow_taxi_data.py \
  --bucket_name your-bucket-name \
  --source_path ./data/ \
  --destination_path yellow_taxi/
  ```

  Fill in the details - 
  ```bash
# Change this to your bucket name
#BUCKET_NAME = "dezoomcamp_hw3_2025"
BUCKET_NAME = "dataengineeringzoomcamp2026_homework_3"
# Change to project ID
client = storage.Client(project='project-b60ec3fb-d46b-4909-ae8')

  ```

  