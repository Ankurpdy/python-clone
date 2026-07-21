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

        stage('Build & Export Docker Image') {
           steps {
              sh '''
               # 1. Build image on target VM
               ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
               ankur@192.168.189.128 "cd /home/ankur/python-app && docker build -t python-app:latest ."

               # 2. Save image to a .tar archive on the VM
               ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
               ankur@192.168.189.128 "docker save -o /home/ankur/python-app/python-app-latest.tar python-app:latest"

               # 3. Copy the archive back to Jenkins workspace
               scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
               ankur@192.168.189.128:/home/ankur/python-app/python-app-latest.tar ./python-app-latest.tar
        '''
    }
}
        stage('Archive Artifact') {
            steps {
                // 4. Store the .tar file in Jenkins as a build artifact
                archiveArtifacts artifacts: 'python-app-latest.tar', fingerprint: true
            }
        }
    }

    post {
        always {
            // Optional cleanup: remove local tar archive from Jenkins workspace to save disk space
            cleanWs()
        }
    }
}