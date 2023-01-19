# Guide
## Requirements
* Docker `>=19.03.13`
* Docker compose `^1.26.2` (optionally `^2.0`)

## Start
* Clone project `git clone https://github.com/s3bul/teamspeak-server.git`
* Go to project dir `cd teamspeak-server`
* Configure secrets `./docker.sh secrets`
* Swarm init `./docker.sh swarm-init`
* Run containers `./docker.sh`
