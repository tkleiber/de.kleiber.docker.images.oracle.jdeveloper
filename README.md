# Docker Image for Oracle JDeveloper

This is the repository for creating a Docker Image from where you can running JDeveloper in Windows.

## Jenkins Pipeline for creating the image:
* At first your Linux VM should contain a local docker registry on port 5000, you can use the default docker registry image for this
* Download jdev_suite_<Version>_linux64.bin and jdev_suite_<Version>_linux64-2.zip to /software/Oracle/JDeveloper
* Create a Jenkins Job from provided Jenkinsfile and start it to build the image and put it to the local registry.

## Starting JDeveloper from Windows
* At first your Linux VM should contain the screen package, you install it like "sudo apt-get -y install screen"
* Start MobaXTerm and connect to your Linux VM via ssh
* Check in the MobaXTerm Banner that X-11 forwarding is enabled
* Mouse hover the MobaXTerm XServer Icon to find the DISPLAY Variable and export this in the shell
* Start SQL Developer via
    * export DISPLAY=&lt;X Server address>
    * sudo docker run -ti --rm --name="jdeveloper.12.2.1.3" -e DISPLAY -v $HOME/.Xauthority:/home/oracle/.Xauthority --net=host localhost:5000/oracle/jdeveloper:12.2.1.3
