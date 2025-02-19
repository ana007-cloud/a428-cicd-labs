node {
    def nodeContainer = docker.image('node:16-buster-slim')

    stage('Build') {
        nodeContainer.inside {
            sh 'npm install'
        }
    }

    stage('Test') {
        nodeContainer.inside {
            sh './jenkins/scripts/test.sh'
        }
    }

    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy?'
    }

    stage('Deploy') {
        nodeContainer.inside {
            sh './jenkins/scripts/deliver.sh'

            echo 'Copying deployment files...'
            sh 'cp ./appspec.yml build/'
            sh 'cp -r jenkins/scripts build/scripts/'

            echo 'Archiving build artifacts…'
            archiveArtifacts artifacts: 'build/**', fingerprint: true

            echo 'Waiting for 1 minute…'
            sleep 60

            echo 'Stopping application...'
            sh './jenkins/scripts/kill.sh'
        }
    }

    // Bagian post-execution
    stage('Post') {
        echo 'Pipeline execution completed.'
    }
}

