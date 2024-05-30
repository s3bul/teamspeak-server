# Guide
## Requirements
* Docker compose `^2.27.0`

## Start
* Clone project `git clone https://github.com/s3bul/teamspeak-server.git`
* Go to project dir `cd teamspeak-server`
* Configure secrets `./docker.sh secrets`
* Run containers `./docker.sh`

## Create backup db
Run script `./db-dump.sh`
