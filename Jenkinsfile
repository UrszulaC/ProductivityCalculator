pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Sanitize the BUILD_ID by removing any invalid characters
                    def sanitizedBuildId = env.BUILD_ID.replaceAll('[^a-zA-Z0-9_.-]', '_')

                    // Ensure the image name and tag conform to the valid pattern
                    docker.build("my-python-app:${sanitizedBuildId}")
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    def sanitizedBuildId = env.BUILD_ID.replaceAll('[^a-zA-Z0-9_.-]', '_')
                    docker.image("my-python-app:${sanitizedBuildId}").inside {
                        sh '''
                            if [ -d /venv ]; then
                                source /venv/bin/activate
                            else
                                python -m venv /venv
                                source /venv/bin/activate
                                pip install -r requirements.txt
                            fi
                            python -m unittest discover -s tests -p "*.py"
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}