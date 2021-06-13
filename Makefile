export TF_PLUGIN_CACHE_DIR := ${HOME}/.terraform.d/plugin-cache

.PHONY: clean
clean:
	@mkdir -p ${TF_PLUGIN_CACHE_DIR} || true
	@rm -rf .terraform

.PHONY: init
init: clean
	terraform init

.PHONY: apply
apply:
	terraform apply -input=false -var-file=vars.json

.PHONY: destroy
destroy:
	terraform destroy -input=false -var-file=vars.json
