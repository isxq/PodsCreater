#!/bin/bash

Cyan='\033[0;36m'
Default='\033[0;m'

projectName=""
companyName=""
httpsRepo=""
sshRepo=""
homePage=""
confirmed="n"
openOnFinish="n"

getProjectName() {
    read -p "Enter Project Name: " projectName

    if test -z "$projectName"; then
        getProjectName
    fi
}

getCompanyName(){
    read -p "Enter Company Name: " companyName
}

getHTTPSRepo() {
    read -p "Enter HTTPS Repo URL: " httpsRepo

    if test -z "$httpsRepo"; then
        getHTTPSRepo
    fi
}

getSSHRepo() {
    read -p "Enter SSH Repo URL: " sshRepo

    if test -z "$sshRepo"; then
        sshRepo=$httpsRepo
    fi
}

getHomePage() {
    read -p "Enter Home Page URL: " homePage

    if test -z "$homePage"; then
        homePage="https://github.com/isxq"
    fi
}

getInfomation() {
    getProjectName
    getCompanyName
    getHTTPSRepo
    getSSHRepo
    getHomePage

    echo -e "\n${Default}================================================"
    echo -e "  Project Name  :  ${Cyan}${projectName}${Default}"
    echo -e "  Company Name  :  ${Cyan}${companyName}${Default}"
    echo -e "  HTTPS Repo    :  ${Cyan}${httpsRepo}${Default}"
    echo -e "  SSH Repo      :  ${Cyan}${sshRepo}${Default}"
    echo -e "  Home Page URL :  ${Cyan}${homePage}${Default}"
    echo -e "================================================\n"
    echo -e "                                                 \   ^__^"
    echo -e "                                                  \  (oo)\_______"
    echo -e "                                                     (__)\       )\/\/"
    echo -e "                                                         ||----w |"
    echo -e "                                                         ||     ||"
}

echo -e "\n"
while [ "$confirmed" != "y" -a "$confirmed" != "Y" ]
do
    if [ "$confirmed" == "n" -o "$confirmed" == "N" ]; then
        getInfomation
    fi
    read -p "confirm? (y/n):" confirmed
done

if [ -d "../${projectName}" ]; then
echo "You have created the project."
else
echo "Generating your project..."
cookiecutter https://github.com/isxq/SubpodsTemplate.git app_name="${projectName}" company_name="${companyName}" --no-input -o ../
ls "../${projectName}"
fi

if [ $? -eq 0 ]; then
mkdir -p "../${projectName}/${projectName}/Pods"

licenseFilePath="../${projectName}/FILE_LICENSE"
specFilePath="../${projectName}/${projectName}.podspec"
readmeFilePath="../${projectName}/readme.md"
uploadFilePath="../${projectName}/upload.sh"
podfilePath="../${projectName}/Podfile"

echo "copy to $licenseFilePath"
cp -n  ./templates/FILE_LICENSE "$licenseFilePath"
echo "copy to $specFilePath"
cp -n  ./templates/pod.podspec  "$specFilePath"
echo "copy to $readmeFilePath"
cp -n  ./templates/readme.md    "$readmeFilePath"
echo "copy to $uploadFilePath"
cp -n  ./templates/upload.sh    "$uploadFilePath"
echo "copy to $podfilePath"
cp -n ./templates/Podfile      "$podfilePath"


echo "editing..."
sed -i "" "s%__ProjectName__%${projectName}%g" "$readmeFilePath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$uploadFilePath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$podfilePath"

sed -i "" "s%__ProjectName__%${projectName}%g" "$specFilePath"
sed -i "" "s%__HomePage__%${homePage}%g"      "$specFilePath"
sed -i "" "s%__HTTPSRepo__%${httpsRepo}%g"    "$specFilePath"
echo "edit finished"

echo "cleaning..."
cd ../$projectName
git init
git remote add origin $sshRepo  &> /dev/null
git rm -rf --cached ./Pods/     &> /dev/null
git rm --cached Podfile.lock    &> /dev/null
git rm --cached .DS_Store       &> /dev/null
git rm -rf --cached $projectName.xcworkspace/           &> /dev/null
git rm -rf --cached $projectName.xcodeproj/xcuserdata/`whoami`.xcuserdatad/xcschemes/$projectName.xcscheme &> /dev/null
git rm -rf --cached $projectName.xcodeproj/project.xcworkspace/xcuserdata/ &> /dev/null
echo "clean finished"
say "finished"
echo "finished!"
else
say "failed"
echo "failed, please retry."
fi
