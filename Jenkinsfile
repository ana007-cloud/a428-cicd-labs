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


    }
}