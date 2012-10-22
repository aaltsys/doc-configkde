#!/bin/bash
# Script to deploy .rst documents in a git repository to github gh-pages

SECTIONS=""
DOWNLOADS_DIR="_downloads"
DEPLOY_DIR="_deploy"
INCLUDE_DIR="_include"
DEPLOY_GIT="git@github.com:garlovel/config-kde.git"
DEPLOY_BRANCH="gh-pages"
MAKE_METHOD="html"

# in the event it is missing, create a git project deployment folder

mkdir -p $DEPLOY_DIR

if [ ! -d $DEPLOY_DIR/.git ]
then
  cd $DEPLOY_DIR
  git init
  git remote add origin $DEPLOY_GIT
  git fetch origin
  cd ..
fi

# Checkout git branch "gh-pages" in the current repository deployment

cd $DEPLOY_DIR
if [ ! "$(git branch | grep \* | awk '{print $2}')" = $DEPLOY_BRANCH ]
then
  if [ "$(git branch -lr | grep $DEPLOY_BRANCH)" ]
  then
    git checkout $DEPLOY_BRANCH
  else
    git checkout -b $DEPLOY_BRANCH
  fi
fi
cd ..

# Prevent jekyll markup interpretation of directories beginning "_"

if [ ! -e "$DEPLOY_DIR/.nojekyll" ]
then
  touch "$DEPLOY_DIR/.nojekyll"
fi

# Clean the deployment folder and pull the repository branch

rm -rf $DEPLOY_DIR/*

cd $DEPLOY_DIR
git pull origin $DEPLOY_BRANCH
cd ..

# Compile fresh output for one or more books and copy to deployment folder

if [ "$SECTIONS" = "" ]
then
  make clean $MAKE_METHOD
  cp -R _build/$MAKE_METHOD/* ./$DEPLOY_DIR
else
  for DIR in $SECTIONS
  do
    if [ -d $DIR ]
    then
      cd $DIR
      make clean $MAKE_METHOD
      cp -R _build/$MAKE_METHOD ../$DEPLOY_DIR/$DIR
      cd ..
    fi
  done
fi

# Add downloads if they exist

if [ -d $DOWNLOADS_DIR ]
then
  cp -R $DOWNLOADS_DIR $DEPLOY_DIR
fi

# Add static content (remove CNAME if not garlovel)

if [ -d $INCLUDE_DIR ]
then
  cp -R $INCLUDE_DIR/* $DEPLOY_DIR
  if [ "$DEPLOY_GIT" == "${DEPLOY_GIT/garlovel/}" ]
  then
    rm $DEPLOY_DIR/CNAME
  fi
fi

# Deploy the repository branch

if [ -d $DEPLOY_DIR ]
then
  cd $DEPLOY_DIR
  git add .
  git commit -a -m "Deployed documentation"
  git push origin $DEPLOY_BRANCH
  cd ..
fi

echo "Deployed! Be sure that your source changes are commited and pushed as well."

# Authors: Michael Cochran, mcochran@linux.com & Gerald Lovel, gerald@lovels.us
