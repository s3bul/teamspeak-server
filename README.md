# Guide
## Requirements
* Docker `>=19.03.13`
* Docker compose only `1.26.2`

## Start
* Clone project `git clone https://github.com/s3bul/teamspeak-server.git`
* Go to project dir `cd teamspeak-server`
* Configure env
  * `./docker.sh env`
  * Set envs in `.env.db` and `.env.ts`
* Swarm init `./docker.sh swarm-init`
* Run containers `./docker.sh`
