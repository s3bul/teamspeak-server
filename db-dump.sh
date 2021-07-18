#!/usr/bin/env bash

backupFile="teamspeak_db-$(date +%Y%m%d%H%M%S).sql"
docker exec "$(docker ps -qf "name=teamspeak_db")" \
  mysqldump -p"$(cat secrets/db_root_password.txt)" \
  teamspeak >"${backupFile}" && \
  tar -czf "${backupFile}.tar.gz" "${backupFile}" && \
  mv "${backupFile}.tar.gz" backup && \
  rm -rf "${backupFile}"
