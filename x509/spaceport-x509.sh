#!/bin/bash
pwd=`pwd`
echo "Processing git repository..."
echo "Processing slax scripts..."
echo " "
grep -v '^#' servers.csv | while IFS=, read col1 col2 col3 col4 col5
do
  echo "Creating Session..."
  curl -Lks -c cookies/cookie.jar -o temp/tempdata.txt -E certs/super.pem:pass https://$col2/mainui &min=10
  jsessionid=`grep -e 'JSESSIONID.*"' cookies/cookie.jar | grep -o '".*"'`
  jsessionidsso=`grep -e 'JSESSIONIDSSO.*' cookies/cookie.jar | awk -F" " '{print $7 }'`
  echo "Server: $col1 ($col2)"
  echo "JSESSIONID $jsessionid JSESSIONIDSSO $jsessionidsso"
  for f in $(find $pwd/repository/scripts -name '*.slax');
    do juise spaceport-x509.slax name "$(basename "$f")" script "$f" server "$col2" deploy "$col5" JSESSIONID $jsessionid JSESSIONIDSSO "$jsessionidsso";
  done;
  echo ""
  for f in $(find $pwd/repository/configlets -name '*.xml');
    do juise spaceport-configlet-x509.slax name "$(basename "$f")" configlet "$f" server "$col2" JSESSIONID $jsessionid JSESSIONIDSSO "$JSESSIONIDSSO";
  done;
  echo ""
  for f in $(find $pwd/repository/views -name '*.xml');
    do juise spaceport-views-x509.slax name "$(basename "$f")" view "$f" server "$col2" JSESSIONID $jsessionid JSESSIONIDSSO "$JSESSIONIDSSO";
  done;
  echo ""
done
echo ""
echo "All done."
