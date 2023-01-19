#!/usr/bin/env bash

GREEN='\033[0;32m'
LGREEN='\e[92m'
YELLOW='\e[33m'
LYELLOW='\e[93m'
BLUE='\e[34m'
LBLUE='\e[94m'
LGRAY='\e[37m'
NC='\033[0m' # No Color
INVERT='\e[7m'
NI='\e[27m'

_verbose=1
_dockerComposeV2=0

if [ -f ~/.docker/cli-plugins/docker-compose ] || [ -f /usr/local/lib/docker/cli-plugins/docker-compose ]; then
  printf "%bEnable docker compose v2%b\n" \
    "${YELLOW}" "${NC}"
  _dockerComposeV2=1
else
  REQUIRED_PKG="docker-compose-plugin"
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG 2>/dev/null | grep "install ok installed")
  if [ "" != "$PKG_OK" ]; then
    printf "%bEnable docker compose v2%b\n" \
      "${YELLOW}" "${NC}"
    _dockerComposeV2=1
  fi
fi

serviceName=teamspeak
fileConfig=swarm.yml

printCommand() {
  printf "%bCommand: %b$*%b\n" \
    "${BLUE}" "${LGREEN}" "${NC}"
}

_command() {
  command="$*"
  if [ "${_verbose}" != "0" ]; then
    printCommand "${command}"
  fi

  eval "${command}" ||
    return 10
}

_docker() {
  _command docker "$@"
}

dockerCompose() {
  if [ "${_dockerComposeV2}" = "1" ]; then
    _docker compose "$@"
    return
  fi

  _command docker-compose "$@"
}

_pwgen() {
  _command pwgen "$@"
}

generatePasswords() {
  if [ ! -f "./secrets/db_root_password.txt" ]; then
    _pwgen "20 1 >./secrets/db_root_password.txt" && _pwgen "20 1 >./secrets/db_password.txt" && _pwgen "20 1 >./secrets/serveradmin_password.txt"
  fi
}

dockerConfig() {
  _dockerComposeV2=0
  dockerCompose config "$@"
}

dockerStack() {
  _docker stack "$@"
}

dockerDeploy() {
  dockerStack deploy "$@"
}

dockerSwarm() {
  _docker swarm "$@"
}

generateSwarmConfig() {
  dockerConfig "| sed -e \"s/$(readlink -f "$(dirname "$0")" | sed -e "s/\//\\\\\//g")/\./\" |
    sed -E \"s,(cpus: )([0-9\.]+),\1'\2',g\" |
    sed -zE \"s,[ ]{2}(db):\s*condition: service_started\s*\n,- \1\n,g\" > ${fileConfig}"
}

stackDeploy() {
  generateSwarmConfig &&
    dockerDeploy -c ${fileConfig} ${serviceName}
}

stackRm() {
  dockerStack rm ${serviceName}
}

swarmInit() {
  dockerSwarm init
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
secrets)
  generatePasswords
  ;;
swarm-init)
  swarmInit
  ;;
*)
  echo "Commands: [deploy|rm|secrets|swarm-init]" >&2
  exit 1
  ;;
esac

exit $?
