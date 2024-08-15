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
                    docker.build('my-python-app')
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    docker.image('my-python-app').inside {
                        sh '''
                            # Activate the virtual environment and run tests
                            source /venv/bin/activate
                            pip install -r requirements.txt
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