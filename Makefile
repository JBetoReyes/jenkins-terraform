s3_folder := ./modules/s3
key_gen_command := ssh-keygen -t rsa -N '' -f $(s3_folder)/.ssh/id_rsa

apply:
	terraform apply -var-file="secrets.tfvars"
destroy:
	terraform destroy -var-file="secrets.tfvars"
create-key-folder:
	mkdir $(s3_folder)/.ssh || echo "folder already exists"
create key: create-key-folder
	$(key_gen_command) -y ||  $(key_gen_command)