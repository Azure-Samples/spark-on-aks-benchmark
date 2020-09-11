 #!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

podName=""

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

# Get last driver pod name
GetPodName(){
    echo ""
    podName=$(kubectl get pods | awk '{print $1}' | grep -e "driver" | tail -1)
}

kubectlgetpods(){
    kubectl get pods
    pause
}

#
kdescribepods(){

    #pod name
    GetPodName

	echo "Describing pod :" $podName
    echo
    kubectl describe pod $podName
    echo
    pause
}

kpodlogs(){

    #pod name
    GetPodName

	echo "Logs of pod :" $podName
    echo
    kubectl logs $podName
    echo
    pause
}

DeleteDockerImages(){

    echo "Purging docker images"

    docker rmi $(docker images -q) --force

    docker rmi $(docker images -q) --force

}

kgetpvandpvc(){

   kubectl get pv

   kubectl get pvc

   echo
   pause
}

kgetnodesanddescribe(){

   kubectl get nodes

   kubectl describe nodes | more

   echo
   pause
}

# function to display menus
show_menus() {
	clear
	echo "      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "                KUBE COMMAND CENTER"
	echo "      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "          01. Build container image"
	echo "          02. Publish container image"
    echo "          03. Spark submit - Generate Data"
    echo "          04. Spark submit - Run Benchmark"
    echo "          05. K Get Pods"
    echo "          06. K Describe Pod"
    echo "          07. Get Pod logs"
    echo "          08. Delete Pod"
    echo "          09. Delete Docker Images"
    echo "          10. K Get PV and PVC"
    echo "          11. K Get Nodes and Describe"
	echo "      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "                  0. Exit"
    echo "      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}
# read and take a action
read_options(){
	local choice
	read -p "       Enter choice [ 1 - 10 ] " choice
	case $choice in
		1)   ;;
		2)   ;;
        3)   ;;
        4)   ;;
        5) kubectlgetpods  ;;
        6) kdescribepods ;;
        7) kpodlogs ;;
		8) ;;
        9) ;;
        10) kgetpvandpvc ;;
        11) kgetnodesanddescribe ;;
        0) exit 0;;
		*) echo -e "    ${RED}Error...${STD}" && sleep 1
	esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Print the menu
# ------------------------------------
while true
do

	show_menus
	read_options
done