pipeline {
    agent { label 'dev' }

    stages {
        // 1. Test Jenkins Agent
        stage('Test Agent') {
            steps {
                echo 'Testing Jenkins Agent...'
                sh 'hostname'
                sh 'whoami'
                sh 'java --version'
            }
        }

        // 2. Clone Source Code
        stage('Code Clone') {
            steps {
                echo 'Cloning code from GitHub'
                git branch: 'main',
                    url: 'https://github.com/ankittripathidevs/two-tier-flask-app.git'
            }
        }

        // 3. Scan File (Security)
        stage('Trivy File Scan') {
            steps {
                echo 'Scanning files for vulnerabilities...'
                sh 'trivy fs  --output results.json .'
            }
        }

        // 4. Build Docker Image
        stage('Build') {
            steps {
                echo 'Building Docker image'
                sh 'docker build -t flask-app:latest .'
            }
        }

        // 5. Test Application
        stage('Test') {
            steps {
                echo 'Testing the application'
                // Add automated application tests here.
            }
        }

        // 6. Push Image to Docker Hub
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

                        echo "Tagging Docker image"
                        docker tag flask-app:latest \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"

                        echo "Pushing Docker image"
                        docker push \
                            "$DOCKERHUB_USER/two-tier-flask-app:latest"
                    '''
                }
            }
        }

        // 7. Deploy Application
        stage('Deploy') {
            steps {
                echo 'Deploying the application'
                sh 'docker compose up -d --build'
            }
        }
    }


    // 8. Post-Build Actions and Email Notifications
    post {
        success {
            echo 'Deployment pipeline completed successfully'

            emailext(
                to: 'ankittripathi2k24@gmail.com',
                subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Build completed successfully.
                    Job: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Build URL: ${env.BUILD_URL}
                """
            )
        }

        failure {
            echo 'Deployment pipeline failed'

            emailext(
                to: 'ankittripathi2k24@gmail.com',
                subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    Build failed.
                    Job: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Build URL: ${env.BUILD_URL}
                """
            )
        }
    }
}
