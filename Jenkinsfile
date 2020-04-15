// simple pipeline example with test NodeJS

pipeline {
    options {
        buildDiscarder (
            logRotator (
                artifactDaysToKeepStr: "",
                artifactNumToKeepStr: "",
                daysToKeepStr: "",
                numToKeepStr: "10"
            )
        )
        disableConcurrentBuilds()
    }
    agent any
    stages {
        stage("Install dependencies") {
            agent {
                dockerfile {
                    filename "Dockerfile.build"
                    args "-v ${PWD}:/usr/src/app -w /usr/src/app"
                    label "build-image"
                    reuseNode true
                }
            }
            steps {
                sh "yarn"
            }
        }
        stage("Run tests") {
            agent {
                dockerfile {
                    filename "Dockerfile.build"
                    args "-u 1000:1000 -v ${PWD}:/usr/src/app -w /usr/src/app"
                    label "build-image"
                    reuseNode true
                }
            }
            steps {
                sh "yarn test || true"
                sh "ansible --version"
            }
        }
    }
    post {
        always {
            step([$class: "WsCleanup"])
            cleanWs()
        }
    }
}
