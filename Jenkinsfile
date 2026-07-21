pipeline {
    agent any

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
                archiveArtifacts artifacts: 'python-app-latest.tar', fingerprint: true
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ankur@192.168.189.128 '
                        # Stop and remove existing container if it exists
                        docker stop python-app-container || true
                        docker rm python-app-container || true

                        # Load artifact tar image back into Docker (ensures artifact integrity)
                        docker load -i /home/ankur/python-app/python-app-latest.tar

                        # Run container binding port 5000 to local localhost
                        docker run -d --name python-app-container --restart unless-stopped -p 127.0.0.1:5000:5000 python-app:latest
                    '
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}