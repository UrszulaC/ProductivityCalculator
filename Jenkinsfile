pipeline {
    agent any

    stages {
        stage('Install Dependencies') {
            steps {
                // Install necessary packages
                sh '''
                    sudo apt-get update
                    sudo apt-get install -y python3 python3-venv python3-pip mysql-server
                '''
                // Set up Python environment
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt mysql-connector-python
                '''
            }
        }

        stage('Start MySQL Service') {
            steps {
                // Start MySQL service
                sh '''
                    sudo service mysql start
                '''
            }
        }

        stage('Clone Repository') {
            steps {
                // Clone the repository using SSH and specify the branch
                git url: 'git@github.com:UrszulaC/ProductivityCalculator.git', 
                    branch: 'main', 
                    credentialsId: 'your-ssh-credentials-id'
            }
        }
        stage('Load Config') {
    steps {
        script {
            // Load configuration variables from config.py using Python and set them as environment variables
            def configVars = sh(
                script: '''
                    . venv/bin/activate
                    python3 -c "
import config
print(f'HOST={config.HOST}\\nUSER={config.USER}\\nPASSWORD={config.PASSWORD}\\nDATABASE={config.DATABASE}')
                    "
                ''',
                returnStdout: true
            ).trim().split('\n')
            
            for (configVar in configVars) {
                def (key, value) = configVar.split('=')
                env."${key}" = value
            }
        }
    }
}
        stage('Run Tests') {
            steps {
                // Run unit tests in the virtual environment
                sh '''
                    . venv/bin/activate
                    python3 -m unittest discover -s . -p "test.py"
                    '''
            }
        }

    }

    post {
        always {
            // Clean up the workspace
            cleanWs()
        }
        success {
            // Notify success
            echo 'Build and tests succeeded!'
        }
        failure {
            // Notify failure
            echo 'Build or tests failed!'
        }
    }
}
