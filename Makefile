.PHONY : init repos prometheus-operator kube-prometheus airflow test lint cert-manager rook fluentd-shipper prepare all base-charts cleanup

K8S_CHART_DIR ?= airflow
K8S_MONITORING_NAMESPACE ?= monitoring
K8S_RELEASE_NAME ?= airflow-stage
K8S_RELEASE_NAMESPACE ?= stage
K8S_RELEASE_ENV ?= stage
K8S_HELM_EXTRA_ARGS ?=
K8S_HELM_EXTRA_VAR_FILES ?=
HELMFILE_EXTRA_ARGS ?=

prepare: 
	rm -f $(K8S_CHART_DIR)/charts/*.tgz $(K8S_CHART_DIR)/requirements.lock
	helm dep update $(K8S_CHART_DIR)

helmfile-lint: prepare
	helmfile -f helmfiles/airflow.yaml lint $(K8S_HELM_EXTRA_VAR_FILES) --args '$(K8S_HELM_EXTRA_ARGS)' $(HELMFILE_EXTRA_ARGS)
	helmfile -f helmfiles/airflow.yaml diff --suppress-secrets $(K8S_HELM_EXTRA_VAR_FILES) --args '$(K8S_HELM_EXTRA_ARGS)' $(HELMFILE_EXTRA_ARGS)

helmfile-apply-all: helmfile-base-charts
	helmfile -f helmfiles/airflow.yaml apply --suppress-secrets $(K8S_HELM_EXTRA_VAR_FILES) --args '$(K8S_HELM_EXTRA_ARGS)' $(HELMFILE_EXTRA_ARGS)

helmfile-airflow: prepare
	helmfile -f helmfiles/airflow.yaml apply --suppress-secrets $(K8S_HELM_EXTRA_VAR_FILES) --args '$(K8S_HELM_EXTRA_ARGS)' $(HELMFILE_EXTRA_ARGS)

helmfile-base-charts: prepare
	kubectl --validate=false apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.13/deploy/manifests/00-crds.yaml
	helmfile apply --suppress-secrets
