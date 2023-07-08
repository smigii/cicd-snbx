  #!/bin/bash

  cd ../../test
  git init --initial-branch=main
  git remote add origin http://10.0.0.88/flavortown/flavortown.git
  git add ./*
  git commit -m "Initial commit"
  git push --set-upstream origin main

