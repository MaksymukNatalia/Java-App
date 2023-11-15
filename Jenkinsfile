pipeline {
    agent any
    tools {
	gradle '7.3.3'
    }
    stages {
	stage('Build Gradle') {
            steps { 
	        script {
			sh 'mkdir -p artifact'
			sh 'echo DB_HOST=postgres >> .env'
			sh 'echo DB_NAME=schedule >> .env'
			sh 'echo DB_USERNAME=schedule >> .env'
			sh 'echo DB_PASSWORD=pass >> .env'
			sh 'echo TEST_DB_HOST=172.18.0.2 >> .env'
			sh 'echo TEST_DB_NAME=schedule_test >> .env'
			sh 'echo TEST_DB_USERNAME=schedule >> .env'
			sh 'echo TEST_DB_PASSWORD=pass >> .env'
			sh 'echo JWT_SECRET=jwtsecret >> .env'
			sh 'echo JWT_EXPIRED=86400000 >> .env'
			sh 'echo REDIS_HOST=redis >> .env'
			sh 'echo MONGO_DATABASE=schedules >> .env'
			sh 'echo MONGO_SERVER=mongo >> .env'
			sh 'cat .env'
			sh 'gradle build -x test'
			sh 'mv ./build/libs/class_schedule.war ./artifact/ROOT.war'
		}
	    }
	}
        stage('Docker') {
            steps {
                script {
                	sh 'echo DB_HOST=postgres >> .env'
			sh 'echo DB_NAME=schedule >> .env'
			sh 'echo DB_USERNAME=schedule >> .env'
			sh 'echo DB_PASSWORD=pass >> .env'
			sh 'echo TEST_DB_HOST=172.18.0.2 >> .env'
			sh 'echo TEST_DB_NAME=schedule_test >> .env'
			sh 'echo TEST_DB_USERNAME=schedule >> .env'
			sh 'echo TEST_DB_PASSWORD=pass >> .env'
			sh 'echo JWT_SECRET=jwtsecret >> .env'
			sh 'echo JWT_EXPIRED=86400000 >> .env'
			sh 'echo REDIS_HOST=redis >> .env'
			sh 'echo MONGO_DATABASE=schedules >> .env'
			sh 'echo MONGO_SERVER=mongo >> .env'
			sh 'cat .env'
                    	sh 'docker compose -f docker-compose-prod.yml up -d'
                }
            }
        }
        stage('Run tests against the container') {
            steps {
                sh 'curl http://localhost:8080'
            }
        }
    }

/*   post {
        always {
            sh 'docker-compose down'
        }
    }
    */
}
