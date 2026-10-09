pipeline {
    agent any

    stages {
        // 1. Clone source code
        stage('Code Clone') {
            steps {
                echo 'Cloning code from GitHub'
                git branch: 'main',
                    url: 'https://github.com/ankittripathidevs/two-tier-flask-app.git'
            }
        }

        // 2. Build Docker image
        stage('Build') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t flask-app:latest .'
            }
        }

        // 3. Test
        stage('Test') {
            steps {
                echo 'Testing the application'
                // Add actual automated tests here.
                // This stage currently does not run application tests.
            }
        }

        // 4. Log in and push the image to Docker Hub
        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'DockerHub_Credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {
                    sh '''

                        echo "Logging into DockerHub"
                        echo "$DOCKERHUB_PASS" | docker login \
                            --username "$DOCKERHUB_USER" \
                            --password-stdin


                        echo "Tagging Docker Image"
                        docker tag flask-app:latest \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"


                        echo "Pushing Docker Image"
                        docker push \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"

                    '''
                }
            }
        }

        // 5. Deploy with Docker Compose
        stage('Deploy') {
            steps {
                echo 'Deploying the application'
                sh 'docker compose up -d --build'
            }
        }
    }

    // Optional email notifications; requires Jenkins email configuration
    post {
        success {
            echo 'Deployment pipeline completed successfully'
            mail(
                to: 'ankittripathi2k24@gmail.com',
                subject: "SUCCESS: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: "Build successful.\n\nBuild URL: ${env.BUILD_URL}"
            )
        }

        failure {
            echo 'Pipeline failed'
            mail(
                to: 'ankittripathi2k24@gmail.com',
                subject: "FAILURE: ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: "Build failed. Check the console output.\n\nBuild URL: ${env.BUILD_URL}"
            )
        }
    }
}
