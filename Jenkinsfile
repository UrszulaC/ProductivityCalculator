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
                    // Build the Docker image
                    docker.build('my-python-app')
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    // Run the Docker container and execute tests in a virtual environment
                    docker.image('my-python-app').inside {
                        sh '''
                            # Activate the virtual environment
                            source /venv/bin/activate
                            # Run tests
                            python -m unittest discover -s tests -p "test.py"
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