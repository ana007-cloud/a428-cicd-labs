pipeline {
    agent {
        docker {
            image 'node:16-buster-slim'
            args '-p 3000:3000'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh './jenkins/scripts/test.sh'
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Lanjutkan ke tahap Deploy?'
            }
        }

        stage('Deploy') { 
            steps {

                // Menjalankan build & start aplikasi
                sh './jenkins/scripts/deliver.sh'  
                
                echo 'Archiving build artifacts…'
                // Arsipkan hasil build React
                archiveArtifacts artifacts: 'build/**', fingerprint: true  
                
                echo 'Waiting for 1 minute…'
                // Jeda 1 menit
                sleep 60
                
                echo 'Stopping application...'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution completed.'
        }
    }
}
