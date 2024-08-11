pipeline {
    agent any

    environment {
        // Placeholder values, will be overridden by the values from config.py
        HOST = ''
        USER = ''
        PASSWORD = ''
        DATABASE = ''
    }

    stages {
        stage('Install Dependencies') {
            steps {
                // Install necessary packages
                sh '''
                    echo "jenkins" | sudo -S apt-get update
                    echo "jenkins" | sudo -S apt-get install -y python3 python3-venv python3-pip mysql-server
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
                    echo "jenkins" | sudo -S service mysql start
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
        
        stage('Load Config') {
            steps {
                script {
                    // Use Python to extract the variables from config.py and set them as environment variables
                    def configVars = sh(
                        script: '''
                            . venv/bin/activate
                            python3 -c "
import config
print(f'HOST={config.HOST}\\nUSER={config.USER}\\nPASSWORD={config.PASSWORD}\\nDATABASE={config.DATABASE}')
                            "
                        ''',
                        returnStdout: true
                    ).trim()

                    def configMap = configVars.split('\n').collectEntries { it.split('=') }
                    env.HOST = configMap['HOST']
                    env.USER = configMap['USER']
                    env.PASSWORD = configMap['PASSWORD']
                    env.DATABASE = configMap['DATABASE']
                }
            }
        }

        stage('Run Tests') {
            steps {
                // Run unit tests
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
