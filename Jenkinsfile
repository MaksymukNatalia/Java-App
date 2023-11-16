pipeline {
    agent any
    tools {
	gradle '7.3.3'
    }
    environment {
	envfile = credentials('envfile')
    }
    triggers {
	pollSCM '* * * * *'
    }
    stages {
	stage('Build Gradle') {
            steps { 
	        script {
			sh 'mkdir -p artifact'
			sh 'cat $envfile > .env'
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
        stage('tests the container') {
            steps {
		sh 'sleep 2m'
                sh 'curl http://127.0.0.1:8080'
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
