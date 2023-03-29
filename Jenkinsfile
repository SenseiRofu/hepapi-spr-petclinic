pipeline {
    agent any
    environment {
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        APP_NAME="petclinic"
        APP_REPO_NAME="hepapitask-2/${APP_NAME}-app-dev"
        AWS_ACCOUNT_ID=sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
        AWS_REGION="us-east-1"
        ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        
    }
    stages {

        stage('Prepare Tags for Docker Images') {
            steps {
                echo 'Preparing Tags for Docker Images'
                sh ". ./script/tagdockers.sh"
            }
        }

        stage('Build ECR repo') {
            steps {
                sh 'PATH="$PATH:/usr/local/bin"'
                sh 'APP_REPO_NAME="james/task"'
                sh 'AWS_REGION="us-east-1"'

                sh 'aws ecr describe-repositories --region ${AWS_REGION} --repository-name ${APP_REPO_NAME} || \
                aws ecr create-repository \
                --repository-name ${APP_REPO_NAME} \
                --image-scanning-configuration scanOnPush=false \
                --image-tag-mutability MUTABLE \
                --region ${AWS_REGION}'
                  
            }
        }      
        
        stage('Package and Build Docker Images') {
            steps {
                echo 'Building App Dev Images'
                sh '. ./script/buildandpackage.sh'
            }
        }
        stage('Push Docker Images') {
            steps {
                echo 'Pushing App Dev Images'
                sh '. ./script/pushdockerimage.sh'
            }
        }
        stage('Minikube Start') {
            steps {
                sh 'minikube start'
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