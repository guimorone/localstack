# The structure here was set up thinking about more than 1 type of iac/workspace

$ENV = if ($env:ENV) { $env:ENV } else { "dev" }
$AWS_REGION = if ($env:AWS_REGION) { $env:AWS_REGION } else { "us-east-1" }

# Creates both array and hashtable to maintain execution order
if ($args.Count -eq 0) {
  # Add others IacTypes here
  $IacTypes = @("env")
}
else {
  $IacTypes = $args
}

# Add others Workspaces here
$Workspaces = @{"env" = "test.$AWS_REGION.$ENV" }

function PreDeploy {
  Write-Host -ForegroundColor Blue "Installing tflocal lib..."
  python -m pip install --upgrade terraform-local

  Write-Host -ForegroundColor Blue "Setting environment variables..."
  $env:AWS_ACCESS_KEY_ID = "test"
  $env:AWS_SECRET_ACCESS_KEY = "test"
  $env:AWS_DEFAULT_REGION = "us-east-1"
  $env:AWS_ENDPOINT_URL = "http://127.0.0.1:4566"

  Write-Host -ForegroundColor Blue "Create terraform init backend bucket..."
  aws s3api create-bucket --bucket "terraform-states" --endpoint-url $env:AWS_ENDPOINT_URL
}

function RunDeploy {
  param(
    [Parameter(Position = 0)]
    [string]$IacType,

    [Parameter(Position = 1)]
    [string]$Workspace
  )

  Write-Host -ForegroundColor Blue "Running $IacType infra..."
  Set-Location -Path ".\$IacType\"

  Write-Host -ForegroundColor DarkYellow "Initing Terraform..."
  tflocal init -upgrade -migrate-state -input=false -backend-config=".\backends\test.tfbackend"
  tflocal workspace select -or-create $Workspace

  Write-Host -ForegroundColor DarkYellow "Terraform Planning..."
  tflocal plan -var-file=".\workspaces\$Workspace.tfvars" -input=false

  Write-Host -ForegroundColor DarkYellow "Terraform Applying..."
  tflocal apply -var-file=".\workspaces\$Workspace.tfvars" -input=false -auto-approve
}

PreDeploy
Set-Location -Path '..\iac\'

foreach ($IacType in $IacTypes) {
  RunDeploy $IacType $Workspaces[$IacType]
  Set-Location -Path '..'
}
