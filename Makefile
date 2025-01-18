.PHONY: help

CWD=$(shell pwd)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

SCRIPTS_DIR=./scripts

export

build:
	$(SCRIPTS_DIR)/gcp_init.sh

tf_plan: tf_init									## Plan (test) the Terraform infrastructure configuration

	@echo
	@echo
	####
	# Starting 'terraform plan'
	#
	# cd ./$(TF_DIR) && terraform plan $(TF_CMD_OPTIONS)
	@echo
	@cd ./$(TF_DIR) && terraform plan $(TF_CMD_OPTIONS)

tf_apply: tf_init									## Apply (deploy) the Terraform infrastructure configuration to GCP
	@echo
	@echo
	####
	# Starting 'terraform apply'
	#
	# cd ./$(TF_DIR) && terraform apply $(TF_CMD_OPTIONS)
	@echo
	@cd ./$(TF_DIR) && terraform apply $(TF_CMD_OPTIONS)
	@make tf_post_steps

tf_apply_target: tf_init							## Apply only a specific resource, specify with rs='<the.terraform.resource.definition>'
	@echo
	@echo
	####
	# Starting 'terraform apply'
	#
	# cd ./$(TF_DIR) && terraform apply $(TF_CMD_OPTIONS) -target=$(rs)
	@echo
	@cd ./$(TF_DIR) && terraform apply $(TF_CMD_OPTIONS) -target=$(rs)
	@make tf_post_steps

tf_apply_no_refresh: tf_init						## Apply (deploy) without refreshing local state. Use to speed up applying of resource changes, but ONLY if you know your local state is up to date (i.e. you did a normal apply before).
	@echo
	@echo
	####
	# Starting 'terraform apply'
	#
	# cd ./$(TF_DIR) && terraform apply -refresh=false $(TF_CMD_OPTIONS)
	@echo
	@cd ./$(TF_DIR) && terraform apply -refresh=false $(TF_CMD_OPTIONS)
	@make tf_post_steps

tf_import: tf_init									## Import existing GCP resource into terraform state, usage: "make tf_import rs="<the.terraform.resource.definition> <gcp_resource_identifier>"
	@echo
	@echo
	####
	# Starting 'terraform import'
	#
	# cd ./$(TF_DIR) && terraform import $(TF_CMD_OPTIONS) $(rs)
	@echo
	@cd ./$(TF_DIR) && terraform import $(TF_CMD_OPTIONS) $(rs)

tf_state_rm: tf_pre_steps							## Remove a TF resource from the state (stop managing it with terraform) Usage: "make tf_state_rm rs="<the.terraform.resource.definition>"
	@echo
	@echo
	####
	# Starting 'terraform state rm'
	#
	# cd ./$(TF_DIR) && terraform state rm $(rs)
	@echo
	@cd ./$(TF_DIR) && terraform state rm $(rs)

tf_state_mv: tf_pre_steps							## Rename (move) a TF resource in the state. Usage: "make tf_state_mv rs="<the.old.terraform.resource.definition> <the.new.terraform.resource.definition>"
	@echo
	@echo
	####
	# Starting 'terraform state mv'
	#
	# cd ./$(TF_DIR) && terraform state mv $(rs)
	@echo
	@cd ./$(TF_DIR) && terraform state mv $(rs)

vars_download: check_vars print_vars gcloud_check	## Download secret .tfvars file for already set up project.
	@echo
	@echo
	####
	# Downloading "$(TFVARS)" from "gs://$(TF_VAR_tf_bucket_name)"
	#
	# gsutil cp gs://$(TF_VAR_tf_bucket_name)/$(TFVARS) $(TFVARS)
	@echo
	gsutil cp gs://$(TF_VAR_tf_bucket_name)/$(TFVARS) $(TFVARS) 
	@echo

vars_upload: check_vars print_vars gcloud_check		## Upload secret .tfvars files to gs bucket.
	@echo
	@echo
	####
	# Uploading "$(TFVARS)" to "gs://$(TF_VAR_tf_bucket_name)"
	#
	# gsutil cp $(TFVARS) gs://$(TF_VAR_tf_bucket_name)/$(TFVARS)
	@echo
	gsutil cp $(TFVARS) gs://$(TF_VAR_tf_bucket_name)/$(TFVARS)
	@echo

sqlproxy_connect: check_vars print_vars gcloud_check check_tfvars		## Create and download JSON key, and output info to connect to remote database with local Cloud SQL proxy
	@echo
	@echo
	####
	# Creating and downloading new JSON key for the Cloud SQL Proxy service account
	@echo
	$(SCRIPTS_DIR)/create_sql_proxy_key.sh

