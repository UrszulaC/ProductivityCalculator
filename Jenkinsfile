pipeline {
    agent any

    environment {
        // Define MySQL environment variables
        HOST = 'sql'
        USER = 'root'
        PASSWORD = 'gordito'
        DATABASE = 'ProductivityCalculator'
        PORT = '3307'
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
                    docker.build("python-app:${sanitizedBuildId}")
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    def sanitizedBuildId = env.BUILD_ID.replaceAll('[^a-zA-Z0-9_.-]', '_')
                    docker.image("python-app:${sanitizedBuildId}").inside {
                        // Execute shell commands
                        sh '''
                            if [ ! -d /venv ]; then
                                python -m venv /venv
                            fi
                            . /venv/bin/activate
                            pip install -r requirements.txt
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