# Git repositories download helper
Shell script to help to download git repositories automatically

It is possible to use this script in two different ways:

### File mode
  You must inform the destination directory where the cloned repos will be storaged and the file(s) that contains the repos' urls
  
#### Usage
```
download_helper --dest <directory> file1 file2 
  
   <directory>      parameter to determine the destination directory of cloned repositories.
   file1 file2      one or more files containing the repos' urls"
```

### Recursive mode
  
  **In this mode is necessary to have the [extract_links.js](https://github.com/brunomateus/markdown-link-extractor) in your path or in the same directory of this script**.
  
  In this mode the script will start to navigate recursively from a informed directory looking for a specifc file in each direcotry, **called .links**
  that basically inform which parameters should be used to extract the urls and after be downloaded.
  
  ```
  File format: directory file-to-extract (start string or start index) (ending-string  or end index)
  Example of .links file: 
  /tmp README.md string1 string2
  ```  
  
#### Usage
```
download_helper --recursive <initial_folder>  
  
   initial_folder    determine the path where the script will start to visit,
   if is not informed, the current directory is used
```
