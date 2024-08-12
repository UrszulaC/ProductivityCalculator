pipeline {
    agent any

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
                sh '''
                    sudo service mysql start
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    #!/bin/bash

                    set -x  # Enable script debugging

                    if [ -d "venv" ]; then
                        echo "Virtual environment found. Activating..."
                        . venv/bin/activate
                    else
                        echo "Virtual environment not found. Creating..."
                        python3 -m venv venv
                        . venv/bin/activate
                    fi

                    # Verify activation
                    echo "Python executable: $(which python3)"
                    echo "Python version: $(python3 --version)"

                    # Run the tests
                    echo "Running tests..."
                    python3 -m unittest discover -s tests -p 'test.py'

                    set +x  # Disable script debugging
                '''
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