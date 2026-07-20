pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Setting up Python environment and installing dependencies...'

                bat '''
                python -m venv venv

                call venv\\Scripts\\activate

                python -m pip install --upgrade pip

                if exist requirements.txt (
                    pip install -r requirements.txt
                ) else (
                    echo requirements.txt not found. Skipping dependency installation.
                )
                '''
            }
        }
    }

    post {
        always {
            echo 'Archiving build artifacts...'

            archiveArtifacts(
                artifacts: '**/*',
                excludes: 'venv/**',
                fingerprint: true,
                allowEmptyArchive: true
            )
        }
    }
}