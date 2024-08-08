#/bin/sh
###########################################################################################################################
#                                                                                                                         #
# This script will deploy Computer Vision Demo on a Kubernetes Cluter                                                     #
#                                                                                                                         #
# Spec file is retrieved from GitHub : https://raw.githubusercontent.com/fsa-france/computer-vision-demo/main/cvdemo.yaml #
#                                                                                                                         #
# Once Pod is ready, will wait 5s to get logs from Pod and extract the generated token                                    #
#                                                                                                                         #
# Then will try to get Node IP from AWS, and if not AWS EC2 instance, will use Internal Node IP                           #
#                                                                                                                         #
# Generate and print the URL to access the application                                                                    #
#                                                                                                                         #
###########################################################################################################################


echo ""
echo "## Deploying Computer Vision Demo ##"
echo ""
echo "# Applying spec file cvdemo.yaml"
echo ""
kubectl apply -f https://raw.githubusercontent.com/fsa-france/computer-vision-demo/main/cvdemo.yaml
echo ""
echo "# Waiting for Pod cvdemo-app to be ready (can take few minutes)"
kubectl wait --for=condition=Ready --timeout=300s -n cvdemo pod/cvdemo-app
echo ""
sleep 5
echo "# Retrieving URL to access Computer Vision Demo"
echo ""
EC2IP=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
IPADDR=''
if [ -z $EC2IP ]
then
  echo ""
  echo "You are not running your Kube cluster on EC2 instances"
  echo ""
  echo "Retrieving Internal IP address from kubernetes node information"
  echo ""
  EC2IP=`kubectl get nodes -o json | jq '.items[0].status.addresses[] | select(.type=="InternalIP") | .address'|sed 's/"//g'`
  echo "Your node IP address is : $EC2IP"
  echo ""
else
  echo ""
  echo "You are running your Kube cluster on EC2 instances"
  echo ""
  echo "Your public IP address is : $EC2IP"
  echo ""
fi
SVCPORT=`kubectl get svc -n cvdemo cvdemo-svc -o json| jq -r '.spec.ports[0].nodePort'`
TOKEN=`kubectl logs -n cvdemo cvdemo-app |grep token -m 1| awk -F  '=' {'print $2'}`
URL="http://$EC2IP:$SVCPORT/tree?token=$TOKEN"
echo ""
echo "###########################################################"
echo "#                                                         #"
echo "# Use the follwing URL to connect to Computer Vision Demo #"
echo "#                                                         #"
echo "###########################################################"
echo ""
echo $URL
echo ""
