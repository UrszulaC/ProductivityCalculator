pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/UrszulaC/ProductivityCalculator.git'
            }
        }

        stage('Build and Run') {
            steps {
                script {
                    sh 'docker-compose up -d --build'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh 'docker exec -it $(docker-compose ps -q app) ./wait-for-it.sh mysql:3306 -- python -m unittest discover -s tests -p "*.py"'
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'docker-compose down'
            }
        }
    }
}