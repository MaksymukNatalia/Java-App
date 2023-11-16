# Class schedule
## General info
This repository contains a source code of the Class Schedule Project.

The main goal of the project is designing a website where the university or institute staff will be able to create, store and display their training schedules.

## DEV environment configuration
In order to create a local copy of the project you need:
1. Download and install the last version of Git https://git-scm.com/downloads
2. Open a terminal and go to the directory where you want to clone the files. 
3. Run the following command. Git automatically creates a folder with the repository name and downloads the files there.
```
git clone https://github.com/MaksymukNatalia/Schedule.git
```
4. Enter your username and password if GitHub requests.

### 1. Create Environment Variables
Create a `.env` file in the project's directory `scripts` and run `config_replacer.sh` to apply configuration variables.

### 2. Set Up Databases with Docker
```
source .env
```
#### PostgreSQL
```
docker run -d \
--name dev_postgres_schedule \
-e POSTGRES_DB=$DB_NAME \
-e POSTGRES_USER=$DB_USERNAME \
-e POSTGRES_PASSWORD=$DB_PASSWORD \
-p $DB_PORT:$DB_PORT \
postgres:latest
```
#### PostgreSQL Test
```
docker run -d \
--name dev_postgres_schedule_test \
-e POSTGRES_DB=$TEST_DB_NAME \
-e POSTGRES_USER=$TEST_DB_USERNAME \
-e POSTGRES_PASSWORD=$TEST_DB_PASSWORD \
-p $DB_PORT:$TEST_DB_PORT \
postgres:latest
```

#### Redis
```
docker run -d \
--name dev_redis_schedule \
-p $REDIS_PORT:$REDIS_PORT \
redis:latest
```

### 3. Starting backend server using IntelliJ IDEA and Tomcat
1. Run `gradle wrapper` to generate wrapper
2. Download and install the Ultimate version of IntelliJ IDEA (alternatively you can use a trial or EAP version) https://www.jetbrains.com/idea/download
3. Download and install Tomcat 9.0.50 https://tomcat.apache.org/download-90.cgi
4. Start the IDE and open class_schedule.backend project from the folder where you previously download it.
5. Make sure Tomcat and TomEE Integration is checked (`File –>> Settings –>> Plugins`).
6. `Run –>> Edit Configurations…`
7. Clicks `+` icon, select `Tomcat Server –>> Local`
8. Clicks on “Server” tab, then press `Configure...` button and select the directory with Tomcat server
9. Clicks on “Deployment” tab, then press `+` icon to select an artifact to deploy, and select `Gradle:com.softserve:class_schedule.war`
10. Press OK to save the configuration
11. `Run –>> Run 'Tomcat 9.0.50'` to start the backend server

### 4. Starting frontend server using Node.js
1. Download and install Node.js 14.17.4 LTS version https://nodejs.org/en/
2. Open a terminal in `/frontend` directory of the downloaded project and run the following command.
```
npm install
```
3. After the installation is finished run the following command to start the frontend server
```
npm start
```

## STAGE environment configuration

In order to create a local copy of the project you need:
1. Download and install the last version of Git https://git-scm.com/downloads
2. Open a terminal and go to the directory where you want to clone the files. 
3. Run the following command. Git automatically creates a folder with the repository name and downloads the files there.
   
```
git clone https://github.com/MaksymukNatalia/Schedule.git
```
4. Go to scripts folder and change permissinos to run script

```
cd scripts | chmod +x run_stage.sh
```
5. Run script the following command
```
./run_stage.sh
```

# Instructions for Production Environment

## Creating a Local Repository
To create a local copy of the project, follow these steps:

1. Download and install the latest version of Git from [git-scm.com](https://git-scm.com/downloads).
2. Open a terminal and navigate to the directory where you want to clone the files.
3. Run the following command. Git will automatically create a folder with the repository name and download the files.

   ```bash
   git clone https://github.com/MaksymukNatalia/Schedule.git

## Set Environment

After cloning the repository, change `.envsample` to `.env`.

mv .envsample .env

Set the appropriate values in the `.env` file. 

## Docker Setup

Download and install the latest version of Docker from [docs.docker.com](https://docs.docker.com/get-docker/).

## Application Deployment

To deploy the application, follow these steps:

1. Open a terminal in the project directory.

2. Run the following command to build and start the Docker containers.

    ```bash
    docker-compose up --build
    ```

    After the build is finished, access the application using:

    ```bash
    curl http://localhost:8080/public/semesters
    ```

### Environment file

- `DB_HOST`: The host address of the database server.
- `POSTGRES_USER`: The owner the database.
- `POSTGRES_DB`: Your current database.
- `POSTGRES_PASSWORD`: Your password for `POSTGRES_USER` .


### Troubleshooting

- **Issue: Incorrect Docker Installation.**
  - *Solution:* 
    - Check if Docker is installed by running `docker --version` in the terminal.
    - Ensure Docker is running with `docker info`.
    - Refer to the [official Docker documentation](https://docs.docker.com/get-docker/) for troubleshooting installation issues.

- **Issue: Unable to start Docker containers.**
  - *Solution:* Check if Docker is running, and ensure no other processes are using the required ports.

- **Issue: Incorrect data in the application.**
  - *Solution:* Verify the values of environment variables in the `.env` file and restart the application.


### Project structure 
Diagram as a code:

![schedule_web_service](https://github.com/MaksymukNatalia/Schedule/assets/146463470/258745e1-26df-48b8-b10f-38a4c21d551c)

