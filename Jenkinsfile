pipeline {

    agent any

    stages {
        
        // 1. Clone Source Code
        stage("Code Clone") {
            steps {
                echo "Cloning code from GitHub"
                git branch: "main",
                    url: "https://github.com/ankittripathidevs/two-tier-flask-app.git"
            }
        }

        // 2. Build Docker Image
        stage("Build") {
            steps {
                echo "Building Docker Image"
                sh "docker build -t flask-app ."
            }
        }

        // 3. Test
        stage("Test") {
            steps {
                echo "Testing the application"
                // Add real tests here later
            }
        }
        
        // 4. Login + Push to Docker Hub
        stage("Push to Docker Hub") {
            steps {
                
                withCredentials([
                    usernamePassword(
                        credentialsId: "DockerHub_Creds",
                        usernameVariable: "DockerHub_User",
                        passwordVariable: "DockerHub_Pass"
                    )
                ]) {

                    echo "Logging in to Docker Hub"
                    sh '''
                        echo "$DockerHub_Pass" | docker login -u "$DockerHub_User" --password-stdin
                    '''
                  
                    echo "Tagging Docker Image"
                    sh 'docker image tag flask-app:latest "$DockerHub_User"/two-tier-flask-app:latest'
            
                    echo "Pushing Docker Image"
                    sh 'docker push "$DockerHub_User"/two-tier-flask-app:latest'
                }
            }
        }

        // 5. Deploy
        stage("Deploy") {
            steps {
                echo "Deploying Application"
                sh "docker compose up -d --build"
            }
        }
    }
}
