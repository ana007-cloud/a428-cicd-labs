node {
    // Menggunakan Docker dengan Node.js 16
    docker.image('node:16-buster').inside('-p 3000:3000') {
        
        // Switch to root user
        sh 'USER root'
        
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
