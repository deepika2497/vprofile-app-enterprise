pipeline {
    agent any
    tools {
        maven 'maven3'
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
        stage('Deploy') {
        steps {
            sshagent(credentials: ['ec2-creds']) {
                
                sh "ssh -o StrictHostKeyChecking=no ubuntu@43.204.236.158 'sudo mv ~/vprofile-${version}.war /var/lib/tomcat9/webapps/'"
                sh "ssh -o StrictHostKeyChecking=no ubuntu@43.204.236.158 'sudo systemctl restart tomcat9'"
            }
        }
    }
    }
}
