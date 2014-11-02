#!/bin/bash
#Author: Sibi <sibi@psibi.in>

# Script for pushing my Hakyll blog pages

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage: sync <git-directory-name>"
    exit 1
fi

cd $1
git checkout source
cp -r ./_site/ /tmp
git checkout master
cp -r /tmp/_site/* ./
git add .
git commit -m "Site updated"
git checkout source
echo "Done, test your site!"

