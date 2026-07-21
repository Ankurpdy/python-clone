pipeline {
    agent any

    environment {
        VM_HOST = "192.168.189.128"
        VM_USER = "ubuntu"
        APP_DIR = "/home/ubuntu/python-app"
        IMAGE_NAME = "python-app:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-cred',
                    url: 'https://github.com/Ankurpdy/python-clone.git'
            }
        }

        stage('Copy Project to VM') {
            steps {
                sh """
                    rsync -av --delete -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" ./ ankur@192.168.189.128:/home/ankur/python-app/
                """
            }
        }

        stage('Build Docker Image') {
            steps {
              sh '''
                    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                      ${VM_USER}@${VM_IP} "cd ${VM_DIR} && docker build -t python-app:latest ."
                '''
            }
        }
    }
}