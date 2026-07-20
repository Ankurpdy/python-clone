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
                echo 'Setting up Python environment on Windows...'
                bat '''
                    :: Create the virtual environment
                    python -m venv venv
                    
                    :: Activate the environment and install dependencies
                    call venv\\Scripts\\activate
                    python -m pip install --upgrade pip
                    
                    if exist requirements.txt (
                        pip install -r requirements.txt
                    )
                '''
            }
        }
    }

    post {
        always {
            echo 'Archiving build artifacts...'
            // Excludes the Windows venv folder from being archived
            archiveArtifacts artifacts: '**/*', excludes: 'venv/** ', fingerprint: true, allowEmptyArchive: true
        }
    }
}