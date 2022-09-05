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
	terraform destroy -var-file="secrets.tfvars"
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
