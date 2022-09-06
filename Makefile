#!make
include .env

s3_folder := ./modules/s3
key_gen_command := ssh-keygen -t rsa -N '' -f $(s3_folder)

apply:
	terraform apply \
	-var-file="secrets.tfvars" \
	-var-file="vpc-development.tfvars" \
	-var-file="compute-development.tfvars"

destroy:
	terraform destroy \
	-var-file="secrets.tfvars" \
	-var-file="vpc-development.tfvars" \
	-var-file="compute-development.tfvars"

create-key-folder:
	mkdir $(s3_folder)/.ssh || echo "folder already exists"
create-key: create-key-folder
	$(key_gen_command)/.ssh/id_rsa -y ||  $(key_gen_command)/.ssh/id_rsa
create-github-key-folder:
	mkdir $(s3_folder)/github_keys || echo "folder already exists"
create-github-key: create-github-key-folder
	$(key_gen_command)/github_keys/id_rsa -y ||  $(key_gen_command)/github_keys/id_rsa
transform-github-app-key:
	openssl pkcs8 -topk8 -inform PEM -outform PEM -in ${app_key_name}.pem -out converted-github-app.pem -nocrypt

create_tf_bucket:
	aws s3 mb s3://jenkins-tf-beto-2022 --region us-west-1

delete_tf_bucket:
	aws s3 rb --force s3://jenkins-tf-beto-2022 --region us-west-1

# https://learn.hashicorp.com/tutorials/terraform/eks#configure-kubectl
config_cluster_locally:
	aws eks --region us-west-1 update-kubeconfig --name jenkins

run_jenkins_master:
	docker run --rm -p 8080:8080  \
    --env JENKINS_ADMIN_ID=beto \
    --env JENKINS_ADMIN_PASSWORD=admin2342 \
    --env GITHUB_TOKEN=${github_token} \
    --env DOCKER_HUB_USER=${docker_hub_user} \
    --env DOCKER_HUB_PASSWORD=${docker_hub_password} \
    --env JENKINS_IP=$EC2_IP \
    -v $EC2_HOME/jenkins_home:/var/jenkins_home \
    --name jenkins jenkins:wizardless

get_secret_name:
	kubectl get serviceaccount jenkins-manager  -o=jsonpath='{.secrets[0].name}' -n jenkins

get_secret_token:
	kubectl get secrets jenkins-manager-token-krbdg -o=jsonpath='{.data.token}' -n jenkins | base64 -D