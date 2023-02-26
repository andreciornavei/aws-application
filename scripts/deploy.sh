# 1º_ARG = AWS_ID
export AWS_ACCESS_KEY_ID=$1
# 2º_ARG = AWS_SECRET
export AWS_SECRET_ACCESS_KEY=$2
# 3º_ARG = AWS_REGION
export AWS_DEFAULT_REGION=$3
# 4º_ARG = AWS ERC IMAGE NAME
export AWS_ECR_IMAGE_NAME=$4

# get aws account id
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
echo $AWS_ACCOUNT_ID

# build docker image
# ***************************************** #
# All --build-arg variables can be defined  #
# throught gitlab environment variables and #
# automatically will be available on this   #
# script when called from .gitlab-ci.yml    #
# ***************************************** #
docker build --no-cache \
--build-arg NODE_ENV=${NODE_ENV} \
-t ${AWS_ECR_IMAGE_NAME} .

# check built image
docker images --filter reference=${AWS_ECR_IMAGE_NAME}

# authenticate to aws ecr
aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${AWS_ECR_IMAGE_NAME}

# Tag the image to push on aws ecr repository.
docker tag ${AWS_ECR_IMAGE_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${AWS_ECR_IMAGE_NAME}:latest

# Push the image
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${AWS_ECR_IMAGE_NAME}:latest
