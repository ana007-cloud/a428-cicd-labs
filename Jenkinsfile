node {
    def nodeContainer = docker.image('node:16-buster-slim')

    stage('Prepare Workspace') {
        echo 'Fetching latest repository state...'
        sh '''
        if [ ! -d .git ]; then
            echo "Workspace is empty. Cloning repository..."
            git clone -b react-app https://github.com/ana007-cloud/a428-cicd-labs.git .
        else
            echo "Workspace exists. Fetching latest changes..."
            git fetch --all
            git reset --hard origin/react-app
            git clean -fdx
        fi
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
                find deployment-scripts -type f

                echo 'Copying deployment files...'
                mkdir -p build
                cp appspec.yml build/
                cp -r deployment-scripts build/scripts/

                echo 'Waiting for 1 minute…'
                sleep 60

                echo 'Stopping application...'
                ./jenkins/scripts/kill.sh
            '''
        }

        // Memindahkan `archiveArtifacts` ke dalam blok Groovy agar dikenali oleh Jenkins
        archiveArtifacts artifacts: 'build/**', fingerprint: true

    }

    stage('Post') {
        echo 'Pipeline execution completed.'
    }
}


