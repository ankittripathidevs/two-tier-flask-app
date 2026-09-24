pipeline {
    
    agent any;
    
    stages {
        stage("Code clone") {
            steps {
                 echo "Cloning the code from Github"
                 git branch: "main",
                     url: "https://github.com/ankittripathidevs/two-tier-flask-app.git"
            }
        }
        stage("Build") {
            steps {
                 echo "Building the docker image"
                 sh "docker build -t flask-app ."
            }
        }
        stage("Test") {
            steps {
                 echo "Testing the application"
            }
        }
        stage("Push to DockerHub") {
            steps {
                 withCredentials([
                     usernamePassword(
                         credentialsId: "dockerHubCreds",
                         usernameVariable: "dockerHubUser",
                         passwordVariable: "dockerHubPass"
                )]) {
                     echo "Login to DockerHub"

                     sh '''
                         echo "$dockerHubPass" | docker login -u "$dockerHubUser" --password-stdin
                     '''

                     sh '''
                         docker image tag flask-app:latest "$dockerHubUser"/two-tier-flask-app:latest
                     '''

                     echo "Push Image to DockerHub"
                    
                     sh '''
                        docker push "$dockerHubUser"/two-tier-flask-app:latest
                     '''
                }
            }
        }
        stage("Deploy") {
            steps {
                 sh "docker compose up -d --build"
            }
        }
    }
}
