pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh '''
                    python3 --version
                    python3 -m compileall .
                '''
            }
        }
    }
}