#!/bin/bash

VERSION="0.1"

#Change output color to green.
setSuccessColor ()
{
  tput setaf 2
}

#Change output color to default.
resetColor ()
{
  tput sgr0
}

#Print with colors, $1 color (green, yellow, red), $2 text to print.
printText ()
{
  case "$1" in
      green)
          tput setaf 2
          printf "$2"
          setSuccessColor
          ;;

      yellow)
          tput setaf 3
          printf "$2"
          setSuccessColor
          ;;

      red)
          tput setaf 1
          printf "$2"
          setSuccessColor
          ;;
      *)
          echo $"Usage: $1 {green|yellow|red} $2 {text to print}}"
          exit 1
  esac
}

case "$1" in
    clean)
        setSuccessColor
        tizen clean
        resetColor
        exit 0
        ;;
    help)
        tput setaf 3
        printText yellow "\n\nTIZEN BUILD SCRIPT v$VERSION\n\n
          Options:
          help  => Show this help message
          clean => Cleans Tizen Project

          Requirements:
          1- Install Tizen SDK with Tizen IDE
          2- Create the project from one of the templates
          3- Create a security profile (on IDE, option Certificate Profiles)
          4- Register your devices (emulator, tv) on the distributor certificate\n
          Folders node_modules and src will be exluded from build by default.\n"
        resetColor
        exit 0
        ;;
esac


printText yellow "\n\nTIZEN BUILD SCRIPT v$VERSION\n\n"
printf "Started at: `date`.\n"

currentUsername=$(whoami)
profileFile=~/workspace/.metadata/.plugins/org.tizen.common.sign/profiles.xml

printText yellow "Setting up Tizen SDK path.\n"
export PATH=$PATH:/Users/${currentUsername}/tizen-sdk/tools/ide/bin
tizen version

#Export CLI profile.
if [ ! -f ${profileFile} ]; then
    printText red "Profile file was not found on ${profileFile}\nMake sure you installed the SDK and your workspace folder is located at \"/Users/{USERNAME}/workspace\".\n"
    printText red "Terminating\n"
    exit 2;
else
    printText yellow "Setting global profile file found on: ${profileFile}\n"
    tizen cli-config -g default.profiles.path=${profileFile}
    printText yellow "Current global CLI values.\n"
    tizen cli-config -l
fi

#Build project
if [ ! -d $(pwd)/node_modules ]; then
    printText yellow "Building project without node_modules folder.\n"
    #Build, add files to exclude here.
    tizen build-web -e .DS_Store package.json ${0##*/}
else
    printText yellow "Building project with node_modules folder.\n"
    #Move node_modules and src folders to tmp, not no include it on package.
    mv $(pwd)/node_modules /tmp
    mv $(pwd)/src /tmp

    #Build, add files to exclude here.
    tizen build-web -e .DS_Store package.json ${0##*/}

    #Move node_modules and src folders back.
    mv /tmp/node_modules $(pwd)/node_modules
    mv /tmp/src $(pwd)/src
fi

#Attempt to get already created security-profile
availableProfiles=$(tizen security-profiles list)
lineNumber=0
profileName=""
currentProject="${PWD##*/}"

while read -r line; do
    ((lineNumber++))
    if [ "$lineNumber" = "9" ]
    then
       profileName="$line"
    fi
done <<< "$availableProfiles"

if [ -z "$profileName" ]; then
    printText red "Could not get profile name needed to sign the application.\n"
    printText red "Terminating\n"
    exit 2
else
    printText yellow "Using profile \"$profileName\" to sign the application.\n"
fi

printText yellow "Building application package.\n"
tizen package --type wgt --sign "$profileName" -- $(pwd)/.buildResult

printText yellow "Moving package to project folder ($(pwd)/${currentProject}.wgt).\n"
mv .buildResult/${currentProject}.wgt $(pwd)

printText yellow "\nFinished at: `date`.\n"
resetColor
exit 0
