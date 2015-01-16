#!/bin/bash
function github {
      pwd=`pwd`
      echo "Processing git repository..."
      if [ ! -d "$pwd/repository/.git" ]; then
            # Clone repository
            # ssh://git@github.com/andyjsharp/ScriptsConfigletsViews.git
            git clone $repository repository
      else
            # Update repository
            cd repository
            git pull
            cd ..
      fi
      spaceport
}

function svn {
      echo "svn support not yet implemented."
      exit
}

function usage
{
      echo "usage: spaceport [[-d directory] | [-g github] | [-s svn] | [-h]]"
}

function spaceport {
      echo " "
      grep -v '^#' servers.csv | while IFS=, read col1 col2 col3 col4 col5
      do
            echo "Server: $col1 ($col2)"
            echo "*** Processing SLAX Scripts ***"
            for f in $(find $pwd/repository/scripts -name '*.slax');
                  do juise spaceport.slax name "$(basename "$f")" script "$f" server "$col2" user "$col3" password "$col4" deploy "$col5";
            done;
            echo ""
            echo "*** Processing CLI Configlets ***"
            for f in $(find $pwd/repository/configlets -name '*.xml');
                  do juise spaceport-configlet.slax name "$(basename "$f")" configlet "$f" server "$col2" user "$col3" password "$col4";
            done;
            echo ""
            echo "*** Processing Configuration Views ***"
            for f in $(find $pwd/repository/views -name '*.xml');
                  do juise spaceport-views.slax name "$(basename "$f")" view "$f" server "$col2" user "$col3" password "$col4";
            done;
            echo ""
      done
      echo ""
      echo "All done."
}

###### main
while [ "$1" != "" ]; do
    case $1 in
        -d | --dir )            shift
                                directory=$1
                                ;;
        -g | --git )            shift
                                repository=$1
                                github
                                ;;
        -s | --svn )            shift
                                repository=$1
                                svn
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done


