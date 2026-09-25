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
                         credentialsId: "DockerHub_Creds",
                         usernameVariable: "DockerHub_User",
                         passwordVariable: "DockerHub_Pass"
                )]) {
                     echo "Login to DockerHub"

                     sh '''
                         echo "$DockerHub_Pass" | docker login -u "$DockerHub_User" --password-stdin
                     '''

                     sh '''
                         docker image tag flask-app:latest "$DockerHub_User"/two-tier-flask-app:latest
                     '''

                     echo "Push Image to DockerHub"
                    
                     sh '''
                        docker push "$DockerHub_User"/two-tier-flask-app:latest
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
