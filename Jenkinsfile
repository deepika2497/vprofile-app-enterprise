pipeline {
    agent any
    tools {
        maven 'maven3'
    }
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['QA', 'Stage', 'Prodt'], description: 'Deployment environment')
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
                            branches: [[name: '*/kubernetes']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github-creds',
                                url: 'git@github.com:deepika2497/vprofile-app-enterprise.git'
                            ]]
                            ]
                        )
                    } else { 
                        // For Stage and Prod, switch to master branch
                        checkout(
                            [$class: 'GitSCM',
                            branches: [[name: '*/kubernetes']],
                            doGenerateSubmoduleConfigurations: false,
                            extensions: [],
                            submoduleCfg: [],
                            userRemoteConfigs: [[
                                credentialsId: 'github-creds',
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
                sh 'cp target/*.war Docker/app/'
            }
        }
        stage('Dockerize') {
            steps {
                script {
                    dir('Docker/app') {
                        sh "docker build -t 278607931101.dkr.ecr.eu-north-1.amazonaws.com/vprofile:${version} . "
                        sh 'aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 278607931101.dkr.ecr.eu-north-1.amazonaws.com'
                        sh "docker push 278607931101.dkr.ecr.eu-north-1.amazonaws.com/vprofile:${version}"
                        sh "sed -i s/%version%/${version}/g /var/lib/jenkins/workspace/staging/eks-files/vapp/deployment.yaml"
                    }
                }
            }
        }
        // stage('Create Deploy Bundle') {
          //  steps {
               // script {
                    //dir('deploy-bundle') {
                     //   sh "sed -i s/%version%/${version}/g ./*"
                       // sh 'zip -r ../deploy-bundle.zip ./*'
                      //  sh "aws s3 cp ../deploy-bundle.zip s3://vprofileqa/deploy-bundle-${version}.zip"
                 //   }
               // }
          //  }
       // }

       stage('Deploy to Eks') {
    steps {
        script {
            def namespace
            switch (params.DEPLOY_ENV) {
                case 'QA':
                    namespace = 'vprofile-eks-qa'
                    break
                case 'Stage':
                    namespace = 'Vprofile-eks-stage'
                    break
                case 'Prodt':
                    namespace = 'vprofile-eks-prodt'
                    break
                default:
                    error('Invalid environment selected')
            }

            sh "kubectl apply -f ./eks-files/vapp/ -n ${namespace}"
            sh "kubectl apply -f ./eks-files/vdb/ -n ${namespace}"
        }
    }
}

            
   }
}
