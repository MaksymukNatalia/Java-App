pipeline {
    agent any
    environment{
      envfile = credentials('env')
      db_cred = credentials('postgres_user')
      
        NEXUS_CREDENTIALS_ID = credentials('nexus')
        user_awx = credentials('user_awx')
        awx_pass = credentials('awx_pass')
        
      }
    stages {
        stage('Fetch code') {
            steps {
                git branch: 'main', url: 'https://github.com/MaksymukNatalia/Schedule.git'
            }
      }
      stage('Create network'){
        steps {
          script {
                    def networkName = "schedule_network"
                    sh "docker network create ${networkName}"
                }
        }
      }
         stage('Start Mongo, Redic, Postgres') {
            steps {
                parallel(
                    mongo: {
                      script {
                            def containerName = "schedule_mongo"
                            def networkName = "schedule_network"
                    
                            docker.image('mongo').run(" --name ${containerName} --network ${networkName} -p 27018:27017")
                        }
                    },
                    redis: {
                      script {
                            def containerName = "schedule_redis"
                            def networkName = "schedule_network"
                            docker.image('redis').run("-d --name ${containerName} --network ${networkName} -p 6378:6379 ")
                        }
                    },
                    postgres: {
                      script {
                            def containerName = "schedule_postgres"
                            def networkName = "schedule_network"
                    
                            docker.image('postgres').run(" --name ${containerName} --network ${networkName} -e POSTGRES_USER=${db_cred_USR} -e POSTGRES_PASSWORD=${db_cred_PSW} -e POSTGRES_DB=schedule -p 5433:5432")
                            sleep time: 10, unit: 'SECONDS'
                            sh 'docker exec  schedule_postgres psql -U schedule -c "CREATE DATABASE schedule_test;"'
                        }
                    }
                )
            }
        }
        stage('Create war') {
          steps{
              script {
                  def networkName = "schedule_network"
                  def containerName = "war_copier"
                    
                    sh 'docker run  --name war-copier  --env-file ${envfile} --network schedule_network -v $(pwd):/app -w /app gradle:7.3.0-jdk11-alpine sh -c "gradle build && cp /app/build/libs/class_schedule.war ."'
                   
                  
              }
                
            }
        }
        stage('Upload to Nexus') {
            steps {
        nexusArtifactUploader(
      nexusVersion: 'nexus3',
      protocol: 'http',
      nexusUrl: '34.27.100.19:8081',
      groupId: 'Versions',
      version: "$BUILD_TIMESTAMP",
      repository: 'schedule_versions',
      credentialsId: 'nexus',
      artifacts: [
          [artifactId: 'class_schedule',
           classifier: '',
           file: '/var/lib/jenkins/workspace/Schedule/class_schedule.war',
           type: 'war']
      ]
         )
            }
        }

    }
     post {
        always {
            sh 'docker stop schedule_postgres schedule_mongo schedule_redis '
            sh 'docker container prune -f'
            sh 'docker network prune -f'
            
        }
        success {
            sh 'curl -k -u Natali:${awx_pass} -X POST http://awx.hrtov.xyz/api/v2/job_templates/18/launch/'
        }
    }
    
}
