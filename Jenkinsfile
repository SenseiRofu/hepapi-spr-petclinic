pipeline {
    agent any
    environment {
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        APP_NAME="petclinic"
        APP_REPO_NAME="hepapitask-2/${APP_NAME}-app-dev"
        AWS_ACCOUNT_ID=sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        AWS_REGION="us-east-1"
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        ANS_KEYPAIR="petclinic-${APP_NAME}-dev-${BUILD_NUMBER}.key"
        
    }
    stages {

        stage('Build ECR repo') {
            steps {

                sh 'aws ecr describe-repositories --region ${AWS_REGION} --repository-name ${APP_REPO_NAME} || \
                aws ecr create-repository \
                --repository-name ${APP_REPO_NAME} \
                --image-scanning-configuration scanOnPush=false \
                --image-tag-mutability MUTABLE \
                --region ${AWS_REGION}'
                  
            }
        }  
        stage('Prepare Tags for Docker Images') {
            steps {
                echo 'Preparing Tags for Docker Images'
                script {
                env.IMAGE_TAG_ALL_M="${ECR_REGISTRY}/${APP_REPO_NAME}"
                }
            }
        }
    
        
        stage('Package and Build Docker Images') {
            steps {
                echo 'Building App Dev Images'
                sh '. ./scripts/buildandpackage.sh'
            }
        }
        stage('Push Docker Images') {
            steps {
                echo 'Pushing App Dev Images'
                sh '. ./scripts/pushdockerimage.sh'
            }
        }     
        stage('Deploy App with Kubernetes'){
            steps {
                echo 'Deploying App on Kubernetes Cluster'
                sh 'kubectl apply -f ./petclinic_chart/templates/'
            }
        }
    }
    
}   