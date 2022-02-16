#!/bin/bash
set -e

# check if necessary commands are available
command -v git > /dev/null 2>&1 || { echo "Git not installed."; exit 1; }

branch=`git rev-parse --abbrev-ref HEAD` #set default stage
echo -e "selected branch $branch"

# Retrieve the modified files, excluding the merge commit
merge_commit_hash=`git rev-parse --short HEAD`
build_commit_hash=`git rev-list --no-merges -n1 HEAD`


files="$(git diff-tree --no-commit-id --name-only -r $build_commit_hash)"
filesNotChanged="!$(git diff-tree --no-commit-id --name-only -r $build_commit_hash)"
packages=()

codebase_packages=("server-api" "web-client")
index=-1
# Retrieve the modified packages
for file in $files
do
  if [[ "$file" == *\/* ]] || [[ "$file" == *\\* ]]
  then
    package="$(echo $file | cut -d '/' -f2)"
    echo -e "$package Changed."
    packages+=($package);
  fi
done

#echo "Changed packages are " ${packages[*]}


#echo ${packages[@]} ${codebase_packages[@]} | tr ' ' '\n' | sort | uniq -u
# compare 2 array named packages and codebase_packages



l2=" ${packages[*]} "                    # add framing blanks
for item in ${codebase_packages[@]}; do
if (( ${#packages[@]} )); then
  if ! [[ $l2 =~ " $item " ]] ; then    # use $item as regexp
    result+=($item)
  fi
  fi
done
#echo  ${result[@]}

if (( ${#result[@]} )); then
    echo "No Changes in " ${result[@]}
    else 
    echo "No Package Changes from last commit"
fi

# for i in "${!codebase_packages[@]}";
#     do
#         if [[ "${codebase_packages[$i]}" = "${package}" ]];
#         then
#             index=$i
#             break
#         fi
#     done
# unset codebase_packages[$index] # removes the first element
# echo "No changed" ${codebase_packages[@]} # prints the array







# # clean and order packages list
# packages=($(echo "${packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
# rootDir=`pwd`

# # launch each package build.sh script if present
# if [ "${#packages[@]}" -gt 0 ]; then

#     for package in ${packages[@]}
#     do
#         priority="$(echo $package | cut -d '/' -f1)"
#         package="$(echo $package | cut -d '/' -f2)"
#         echo -e "- Building $package at version $merge_commit_hash with priority $priority"
#         if [ -f $rootDir/packages/$package/build.sh ]; then
#             echo -e "  build script found"
#             cd $rootDir/packages/$package
#             chmod ug+x build.sh
#            ./build.sh $branch
#         else 
#            echo -e " no buid script found for package $package"  
#         fi
#     done
# else
#     echo "Nothing to build."
# fi
