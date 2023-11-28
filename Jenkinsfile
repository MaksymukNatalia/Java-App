pipeline {
    agent any
    environment{
    	envfile = credentials('.env_stage')
    	db_cred = credentials('postgres_user')
    	

    	}
    stages {
	    stage('Create new network'){
		    steps {
			    script {
		           
                    def networkName = "schedule_network_stage"
                    sh 'docker stop schedule_postgres_stage schedule_mongo_stage schedule_redis_stage tomcat_run'
                    sh 'docker network prune -f'
                    sh 'docker container prune -f'                  
                    sh "docker network create ${networkName}"
                    
                }
		    }
	    }
         stage('Start Mongo, Redic, Postgres') {
            steps {
                parallel(
                    mongo: {
                	    script {
                            def containerName = "schedule_mongo_stage"
                            def networkName = "schedule_network_stage"
                    
                            docker.image('mongo').run(" --name ${containerName} --network ${networkName} -p 27017:27017")
                        }
                    },
                    redis: {
                	    script {
                            def containerName = "schedule_redis_stage"
                            def networkName = "schedule_network_stage"
                            docker.image('redis').run("-d --name ${containerName} --network ${networkName} -p 6379:6379 ")
                        }
                    },
                    postgres: {
                	    script {
                            def containerName = "schedule_postgres_stage"
                            def networkName = "schedule_network_stage"
                    
                            docker.image('postgres').run(" --name ${containerName} --network ${networkName} -e POSTGRES_USER=${db_cred_USR} -e POSTGRES_PASSWORD=${db_cred_PSW} -e POSTGRES_DB=schedule -p 5432:5432")
                            sleep time: 10, unit: 'SECONDS'
                            sh 'docker exec  schedule_postgres_stage psql -U schedule -c "CREATE DATABASE schedule_test;"'
                        }
                    }
                )
            }
        }
        stage('Create war') {
        	steps{
        	    script {
        	        def networkName = "schedule_network_stage"
        	        
                    
                    sh 'docker run  --name war-copier-stage -v war_file:/data   --env-file ${envfile} --network schedule_network_stage -v $(pwd):/app -w /app gradle:7.3.0-jdk11-alpine sh -c "gradle build && cp /app/build/libs/class_schedule.war  /data/class_schedule.war"'
                   
        	        
        	    }
                
            }
        }
        stage('Deploy to tomcat container') {
		    steps {
			    script {
                    def networkName = "schedule_network_stage"
                    def containerName ="tomcat_run"
                    
                    docker.image('tomcat:9.0.82-jre11').run("--name ${containerName} --network ${networkName} --env-file ${envfile}  -d -p 8081:8080 -v war_file:/data")
                    sh 'docker exec  tomcat_run cp /data/class_schedule.war /usr/local/tomcat/webapps/ROOT.war'
                }
	    	}
        }

    }

 }
