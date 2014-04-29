#!/bin/bash
pwd=`pwd`
echo "Processing git repository..."
if [ ! -d "$pwd/repository/.git" ]; then
  # Clone repository
  git clone ssh://git@github.com/andyjsharp/spaceport.git repository
else
  # Update repository
  cd repository
  git pull
  cd ..
fi
echo "Processing slax scripts..."
echo ""
while IFS=, read col1 col2 col3 col4
do
  echo "Server Name $col1"
  for f in $(find $pwd/repository/scripts -name '*.slax'); 
  do juise spacehub.slax name "$(basename "$f")" script "$f" server "$col2" user "$col3" password "$col4"; 
  done; 
done < servers.csv
echo ""
echo "All done."
