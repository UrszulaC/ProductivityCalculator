pipeline {
    agent any

    stages {
        stage('Install Dependencies') {
            steps {
                // Update package list and install dependencies using apt
                sh '''
                    sudo apt-get update
                    sudo apt-get install -y python3 python3-venv python3-pip
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                // Clone the repository using SSH and specify the branch
                git url: 'git@github.com:UrszulaC/ProductivityCalculator.git', 
                    branch: 'main', 
                    credentialsId: 'NewSSH'
            }
        }
        
        stage('Set Up Environment') {
            steps {
                // Set up Python environment and install Python dependencies
                sh 'python3 -m venv venv'
                sh '''
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Run Tests') {
            steps {
                // Run tests using pytest
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
            // Notify success
            echo 'Build succeeded!'
        }
        failure {
            // Notify failure
            echo 'Build failed!'
        }
    }
}
