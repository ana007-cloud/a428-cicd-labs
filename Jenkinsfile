node {
    // Menggunakan Docker dengan Node.js 16
    docker.image('node:16-buster-slim').inside('-p 3000:3000') {
        
        
        // Checkout repository
        stage('Checkout') {
            checkout scm
        }

        // Install dependencies
        stage('Build') {
            echo 'Installing dependencies...'
            sh 'npm install'
        }

        // Build aplikasi React
        stage('Compile') {
            echo 'Building React app...'
            sh 'npm run build'
        }

        // Menjalankan test
        stage('Test') {
            echo 'Running tests...'
            sh './jenkins/scripts/test.sh'
        }

        // Menyimpan hasil build sebagai artifacts
        stage('Archive') {
            echo 'Archiving build artifacts...'
            archiveArtifacts 'build/**'
        }

        // Manual Approval sebelum Deploy
        stage('Manual Approval') {
            script {
                input message: "Lanjutkan ke tahap Deploy?", ok: "Proceed"
            }
        }

        // Menjalankan aplikasi (Deploy)
        stage('Deploy') {
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
