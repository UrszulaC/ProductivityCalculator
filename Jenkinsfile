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
                    docker.build('my-python-app:${env.BUILD_ID}')
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    docker.image("my-python-app:${env.BUILD_ID}").inside {
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