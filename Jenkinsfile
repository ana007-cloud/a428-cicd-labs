pipeline {
    agent {
        docker {
            image 'node:16-buster-slim'
            args '-p 3000:3000'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Compile') {
            steps {
                echo 'Building React app...'
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh './jenkins/scripts/test.sh'
            }
        }

        stage('Archive') {
            steps {
                echo 'Archiving build artifacts...'
                archiveArtifacts 'build/**'
            }
        }

        stage('Manual Approval') {
            steps {
                script {
                    input message: "Lanjutkan ke tahap Deploy?", ok: "Proceed"
                }
            }
        }

        stage('Deploy') {
            steps {
                 echo 'Executing deploy script...'
                // Menjalankan deliver.sh untuk tahap deploy
                sh './jenkins/scripts/deliver.sh'

                echo 'Starting application...'
                // Menjalankan aplikasi React dengan perintah nohup dan menyimpan PID
                sh 'nohup npm start & echo $! > app.pid'
                
                // Menjeda eksekusi pipeline selama 1 menit
                sleep 60

                echo 'Stopping application...'
                // Menghentikan aplikasi React dengan PID yang telah disimpan
                sh 'kill -9 $(cat app.pid)'
            }
        }
    }
    post {
        always {
            echo 'Pipeline selesai dijalankan.'
        }
    }
}
