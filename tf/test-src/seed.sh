  #!/bin/bash

  rm -rf .git
  git init
  git config --add --local core.sshCommand 'ssh -i key -p 6022'
  git config user.name "Administrator"
  git config user.email "admin@example.com"
  git checkout -b main
  git remote add origin git@10.0.0.88:flavortown/project0.git
  git add .
  git commit -m "Initial commit"
  git push -f origin main

