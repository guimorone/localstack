# LocalStack

LocalStack testing with terraform

## Dependencies

- Python v3.12.6
- Terraform v1.9.5
- Docker 27.2.0

## Running locally

Check the command for you OS.

1. Create a Virtual Environment:

- Windows (PowerShell)

```powershell
Invoke-Expression ".\virtualenv.ps1"
```

- Linux

```sh
bash virtualenv.sh
```

2. Run terraform:

- Windows (PowerShell)

```powershell
Set-Location -Path ".\scripts\"
Invoke-Expression ".\run-infra.ps1"
```

- Linux

```sh
cd scripts/
bash run-infra.sh
```
