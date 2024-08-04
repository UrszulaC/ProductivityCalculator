pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // Clone the repository
                git url: 'https://github.com/UrszulaC/ProductivityCalculator.git', branch: 'main'
            }
        }

        stage('Setup') {
            steps {
                // Set up Python environment and install dependencies
                sh '''
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Lint') {
            steps {
                // Lint the code to ensure code quality
                sh '''
                    source venv/bin/activate
                    pylint app.py
                '''
            }
        }

        stage('Test') {
            steps {
                // Run tests and generate test reports
                sh '''
                    source venv/bin/activate
                    python -m xmlrunner discover -s tests -p '*_test.py' -o test-reports
                '''
            }
        }

        stage('Package') {
            steps {
                // Package the application, if applicable
                echo 'Packaging the application...'
                // Example packaging step, adjust as needed
                sh '''
                    source venv/bin/activate
                    python setup.py sdist bdist_wheel
                '''
            }
        }

        stage('Deploy') {
            steps {
                // Deploy the application
                echo 'Deploying application...'
                // Add your deployment steps here
                // e.g., sh './deploy.sh'
            }
        }
    }

    post {
        always {
            // Archive the build artifacts
            archiveArtifacts artifacts: 'dist/*.whl, dist/*.tar.gz', allowEmptyArchive: true

            // Publish test results
            junit 'test-reports/*.xml'

            // Clean up workspace
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
