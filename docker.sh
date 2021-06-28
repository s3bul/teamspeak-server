#!/usr/bin/env bash

serviceName=teamspeak

generateSwarmConfig() {
  (docker-compose config | sed -E "s,(cpus: )([0-9\.]+),\1'\2',g" >swarm.yml) ||
    exit 1
}

stackDeploy() {
  (generateSwarmConfig &&
    docker stack deploy -c swarm.yml ${serviceName}) ||
    exit 1
}

stackRm() {
  docker stack rm ${serviceName} ||
    exit 1
}

copyEnv() {
  (cp .env.ts.dist .env.ts &&
    cp .env.db.dist .env.db) ||
    exit 1
}

swarmInit() {
  docker swarm init ||
    exit 1
}

firstCommand="$1"
shift

case "${firstCommand}" in
deploy | "")
  stackDeploy
  ;;
rm)
  stackRm
  ;;
env)
  copyEnv
  ;;
swarm-init)
  swarmInit
  ;;
*)
  echo "Commands: [deploy|rm|env|swarm-init]" >&2
  exit 1
  ;;
esac

exit 0
