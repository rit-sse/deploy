#!/bin/bash
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
# set -x           # print commands before running them. disable by running `bash +x script.sh`

DATE="$(date +%Y-%m-%d_%H-%M-%S)"

mkdir -p ./backups/
docker exec -i postgres pg_dump -U postgres --dbname ssequel > "./backups/postgres-$DATE.sql"

# Set the maximum number of files allowed
max_files=10

# Get the number of files in the directory
file_count=$(find ./backups -type f | wc -l)

# Check if the number of files exceeds the limit
while [ $file_count -gt $max_files ]
do
    oldest_file=$(find ./backups -type f -printf '%T+ %p\n' | sort | head -n 1 | awk '{print $2}')

    # Delete the oldest file
    if [ -f "$oldest_file" ]; then
      rm -f "$oldest_file"
      echo "Deleted oldest file: $oldest_file"
    else
      echo "No files found in the directory."
    fi
    file_count=$(find ./backups -type f | wc -l) # update the file count
done
