# Guide
## Requirements
* Docker `>=19.03.13`
* Docker compose only `1.26.2`

## Start
* Clone project `git clone https://github.com/s3bul/teamspeak-server.git`
* Move to project dir `cd teamspeak-server`
* Configure env
  * `./docker.sh env`
  * Set envs in `.env.db` and `.env.ts`
* Run containers `./docker.sh`
