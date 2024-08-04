pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository from version control
                git url: 'https://github.com/UrszulaC/ProductivityCalculator.git', credentialsId: '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'
            }
        }
        
        stage('Set Up Environment') {
            steps {
                // Set up Python environment
                sh 'python3 -m venv venv'
                sh '. venv/bin/activate'
                sh 'pip install -r requirements.txt'
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
