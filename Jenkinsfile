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

    stage("Upload Artifact s3") {
            steps {
                script {
                    sh "aws s3 cp target/vprofile-1.0.3.war s3://automation-practice/vprofile/"
                }
            }
        }
        stage('Deploy') {
    steps {
        sshagent(credentials: ['ec2-creds']) {
            sh """
                scp -o StrictHostKeyChecking=no target/vprofile-1.0.3.war ubuntu@13.233.144.29:~/
                ssh -o StrictHostKeyChecking=no ubuntu@13.233.144.29 'sudo mv ~/vprofile-1.0.3.war /var/lib/tomcat9/webapps/'
                ssh -o StrictHostKeyChecking=no ubuntu@13.233.144.29 'sudo systemctl restart tomcat9'
            """
        }
    }
}

    }
}
