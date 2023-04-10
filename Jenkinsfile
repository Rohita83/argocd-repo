pipeline {
    agent any
    environment { // Jenkins -> Credentials -> System -> Global credentials 
        GIT_TOKEN = credentials('GIT_TOKEN')
    }

    stages {
        stage('checkout') {
            steps {
                git branch: "code" ,credentialsId: 'GIT_TOKEN',url: "https://github.com/Rohita83/argocd-repo"
            }
        }
        stage('CODE') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE'){
                sh '''#!/bin/bash
                      pwd
                      ls -lrt
                      echo "Jenkins startred demo1"
                      chmod a+rx ./build_jenkins.sh
                      ./build_jenkins.sh start
                '''
                }
            }
        }
    }
}
