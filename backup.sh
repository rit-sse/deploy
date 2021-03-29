#!/bin/bash
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
set -x           # print commands before running them. disable by running `bash +x script.sh`

DATE="$(date +%Y-%m-%d)"

mkdir -p ./backups/
docker exec -i postgres pg_dump -U postgres postgres > "./backups/postgres-$DATE.sql"
docker exec -i postgres-dev pg_dump -U postgres postgres > "./backups/postgres-dev-$DATE.sql"
