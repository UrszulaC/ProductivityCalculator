pipeline {
    agent any

    environment {
        // Define MySQL environment variables
        HOST = 'mysql'
        USER='ula'
        PASSWORD='Gordito10?'
        DATABASE= 'ProductivityCalculator'
        PORT = '3306'
        
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def sanitizedBuildId = env.BUILD_ID.replaceAll('[^a-zA-Z0-9_.-]', '_')
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
                                . /venv/bin/activate
                            else
                                python -m venv /venv
                                . /venv/bin/activate
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