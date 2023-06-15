pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    environment {
        version = ''
        deployEnv = ''
    }
    stages {
        stage('Read POM') {
            steps {
                script {
                    def pom = readMavenPom file: 'pom.xml'
                    version = pom.version
                    echo "Project version is: ${version}"
                }
            }
        }
        stage("Build Artifact") {
            steps {
                script {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }
        stage("Choose Deployment Environment") {
            steps {
                script {
                    deployEnv = input(
                        message: 'Select deployment environment:',
                        parameters: [
                            choice(choices: ['qa', 'stage', 'prod'], description: 'Choose the deployment environment')
                        ]
                    )
                    echo "Deployment environment selected: ${deployEnv}"
                }
            }
        }
        stage("Upload Artifact s3") {
            steps {
                script {
                    sh "aws s3 cp target/vprofile-${version}.war s3://automation999/vprofile-artifact/vprofile-${version}.war"
                }
            }
        }
        stage('Deploy') {
            when {
                expression { deployEnv != '' }
            }
            steps {
                script {
                    sshagent(credentials: ['EC2-creds']) {
                        if (deployEnv == 'qa') {
                            sh "ssh -o StrictHostKeyChecking=no ubuntu@qa-server-ip 'sudo mv ~/vprofile-${version}.war /var/lib/tomcat9/webapps/'"
                            sh "ssh -o StrictHostKeyChecking=no ubuntu@qa-server-ip 'sudo systemctl restart tomcat9'"
                        } else if (deployEnv == 'stage') {
                            sh "ssh -o StrictHostKeyChecking=no ubuntu@stage-server-ip 'sudo mv ~/vprofile-${version}.war /var/lib/tomcat9/webapps/'"
                            sh "ssh -o StrictHostKeyChecking=no ubuntu@stage-server-ip 'sudo systemctl restart tomcat9'"
                        } else if (deployEnv == 'prod') {
                            sh "ssh -o StrictHostKeyChecking=no ubuntu@prod-server-ip 'sudo mv ~/vprofile-${version}.war /var/lib/tomcat9/webapps/'"
                            sh "ssh -o StrictHostKeyChecking=no ubuntu@prod-server-ip 'sudo systemctl restart tomcat9'"
                        }
                    }
                }
            }
        }
    }
}