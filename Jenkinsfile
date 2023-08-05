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
       
    }
    stage("Test") {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }
}