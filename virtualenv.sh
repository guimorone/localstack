#!/bin/bash

NAME="$1"
if [ -z "$NAME" ]; then
  echo "Usage: $0 <name>"
  exit 1
fi

pyenv update
pyenv install 3.12.6
pyenv virtualenv 3.12.6 $NAME
pyenv activate $NAME
pip install -r requirements.txt
