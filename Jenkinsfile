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
                            sudo apt-get install -y python3 python3-venv python3-pip mysql-server
                            python3 -m venv venv
                            . venv/bin/activate
                            venv/bin/pip install --upgrade pip
                            venv/bin/pip install -r requirements.txt mysql-connector-python
                        '''
                    }
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    dir('/var/lib/jenkins/workspace/ProductivityCalculator') {
                        sh '''
                            . venv/bin/activate
                            python setup.py bdist_wheel
                        '''
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