MVN_VERSION=$(. ${WORKSPACE}/target/maven-archiver/pom.properties && echo $version)
export IMAGE_TAG_ALL_M="${ECR_REGISTRY}/${APP_REPO_NAME}:allmc-v${MVN_VERSION}-b${BUILD_NUMBER}"