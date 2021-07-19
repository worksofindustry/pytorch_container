#!/bin/bash
# Attach S3 buckets
./mount-s3.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to connect to S3: $status"
  exit $status
fi

sleep 5

# Run Predictions

#python /app/data/src/your_file.py
echo "Testing"
