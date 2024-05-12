pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Branch Name: ${env.BRANCH_NAME}"
                    git branch: "${env.BRANCH_NAME}", url: 'https://github.com/jayan/capstone-devops.git'
                }
            }
        }
        stage('Build and Push (Conditional)') {
            steps {
                script {
                    echo "Branch Name: ${env.BRANCH_NAME}"
                    if (env.BRANCH_NAME == 'dev') {
                        sh 'chmod +x build.sh'
                        def buildOutput = sh(script: './build.sh', returnStdout: true).trim()
                        def imageCount = buildOutput.tokenize(':').last()  // Extract the image count
                        echo "Image count: ${imageCount}"
                        sh 'chmod +x deploy.sh'
                        sh "./deploy.sh devchanged ${imageCount}" // Pass only the image count
                    } else if (env.BRANCH_NAME == 'master') {
                        def mergeCommit = sh(script: "git log --merges --first-parent -1 --pretty=format:\"%H\"", returnStdout: true).trim()
                        def isMerged = sh(script: "git branch --contains ${mergeCommit}", returnStdout: true).trim()
                        if (isMerged.contains('* dev')) {
                            echo "Dev branch has been merged to main, executing build and deploy..."
                            echo "checking merges"
                            sh 'git checkout dev' // Switch to dev branch
                            sh 'git pull origin dev' // Pull latest changes from dev branch
                            sh 'chmod +x build.sh'
                            def buildOutput = sh(script: './build.sh', returnStdout: true).trim()
                            def imageCount = buildOutput.tokenize(':').last()  // Extract the image count
                            echo "Image count: ${imageCount}"
                            sh 'chmod +x deploy.sh'
                            sh "./deploy.sh devmergedmain ${imageCount}" // Pass only the image count
                        } else {
                            echo "Dev branch has not been merged to main, skipping build and deploy."
                        }
                    } else {
                        echo "Skipping build and deploy for branch: ${env.BRANCH_NAME}"
                    }
                }
            }
        }
    }
}
