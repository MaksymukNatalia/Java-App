pipeline {
    agent any
    tools {
	gradle '7.3.3'
    }
    environment {
	envfile = credentials('envfile')
    }
    stages {
	stage('Build Gradle') {
            steps { 
	        script {
			sh 'mkdir -p artifact'
			sh 'cat $envfile > .env'
			/*
			sh 'echo DB_HOST=postgres >> .env'
			sh 'echo DB_PORT=5432 >> .env'
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
			sh 'echo REDIS_HOST=redis >> .env'
			sh 'echo REDIS_PORT=6379 >> .env'
			sh 'echo LOCAL_URL=http://localhost:3000/ >> .env'
			sh 'echo HEROKU_URL=https://softservedemo.herokuapp.com/ >> .env'
			sh 'echo BACKEND_URL=https://develop-softserve.herokuapp.com/ >> .env'
			sh 'echo MAIL_USERNAME=env.username >> .env'
			sh 'echo MAIL_PASSWORD=env.password >> .env'
			sh 'echo MONGO_DATABASE=schedules >> .env'
			sh 'echo MONGO_SERVER=mongo >> .env'
			sh 'echo FACEBOOK_CLIENT_ID=748342852383540 >> .env'
			sh 'echo FACEBOOK_CLIENT_SECRET=7eacc027056ac2cacdf3ed456598f37e >> .env'
			sh 'echo GOOGLE_CLIENT_ID=593111454680-500ngi1n2a054g480rh8nh53j4b4lb3a.apps.googleusercontent.com >> .env'
			sh 'echo GOOGLE_CLIENT_SECRET=QUp7QSh8FmciiuA6hjT0EBzV >> .env'
			sh 'echo TEST_LOCAL_URL=http://localhost:3000/ >> .env'
			sh 'echo TEST_HEROKU_URL=https://softservedemo.herokuapp.com/ >> .env'
			sh 'echo TEST_MAIL_USERNAME=lastvova123@gmail.com >> .env'
			sh 'echo TEST_MAIL_PASSWORD=softserve1 >> .env'
			sh 'echo TEST_DB_HOST=postgres >> .env'
			sh 'echo TEST_DB_PORT=5432 >> .env'
			sh 'echo TEST_DB_NAME=schedule_test >> .env'
			sh 'echo TEST_DB_USERNAME=schedule_test >> .env'
			sh 'echo TEST_DB_PASSWORD=test >> .env'
   */
			sh 'cat .env'
			sh 'gradle build -x test'
			sh 'mv ./build/libs/class_schedule.war ./artifact/ROOT.war'
		}
	    }
	}
        stage('Docker') {
            steps {
                script {
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
