pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository from version control
                git branch: 'main', url: 'git@github.com:UrszulaC/ProductivityCalculator.git', credentialsId: 'NewSSH'
            }
        }
        
        stage('Set Up Environment') {
                        steps {
                sh 'rm -rf venv' // Delete any existing virtual environment
                sh 'python3 -m venv venv' // Create a new virtual environment
                sh '. venv/bin/activate' // Activate the virtual environment
                sh 'pip install -r requirements.txt' // Install dependencies
            }
        }
    }
}
        stage('Run Tests') {
            steps {
                // Activate virtual environment and run tests
                sh '''
                . venv/bin/activate
                pytest --junitxml=report.xml
                '''
            }
        }
    }

    post {
        always {
            // Archive test reports
            junit 'report.xml'

            // Clean up the workspace
            cleanWs()
        }
        success {
            // Notify of success
            echo 'Build succeeded!'
        }
        failure {
            // Notify of failure
            echo 'Build failed!'
        }
    }
}
