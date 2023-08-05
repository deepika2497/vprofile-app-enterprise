pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    parameters {
        choice(name: 'SERVER', choices: ['QA (13.232.15.25)', 'Stage (13.232.16.28)', 'Production (13.232.17.31)'], description: 'Select the target server for deployment')
    }
    stages {
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
        stage("Extract Version") {
            steps {
                script {
                    def pomFile = readFile 'pom.xml'
                    def version = pomFile.readLines().find { line -> line.contains('<version>') && line.contains('</version>') }
                    version = version.replaceAll(/.*<version>([^<]+)<\/version>.*/, '$1')
                    echo "Latest version from pom.xml: ${version}"
                    env.VERSION = version
                }
            }
        }
        stage("Upload Artifact s3") {
            steps {
                script {
                    sh "aws s3 cp target/vprofile-${env.VERSION}.war s3://automation-practice/vprofile/"
                }
            }
        }
         stage('Deploy') {
            steps {
                script {
                    def serverChoice = params.SERVER.split(' ')[1] // Extract the selected server IP from the choice
                    if (serverChoice == '13.232.15.25') {
                        deployToServer('QA', '13.232.15.25')
                    } else if (serverChoice == '13.232.16.28') {
                        deployToServer('Stage', '13.232.16.28')
                    } else if (serverChoice == '13.232.17.31') {
                        deployToServer('Production', '13.232.17.31')
                    } else {
                        echo "Invalid server selection."
                    }
                }
            }
        }
    }
}

def deployToServer(serverName, serverIP) {
    sshagent(credentials: ['ec2-creds']) {
        sh """
            aws s3 cp s3://automation-practice/vprofile/vprofile-${env.VERSION}.war target/
            scp -o StrictHostKeyChecking=no target/vprofile-${env.VERSION}.war ubuntu@${serverIP}:~/
            ssh -o StrictHostKeyChecking=no ubuntu@${serverIP} 'sudo mv ~/vprofile-${env.VERSION}.war /var/lib/tomcat9/webapps/'
            ssh -o StrictHostKeyChecking=no ubuntu@${serverIP} 'sudo systemctl restart tomcat9'
        """
    }
}
