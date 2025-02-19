node {
    def nodeContainer = docker.image('node:16-buster-slim')

    stage('Prepare Workspace') {
        echo 'Fetching latest repository state...'
        sh '''
            git fetch --all
            git reset --hard origin/react-app
            git clean -fdx
        '''
    }

    stage('Build') {
        nodeContainer.inside("-v ${pwd()}:/workspace -w /workspace") {
            sh 'npm install'
        }
    }

    stage('Test') {
        nodeContainer.inside("-v ${pwd()}:/workspace -w /workspace") {
            sh './jenkins/scripts/test.sh'
        }
    }

    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy?'
    }

    stage('Deploy') {
        nodeContainer.inside("-v ${pwd()}:/workspace -w /workspace") {
            sh '''
                ./jenkins/scripts/deliver.sh

                echo 'Debugging: Checking files before copying...'
                ls -lah
                find . -name "appspec.yml"
                find . -name "scripts"

                echo 'Copying deployment files...'
                mkdir -p build
                cp appspec.yml build/
                cp -r jenkins/scripts build/scripts/

                echo 'Archiving build artifacts…'
                ls -lah build
                archiveArtifacts artifacts: 'build/**', fingerprint: true

                echo 'Waiting for 1 minute…'
                sleep 60

                echo 'Stopping application...'
                ./jenkins/scripts/kill.sh
            '''
        }
    }

    stage('Post') {
        echo 'Pipeline execution completed.'
    }
}


