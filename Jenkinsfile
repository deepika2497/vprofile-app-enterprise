pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['QA', 'Stage', 'Prod'], description: 'Deployment environment')
        string(name: 'S3_BUCKET', defaultValue: 'vprofile.', description: 'S3 bucket')
    }
    environment {
        version = ''
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    if (params.DEPLOY_ENV == 'QA') {
                        checkout(
                            [$class: 'GitSCM',
                            branches: [[name: '*/develop']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github-vprofile-credentials',
                                url: 'git@github.com:deepika2497/vprofile-app-enterprise.git'
                            ]]
                            ]
                        )
                    } else { 
                        // For Stage and Prod, switch to master branch
                        checkout(
                            [$class: 'GitSCM',
                            branches: [[name: '*/terraform-git']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github-vprofile-credentials',
                                url: 'git@github.com:deepika2497/vprofile-app-enterprise.git'
                            ]]
                            ]
                        )
                    }
                }
            }
        }
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

        // stage('provision server') {
        //     // environment {
        //     //     // AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
        //     //     // AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
        //     //     // TF_VAR_env_prefix = 'test'
        //     // }
        //     steps {
        //         script {
        //             dir('terraform-scripts') {
        //                 sh "terraform init"
        //                 sh "terraform apply --auto-approve"
        //                 // EC2_PUBLIC_IP = sh(
        //                 //     script: "terraform output ec2_public_ip",
        //                 //     returnStdout: true
        //                 // ).trim()
        //             }
        //         }
        //     }
        // }

        // stage("Upload Artifact s3") {
        //     steps {
        //         script {
        //             sh "aws s3 cp target/vprofile-${version}.war s3://${S3_BUCKET}/vprofile-${version}-${DEPLOY_ENV}.war"
        //         }
        //     }
        // }

         stage('Copy') {
            steps {
                sh 'cp target/*.war Docker/'
            }
        }
        stage('Dockerize') {
    steps {
        script {
            dir('Docker') {
                dir('Docker') {
                        sh "docker build -t 851481789693.dkr.ecr.ap-south-1.amazonaws.com/vprofile-qa:vprofileapp-${version} . "
                        sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 851481789693.dkr.ecr.ap-south-1.amazonaws.com'
                        sh "docker push 851481789693.dkr.ecr.ap-south-1.amazonaws.com/vprofile-qa:vprofileapp-${version}"
            }
        }
    }
}

    //     stage('Deploy to CodeDeploy') {
    //     steps {
    //         script {
    //         def deploymentGroup
    //         switch (params.DEPLOY_ENV) {
    //             case 'QA':
    //             deploymentGroup = 'Vprofile-App-qa'
    //             break
    //             case 'Stage':
    //             deploymentGroup = 'Vprofile-App-stage'
    //             break
    //             case 'Prod':
    //             deploymentGroup = 'prod-deployment-group'
    //             break
    //             default:
    //             error('Invalid environment selected')
    //         }

    //         sh "aws deploy create-deployment --application-name  vprofile-new-app --deployment-group-name ${deploymentGroup} --s3-location bucket=deepikanagu-bucket,key=deploy-bundle.zip,bundleType=zip"
    //         }
    //     }
    // }
   }
}
