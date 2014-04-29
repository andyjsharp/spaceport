#!/bin/bash
pwd=`pwd`
echo "Processing git repository..."
if [ ! -d "$pwd/repository/.git" ]; then
  # Clone repository
  git clone ssh://git@github.com/repository/repo.git repository
else
  # Update repository
  cd repository
  git pull
  cd ..
fi
echo "Processing slax scripts..."
# Still necessary to read in the list of Space Servers and use their ip address and credentials 
for f in $(find $pwd/repository/scripts -name '*.slax'); do juise spacehub.slax name "$(basename "$f")" script "$f" server "x.x.x.x" user "temp" password "changeme"; done
echo ""
echo "All done."
