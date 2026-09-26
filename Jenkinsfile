pipeline {

    agent any;

    stages {
        
        stage("Code Clone") {
            steps {
                echo "Cloning code from GitHub"
                git branch: "main",
                    url: "https://github.com/ankittripathidevs/two-tier-flask-app.git"
            }
        }

        stage("Build") {
            steps {
                echo "Building Docker Image"
                sh "docker build -t flask-app ."
            }
        }

        stage("Test") {
            steps {
                echo "Testing the application"
            }
        }
        
        stage("Push to Docker Hub") {
            steps {
                
                withCredentials([
                    usernamePassword(
                        credentialsId: "DockerHub_Credentials",
                        usernameVariable: "DockerHub_User",
                        passwordVariable: "DockerHub_Pass"
                    )
                ]) {

                    echo "Logging in to Docker Hub"
                    sh 'echo "$DockerHub_Pass" | docker login -u "$DockerHub_User" --password-stdin'
                  
                    echo "Tagging Docker Image"
                    sh 'docker image tag flask-app:latest "$DockerHub_User"/two-tier-flask-app:latest'
            
                    echo "Pushing Docker Image"
                    sh 'docker push "$DockerHub_User"/two-tier-flask-app:latest'
                }
            }
        }

        stage("Deploy") {
            steps {
                echo "Deploying Application"
                sh "docker compose up -d --build"
            }
        }
    }
}
