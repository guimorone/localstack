Param(
  [string]$name
)

if ($PSBoundParameters.ContainsKey('name')) {
  pyenv update
  pyenv install 3.12.6
  pyenv local 3.12.6
  pyenv exec python -m pip install --upgrade virtualenv
  pyenv exec python -m venv $name
  Invoke-Expression ".\$name\Scripts\activate"
  pip install -r .\requirements.txt
}
else {
  Write-Host 'No arguments were passed for "name"'
}

