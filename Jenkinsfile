node {
    def nodeContainer = docker.image('node:16-buster-slim')

    stage('Build') {
        nodeContainer.withRun { c ->
            sh 'npm install'
        }
    }

    stage('Test') {
        nodeContainer.withRun { c ->
            sh './jenkins/scripts/test.sh'
        }
    }

    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy?'
    }

    stage('Deploy') {
        nodeContainer.withRun { c ->
            sh './jenkins/scripts/deliver.sh'

            echo 'Archiving build artifacts…'
            archiveArtifacts artifacts: 'build/**', fingerprint: true

            echo 'Waiting for 1 minute…'
            sleep 60

            echo 'Stopping application...'
            sh './jenkins/scripts/kill.sh'
        }
    }

    post {
        always {
            echo 'Pipeline execution completed.'
        }
    }
}
