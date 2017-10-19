#!/bin/sh
echo "Type the REPODIR (default is private), followed by [ENTER]:"
read REPODIR

if [ -z "$REPODIR" ]; then
        REPODIR="private"
fi

echo "The REPODIR is $REPODIR"

echo "Type the CODEDIR (default is src), followed by [ENTER]:"
read CODEDIR

if [ -z "$CODEDIR" ]; then
        CODEDIR="src"
fi

echo "The CODEDIR is $CODEDIR"

if [ -z "$1" ]; then
	echo "You are missing paramater. Right use is ./genhook.sh <repo-name>"
	exit 1
fi

if [ ! -d "./$REPODIR" ] || [ ! -d "./$CODEDIR" ]; then
	echo "The directory structure is not correct. Please check whether you are in the correct directory and directories ./$REPODIR and ./$CODEDIR exist."
	exit 1
fi

if [ -d "./$REPODIR/$1.git" ]; then
	echo "Repository directory $1.git already exists."
	exit 1
fi

if [ "$(ls -A ./$CODEDIR)" ]; then
	while true; do
		read -p "WARNING: Directory ./$CODEDIR is not empty! Genhook will attempt to delete all files there, ok? (y/n): " yn
		case $yn in
			[Yy]* ) echo "Deleting files in ./$CODEDIR..."; rm -rd ./$CODEDIR/*; break;;
			[Nn]* ) echo "Files in ./$CODEDIR were not deleted."; break;;
			* ) echo "Please answer \"y\" or \"n\".";;
		esac
	done
fi

echo "Type in the IP address or DNS pointed to server, followed by [ENTER]:"
read EXTERNALDNS

echo "The EXTERNALDNS is $EXTERNALDNS"

echo "Type in the environment (prod, stage, test..). Usually its the branch you are deploying in our case, followed by [ENTER]:"
read ENVIRONMENT

echo "The ENVIRONMENT is $ENVIRONMENT"

git init --bare ./$REPODIR/$1.git

echo "Creating post-update hook..."

cat << EOF > ./$REPODIR/$1.git/hooks/post-update
#!/bin/sh
git --work-tree=$PWD/$CODEDIR --git-dir=$PWD/$REPODIR/$1.git checkout $ENVIRONMENT -f
cd ../../$CODEDIR

#################
# CUSTOM COMMANDS
# uncomment anything you need or add more:
#################

# npm install
# npm run build
# php app/console assetic:dump --env=prod
# php app/console c:c --env=prod
# php app/console doctrine:schema:update --force
# sudo chmod -R 777 app/cache
# sudo chmod -R 777 app/logs
# gulp
# rm web/config.php
# rm web/app_dev.php
# ...
EOF

chmod a+x ./$REPODIR/$1.git/hooks/post-update

vi ./$REPODIR/$1.git/hooks/post-update

cat << EOF 
Add this to your local .git/config:

[remote "$1"]
	url = ssh://$USER@$EXTERNALDNS$PWD/$REPODIR/$1.git

EOF