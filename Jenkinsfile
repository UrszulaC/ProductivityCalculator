pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *') // Polls the SCM every 5 minutes
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    sudo apt-get update
                    sudo apt-get install -y python3 python3-venv python3-pip mysql-server
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt mysql-connector-python
                '''
            }
        }

        stage('Start MySQL Service') {
            steps {
                sh 'sudo service mysql start'
            }
        }

        stage('Clone Repository') {
            steps {
                git url: 'git@github.com:UrszulaC/ProductivityCalculator.git',
                    branch: 'main',
                    credentialsId: 'NewSSH'
            }
        }

        stage('Load Config') {
            steps {
                script {
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
    