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

            
            // Install procps (untuk pkill) dengan sudo
            echo 'Installing procps...'
            sh 'apt-get update && apt-get install -y sudo'
            sh 'sudo apt-get install -y procps'

            // Menjalankan aplikasi React dengan perintah nohup dan menjalankan di background
            echo 'Running application...'
            sh 'nohup npm start &'
            
            // Menjeda eksekusi pipeline selama 1 menit
            sleep 60
            
            echo 'Stopping application...'
            // Menghentikan aplikasi React setelah 1 menit
            sh 'pkill -f "npm start"'
        }
    }
}
