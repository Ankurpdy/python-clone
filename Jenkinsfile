pipeline {
    agent any

    environment {
        TARGET_VM   = 'ankur@192.168.189.128'
        DEPLOY_DIR  = '/home/ankur/deploy'
        SERVICE_NAME= 'myapp'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/Ankurpdy/python-app.git', branch: 'main'
            }
        }

        stage('Compile / Package Artifact') {
            steps {
                sh '''
                    echo "Checking Python code syntax and preparing deployment files..."
                    python3 -m compileall .
                '''
            }
        }

        stage('Deploy Artifacts to VM') {
            steps {
                sh '''
                    # 1. Ensure target deployment directory exists on VM
                    ssh -o StrictHostKeyChecking=no ${TARGET_VM} "mkdir -p ${DEPLOY_DIR}"

                    # 2. Sync application files (excluding git and temp files)
                    rsync -avz --delete \
                      --exclude='.git' \
                      --exclude='__pycache__' \
                      --exclude='*.pyc' \
                      --exclude='venv' \
                      -e "ssh -o StrictHostKeyChecking=no" \
                      ./ ${TARGET_VM}:${DEPLOY_DIR}/
                '''
            }
        }

        stage('Setup Dependencies & Virtual Environment') {
            steps {
                sh '''
                    ssh -o StrictHostKeyChecking=no ${TARGET_VM} '
                        cd /home/ankur/deploy

                        # Create virtual environment if it does not exist
                        if [ ! -d "venv" ]; then
                            python3 -m venv venv
                        fi

                        # Activate venv and install dependencies
                        ./venv/bin/pip install --upgrade pip
                        if [ -f "requirements.txt" ]; then
                            ./venv/bin/pip install -r requirements.txt
                        fi
                    '
                '''
            }
        }

        stage('Restart Service & Reload Nginx') {
            steps {
                sh '''
                    ssh -o StrictHostKeyChecking=no ${TARGET_VM} '
                        sudo systemctl restart myapp
                        sudo systemctl reload nginx
                    '
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    # Wait 2 seconds for app bootup and test response on Port 80
                    sleep 2
                    curl -f -I http://192.168.189.128 || (echo "Healthcheck Failed!" && exit 1)
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