pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Compile Python') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate

                    python -m pip install --upgrade pip

                    if [ -f requirements.txt ]; then
                        pip install -r requirements.txt
                    fi

                    # Compile all Python files to .pyc
                    python -m compileall .
                '''
            }
        }

        stage('Create tar.gz') {
            steps {
                sh '''
                    mkdir -p artifact

                    find . -name "*.pyc" -exec cp --parents {} artifact/ \\;

                    tar -czf python-compiled-${BUILD_NUMBER}.tar.gz artifact
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