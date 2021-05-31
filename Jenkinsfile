def getdockertag(){
    return "${env.GIT_BRANCH}".replace("/",".") + "."+"${env.BUILD_ID}"
}  
pipeline {
   agent any
   environment {
        registry= "172.16.3.116:8085"
        DOCKER_TAG = getdockertag()
		NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "172.16.3.116/repository/cicd/"
        NEXUS_REPOSITORY = "cicd"
        NEXUS_CREDENTIAL_ID = "a"
		
		
	}

   stages {
      stage('Build') {
        steps {
			 script {
                 echo 'Building...'
                 sh 'docker-compose up -d'
                 sh 'docker compose exec -it travellist-app_1 && compose update && php artisan key:generate && php artisan migrate --force'
		         dockerImage = docker.build("travellist-app:${env.GIT_BRANCH}".replace("/",".") + "."+"${env.BUILD_ID}")
		         docker.withRegistry( 'http://'+NEXUS_URL, NEXUS_CREDENTIAL_ID ){
                 dockerImage.push(DOCKER_TAG)
		  }
		  
        }
	  }
   }
   
	
   stage('Test') {
     steps {
        echo 'Testing...'
     }
   }
   stage('DockerPush') {
        steps {
          echo 'Building...'
          echo "Running ${env.BUILD_ID} ${env.BUILD_DISPLAY_NAME} on ${env.NODE_NAME} and JOB ${env.JOB_NAME}"
        }
	}
   stage('Deploy_Dev') {
     steps {
        echo 'Deploy_Dev'
     }
   }
   stage('Deploy_Prod') {
     steps {
       echo 'Deploying_Prod'
     }
   }
  }
}
