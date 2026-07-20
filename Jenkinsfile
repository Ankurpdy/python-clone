pipeline {
    agent any

    environment {
        ARCHIVE_NAME = "python-project-${BUILD_NUMBER}.tar.gz"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                bat '''
                python -m venv venv

                call venv\\Scripts\\activate

                python -m pip install --upgrade pip

                if exist requirements.txt (
                    pip install -r requirements.txt
                )
                '''
            }
        }

        stage('Create Artifact') {
            steps {
                bat '''
                tar -czf %ARCHIVE_NAME% ^
                --exclude=venv ^
                --exclude=.git ^
                --exclude=.gitignore ^
                *
                '''
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: '*.tar.gz', fingerprint: true
        }
    }
}