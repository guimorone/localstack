#!/bin/bash
# The structure here was set up thinking about more than 1 type of iac/workspace

ENV=${ENV:-dev}
AWS_REGION=${AWS_REGION:-us-east-1}

NO_COLOR="\033[0m"
ORANGE="\033[0;33m"
BLUE="\033[0;34m"

# Creates both array and hashtable to maintain execution order
if [ "$#" -eq "0" ]; then
  # Add others IacTypes here
  declare -a iac_types=("env")
else
  declare -a iac_types=("$@")
fi

# Add others Workspaces here
declare -A workspaces=(["env"]="test.${AWS_REGION}.${ENV}")

pre() {
  echo -e "${BLUE}Installing tflocal lib...${NO_COLOR}"
  python -m pip install --upgrade terraform-local

  echo -e "${BLUE}Setting environment variables...${NO_COLOR}"
  export AWS_ACCESS_KEY_ID="test"
  export AWS_SECRET_ACCESS_KEY="test"
  export AWS_DEFAULT_REGION="us-east-1"
  export AWS_ENDPOINT_URL="http://127.0.0.1:4566"

  echo -e "${BLUE}Create terraform init backend bucket...${NO_COLOR}"
  aws s3api create-bucket --bucket terraform-states --endpoint-url $AWS_ENDPOINT_URL
}

run_deploy() {
  echo -e "${BLUE}Running $1 infra...${NO_COLOR}"
  cd $1/

  echo -e "${ORANGE}Initing Terraform...${NO_COLOR}"
  tflocal init -upgrade -migrate-state -input=false -backend-config=backends/test.tfbackend
  tflocal workspace select -or-create $2

  echo -e "${ORANGE}Terraform Planning...${NO_COLOR}"
  tflocal plan -var-file="./workspaces/$2.tfvars" -input=false

  echo -e "${ORANGE}Terraform Applying...${NO_COLOR}"
  tflocal apply -var-file="./workspaces/$2.tfvars" -input=false -auto-approve
}

pre
cd ../iac/
for iac_type in "${iac_types[@]}"; do
  run_deploy $iac_type ${workspaces[$iac_type]}
  cd ../
done
