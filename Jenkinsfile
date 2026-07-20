pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Pulls the code from your repository
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Setting up Python environment and dependencies...'
                sh '''
                    # Create a virtual environment
                    python3 -m venv venv
                    
                    # Activate environment and install dependencies
                    . venv/bin/activate
                    pip install --upgrade pip
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
            // This archives everything in your workspace except the heavy virtual environment folder
            archiveArtifacts artifacts: '**/*', excludes: 'venv/**', fingerprint: true, allowEmptyArchive: true
        }
    }
}