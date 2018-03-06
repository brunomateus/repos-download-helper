#!/bin/bash

usage(){
    echo "Usage file mode: download_helper --dest <directory> file1 file2 ...";
    echo "folder    parameter to determine the destination directory of cloned repositories";
    echo "file1 file2   one or more files containing the repos' urls";
    echo "";
    echo "Usage recursive mode: download_helper --recursive initial_folder";
    echo "initial_folder    determine the path where the script will start to visit, if is not informed, the current directory is used";
}

if [ $# -lt 1 ]; then
    usage;
    exit 1;
fi

while [ "$#" -gt "0" ]
do
  case $1 in
      -h|--help)
          usage
          exit 1
          ;;
      --dest)
          case $2 in
              "") echo "You must inform a destination folder"; exit 1 ;;
               *) if [ ! -d $2 ] ; then 
                   echo "Destination folder does not exist"; 
                   exit 1  
                  else
                      target=$2;
                      shift 2;
                      break;
                  fi
          esac
          ;;
      --recursive)
          if [ $# -gt 2 ] ; then echo "Invalid option"; usage; exit 1; fi
          case $2 in
              "") initialPath='.' ;;
               *) if [ ! -d $2 ] ; then 
                   echo "Initial path does not exist"; 
                   exit 1;  
                  else
                      initialPath=$2;
                      shift 2;
                  fi
          esac
          recursive=true
          break
          ;;
      *) usage; exit 1;
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

if [ recursive ]; then
    folders=$(find $initialPath -type f  -name ".links");
    echo "Looking for new projects ... (starting in $initialPath)"
    for path in $folders; do
        while IFS=" " read -r target source begin end remainder
        do
            node extract_links.js -s ${folders%.links}$source -b $begin -e $end > .links-tmp
            downloadReposFromFile .links-tmp "$target"
            rm .links-tmp
        done < $path
    done
fi


if [ $target ]; then
    while [ "$#" -gt "0" ]
    do
        downloadReposFromFile $1 $target
        shift;
    done
fi

