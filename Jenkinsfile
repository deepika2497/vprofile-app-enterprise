pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    parameters {
        choice(name: 'SERVER', choices: ['QA', 'Stage', 'Production'], description: 'Select the target server for deployment')
        text(name: 'IP_ADDRESS', defaultValue: '', description: 'Enter the IP address for the selected server')
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
                    def selectedServer = params.SERVER
                    def selectedIP = params.IP_ADDRESS
                    deployToServer(selectedServer, selectedIP)
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
