## Git-bare-repository-generator
Git bare repository generator is a handful script that enables you to take the leverage of deployment via git from your localhost while using git hooks. Feel free to edit the script to suit your needs, e.g. changing the folder structure that you are used to use while running the website on your server (e.g. using /var/www/..)

## Setup
Make sure you copy the script to parent folder of your project. And the folder is writable. We're assuming that you place the bare repository to a separated folder, while the app will run in different folder basically on the same level of directories. E.g.:
```
/usr/share/nginx/html/yourproject/
/usr/share/nginx/html/yourproject/private/
/usr/share/nginx/html/yourproject/src/
```
In this case you copy the genhook.sh to:
```
/usr/share/nginx/html/yourproject/
```

## Usage
The file should be writable, so you need to make the file executable
```
chmod +x genhook.sh
```
Now that the file is executable, we should run it with a parameter that will name the bare repo folder. E.g.:
```
./genhook.sh stage
```
Proceed with filling out what the script asks for you. By the end you should receive how the remote for git looks like. You'll get something like:
```
[remote "stage"]
        url = ssh://user@your-fancy-domain.tld/usr/share/nginx/html/stage/private/stage.git
```
To start with deploying from your localhost you can safely open git config in your local project and add the outputted lines. You can find the config at:
```
.git/config
```
Usually just add it by the end of the config file on a new line.
Now that you have added the remote, you can push to that remote. What bare repository and the hook does is, that whenever you push to that remote, the bare repository will load all the commits, stores the indexes and copy everything to the source folder where your app is running while it respects gitignore. If for some reason the push fails, the problem might be connected to write permissions of the folder where the repository is trying to copy the files. Following the example, you can push to the remote like this:
```
git push stage stage
```
And thats it, you'll also get all the info what is happening on the server.

## How to update hook which is being run after you deploy?
Connect to your server, search for the bare repository folder, head to hooks and edit a file "post-update". Its basically bash, so you can add anything you want to do afterwards.