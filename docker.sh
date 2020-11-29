#!/usr/bin/env bash

serviceName=teamspeak

generateSwarmConfig() {
  docker-compose config | sed -E "s,(cpus: )([0-9\.]+),\1'\2',g" >swarm.yml
}

stackDeploy() {
  generateSwarmConfig &&
    docker stack deploy -c swarm.yml ${serviceName}
}

stackRm() {
  docker stack rm ${serviceName}
}

copyEnv() {
  cp .env.ts.dist .env.ts &&
    cp .env.db.dist .env.db
}

swarmInit() {
  docker swarm init
}

firstCommand=$1
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
