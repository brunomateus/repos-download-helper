#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage";
fi

while [ "$#" -gt "0" ]
do
  case $1 in
      -h|--help)
          echo "Usage"
          ;;
      --dest)
          case $2 in
              "") echo "You must inform a destination folder" ;;
               *) if [ ! -d $2 ] ; then 
                   echo "Destination folder does not exist"; 
                   exit 1  
                  else
                      target=$2;
                      shift 2;
                      break;
                  fi
          esac
          echo "destino $target"
          ;;
      --recursive)
          echo "modo recursive"
          recursive=true
          ;;
      *) echo Usage ; exit 1
  esac
  shift
done  

downloadReposFromFile(){
    while read l; do
            if [[ $l == https* ]] ; then
            projectName=${l##*/};
            projectFolder="$2/$projectName"
                if [ ! -d $projectFolder ]; then
                    echo "Novo projeto encontrado -> [ $projectName ]";
                    git clone "$l.git" "$projectFolder";
                    newRepos+="${path%/*}/$projectName + '\n'";
                    countNewRepos=$((countNewRepos+1));
                fi
            fi
   done < $1
}

if [ $target ]; then
    while [ "$#" -gt "0" ]
    do
        downloadReposFromFile $1 $target
        shift;
    done
fi

