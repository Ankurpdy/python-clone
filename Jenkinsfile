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
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate

                    python -m pip install --upgrade pip
                    python -m pip install build

                    if [ -f requirements.txt ]; then
                        pip install -r requirements.txt
                    fi
                '''
            }
        }

        stage('Build Package') {
            steps {
                sh '''
                    . venv/bin/activate

                    python -m build
                '''
            }
        }
    }

    post {
        success {
            archiveArtifacts artifacts: 'dist/*.tar.gz', fingerprint: true
            echo 'Source distribution (.tar.gz) archived successfully.'
        }

        failure {
            echo 'Build failed.'
        }

        always {
            cleanWs()
        }
    }
}