#!/usr/bin/env bash

backupFile="teamspeak_db-$(date +%Y%m%d%H%M%S).sql.gz"
docker exec "$(docker ps -qf "name=teamspeak_db")" \
  mysqldump -p"$(cat secrets/db_root_password.txt)" \
  teamspeak | gzip >"${backupFile}" && \
  mv "${backupFile}" backup
