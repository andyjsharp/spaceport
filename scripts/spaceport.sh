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
echo " "
grep -v '^#' servers.csv | while IFS=, read col1 col2 col3 col4 col5
do
  echo "Server: $col1 ($col2)"
  for f in $(find $pwd/repository/scripts -name '*.slax');
    do juise spaceport.slax name "$(basename "$f")" script "$f" server "$col2" user "$col3" password "$col4" deploy "$col5";
  done;
  for f in $(find $pwd/repository/configlets -name '*.xml');
    do juise spaceport-configlet.slax name "$(basename "$f")" configlet "$f" server "$col2" user "$col3" password "$col4";
  done;
  for f in $(find $pwd/repository/views -name '*.xml');
    do juise spaceport-views.slax name "$(basename "$f")" view "$f" server "$col2" user "$col3" password "$col4";
  done;
done
echo ""
echo "All done."
