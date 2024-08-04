pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                   sh 'rm -rf ./Deployment_scripts'
                // Use the 'withCredentials' step to inject the GitHub credentials
                withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASSWORD')]) {
                    sh '''
                        # Clone the GitHub repository using HTTPS and credentials
                        git clone https://${GIT_USER}:${GIT_PASSWORD}@github.com/Lavanyaaketi/Deployment_scripts.git
                    '''
                }
            }
        }
        stage('Permission setup') {
            steps {
                sh 'cd /var/lib/jenkins/workspace/cd/Deployment_scripts/'
                //sh 'chmod 777 ./Automation.sh'
            }
        }
        stage('Creating infrastructure') {
            steps {
                sh 'cd /var/lib/jenkins/workspace/cd/Deployment_scripts/Automation.sh'
            }
        }
        stage('2') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "exit 1"
                }
            }
        }
        stage('Hello4') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Hello5') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
