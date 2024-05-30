#!/usr/bin/env bash

backupFile="teamspeak_db-$(date +%Y%m%d%H%M%S).sql.gz"
docker compose exec db \
  mysqldump -p"$(cat secrets/db_root_password.txt)" \
  teamspeak | gzip > backup/"${backupFile}"
