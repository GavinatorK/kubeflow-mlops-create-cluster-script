#!/bin/bash
#Define the following environment variables

#Region to create the cluster in
export CLUSTER_REGION=us-west-2
#Name of the cluster to create
export CLUSTER_NAME=kubeflow-demo

cd deployments/vanilla/terraform

sed -i 's/?ref=v4.12.0//g' main.tf

#Save the variables to a .tfvars file
cat <<EOF > sample.auto.tfvars
cluster_name="${CLUSTER_NAME}"
cluster_region="${CLUSTER_REGION}"
EOF

#Run the following one-click command to deploy terraform to install EKS infrastructure and Kubeflow
make deploy

export NAMESPACE=kubeflow-user-example-com

wget https://raw.githubusercontent.com/aws-samples/eks-kubeflow-cloudformation-quick-start/9e46662d97e1be7edb0be7fc31166e545655636a/utils/kubeflow_iam_permissions.sh
chmod +x kubeflow_iam_permissions.sh
./kubeflow_iam_permissions.sh $NAMESPACE $CLUSTER_NAME $CLUSTER_REGION

wget https://raw.githubusercontent.com/aws-samples/eks-kubeflow-cloudformation-quick-start/9e46662d97e1be7edb0be7fc31166e545655636a/utils/sagemaker_role.sh
chmod +x sagemaker_role.sh
./sagemaker_role.sh


