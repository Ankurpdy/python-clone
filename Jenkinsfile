pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Environment') {
            steps {
                echo 'Setting up Python environment on Ubuntu...'
                sh '''
                    # Create the virtual environment
                    python3 -m venv venv
                    
                    # Activate environment and install dependencies
                    . venv/bin/activate
                    python3 -m pip install --upgrade pip
                    
                    if [ -f requirements.txt ]; then
                        pip install -r requirements.txt
                    fi
                '''
            }
        }
    }

    post {
        always {
            echo 'Archiving build artifacts...'
            archiveArtifacts artifacts: '**/*', excludes: 'venv/**', fingerprint: true, allowEmptyArchive: true
        }
    }
}