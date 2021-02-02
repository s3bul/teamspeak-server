docker exec "$(docker ps -qf "name=teamspeak_db")" \
  mysqldump -p"$(grep MYSQL_ROOT_PASSWORD .env.db | sed -E 's/(.*=)(.*)/\2/')" \
  teamspeak >"teamspeak_db-$(date +%Y%m%d%H%M%S).sql"
