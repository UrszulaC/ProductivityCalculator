The error you're encountering (`externally-managed-environment`) occurs when trying to install packages in a virtual environment on an Ubuntu system that uses the `apt` package manager to manage Python packages. This is part of a newer security feature introduced in Python to prevent conflicting installations between `apt` and `pip`.

To resolve this, here are a few steps you can take to adjust your Jenkinsfile and ensure proper installation of Python packages in your virtual environment:

### Adjusted Jenkinsfile

```groovy
pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *') // Polls the SCM every 5 minutes
    }

    environment {
        DOCKER_IMAGE = 'urszulach/python-app'
        DOCKER_REGISTRY = 'docker.io'
        K8S_DEPLOYMENT = 'productivity-calculator-deployment'
        K8S_NAMESPACE = 'default'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        checkout scm
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        sh '''
                            sudo apt-get update
                            sudo apt-get install -y python3 python3-venv python3-pip mysql-server python3-full
                            python3 -m venv venv  # No sudo here
                            chown -R jenkins:jenkins venv  # Ensure Jenkins owns the venv
                        '''
                    }
                    // Set the path to the virtual environment
                    withEnv(["PATH+VENV=${env.WORKSPACE}/venv/bin"]) {
                        sh '''
                            # Use the pip in the virtual environment to install packages
                            ./venv/bin/pip install --upgrade pip
                            ./venv/bin/pip install --no-warn-script-location -r requirements.txt mysql-connector-python
                        '''
                    }
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        withEnv(["PATH+VENV=${env.WORKSPACE}/venv/bin"]) {
                            sh '''
                                python setup.py bdist_wheel
                            '''
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        sh '''
                            docker build -t ${DOCKER_IMAGE} .
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                            sh '''
                                echo "$DOCKER_PASSWORD" | docker login ${DOCKER_REGISTRY} -u "$DOCKER_USERNAME" --password-stdin
                                docker push ${DOCKER_IMAGE}
                            '''
                        }
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        sh '''
                            kubectl set image deployment/${K8S_DEPLOYMENT} ${K8S_DEPLOYMENT}=${DOCKER_IMAGE} --namespace=${K8S_NAMESPACE}
                            kubectl rollout status deployment/${K8S_DEPLOYMENT} --namespace=${K8S_NAMESPACE}
                        '''
                    }
                }
            }
        }

        stage('Monitor Logs') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        sh '''
                            kubectl logs -f deployment/${K8S_DEPLOYMENT} --namespace=${K8S_NAMESPACE}
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after every build
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