app_env_vars_info: check_vars print_vars gcloud_check check_tfvars		## Print info about env vars that need to be set in the app for this app environment
	@echo
	@echo
	####
	# Printing env var information for the '$(TF_VAR_gcp_env)' environment
	@echo
	$(SCRIPTS_DIR)/app_env_vars_info.sh


# ------------------------------------------------------
# UTILS
# ------------------------------------------------------
tf_pre_steps: check_vars print_vars gcloud_check check_tfvars backend.conf

tf_init: tf_pre_steps
	@echo
	@echo
	####
	# Initializing Terraform configuration
	#
	# @cd ./$(TF_DIR) && terraform init $(TF_INIT_CMD_OPTIONS)
	@echo
	@cd ./$(TF_DIR) && terraform init $(TF_INIT_CMD_OPTIONS)

backend.conf:
	@echo
	@echo
	####
	# Creating environment specific backend config for terraform in conf file:
	#
	# ./$(TF_DIR)/.working_files/backend_$(TF_VAR_gcp_env).conf
	@echo
	@sed -e "/# Template for Makefile:/d" \
		-e "s/<<__TF_VAR_tf_bucket_name__>>/$(TF_VAR_tf_bucket_name)/g" \
		-e "s/<<__TF_VAR_project__>>/$(TF_VAR_project)/g" \
		./terraform/templates/backend_tpl.conf > ./$(TF_DIR)/.working_files/backend_$(TF_VAR_gcp_env).conf
	@cat ./$(TF_DIR)/.working_files/backend_$(TF_VAR_gcp_env).conf

gcloud_check:
	@echo
	@echo
	####
	# Check GCP project defined in $(ENV_FILE) is active for gcloud CLI
	@echo
	$(eval S:=$(shell gcloud config get-value project))
	@if [ "$(S)" = "$(TF_VAR_project)" ]; then \
		echo "GCP project is: $(TF_VAR_project)"; \
	else \
		echo "GCP current project mismatch: '$(S)'"; \
		echo "Expected: '$(TF_VAR_project)'"; \
		echo "You can set the project with:"; \
		echo; \
		echo "gcloud config set project $(TF_VAR_project)"; \
		echo; \
		echo "Or, if you created a gcloud configuration, activate the correct configuration:"; \
		echo; \
		echo "gcloud config configurations activate <your_config>";\
		echo; \
		echo "Your gcloud configs:"; \
		gcloud config configurations list; \
		echo; \
		exit 2; \
	fi

check_tfvars:
	@echo
	@echo
	####
	# Check that local ${TFVARS} is up-to-date.
	@echo
	$(SCRIPTS_DIR)/check_tfvars.sh

tf_post_steps:
	@echo
	@echo
	####
	# Makefile post steps
	@$(SCRIPTS_DIR)/tf_post_steps.sh

check_vars:
	@echo
	@echo
	####
	# Ensure all needed variables are set
ifndef TF_VAR_api_name
	@echo "Primary app/api name not defined. (Variable TF_VAR_api_name missing.)"
	exit 2
endif 
ifndef TF_VAR_gcp_env
	@echo "App intended environment not defined. (Variable TF_VAR_gcp_env missing.)"
	exit 2
endif 
ifndef TF_VAR_project
	@echo "GCP project id not defined. (Variable TF_VAR_project missing.)"
	exit 2
endif 
ifndef TF_VAR_region
	@echo "GCP compute region not defined. (Variable TF_VAR_region missing.)"
	exit 2
endif 
ifndef TF_VAR_zone
	@echo "GCP compute zone not defined. (Variable TF_VAR_zone missing.)"
	exit 2
endif 
ifndef TF_VAR_tf_bucket_name
	@echo "Terraform state bucket name not defined. (Variable TF_VAR_tf_bucket_name missing.)"
	exit 2
endif 

print_vars:
	@echo
	@echo "-----------------------------------"
	@echo "App name            = $(TF_VAR_api_name)"
	@echo "Environment         = $(TF_VAR_gcp_env)"
	@echo "GCP project id      = $(TF_VAR_project)"
	@echo "Compute region      = $(TF_VAR_region)"
	@echo "Computer zone       = $(TF_VAR_zone)"
	@echo "-----------------------------------"
	@echo "GCP variables       = $(ENV_FILE)"
	@echo "App variables       = $(TFVARS)"
	@echo "Terraform bucket    = $(TF_VAR_tf_bucket_name)"
	@echo "-----------------------------------"
