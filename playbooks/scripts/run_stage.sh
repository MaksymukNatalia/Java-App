#!/bin/bash

source .env

docker network create --subnet=172.18.0.0/16 schedule_network

docker run   --name schedule_postgres \
 -p $DB_PORT:$DB_PORT -e POSTGRES_USER=$DB_USERNAME \
 -e POSTGRES_PASSWORD=$DB_PASSWORD \
 -e POSTGRES_DB=$DB_NAME -d --network schedule_network onjin/alpine-postgres
 
docker exec -it schedule_postgres psql -U schedule -c "CREATE DATABASE schedule_test;"

docker run --name schedule_mongo \
 -d --network schedule_network mvertes/alpine-mongo
docker run --name schedule_redis  \
 -d --network schedule_network redis:alpine

docker volume create --name war_file

docker run --rm --name war-copier -v war_file:/data \
--env-file .env --network schedule_network \
-v $(pwd):/app -w /app -it gradle:7.3.0-jdk11-alpine \
sh -c "gradle build && cp /app/build/libs/class_schedule.war /data/class_schedule.war"

docker run --name tomcat_run --network schedule_network \
 --env-file .env  -d -p 8080:8080 -v war_file:/data tomcat:9.0.82-jre11

docker exec -it tomcat_run cp /data/class_schedule.war /usr/local/tomcat/webapps/ROOT.war
