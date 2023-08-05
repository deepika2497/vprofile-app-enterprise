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
                sh "scp /target/vprofile-1.0.3.war ubuntu@43.204.236.158:~/"
                sh "ssh -o StrictHostKeyChecking=no ubuntu@43.204.236.158 'sudo mv ~/vprofile-1.0.3.war /var/lib/tomcat9/webapps/'"
                sh "ssh -o StrictHostKeyChecking=no ubuntu@43.204.236.158 'sudo systemctl restart tomcat9'"
            }
        }
    }
    }
}
