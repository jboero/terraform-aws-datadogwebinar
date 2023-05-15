module "datadog" {
    source = "./modules/datadog"

    application_name = var.application_name
    aws_region = var.aws_region
    datadog_api_key = var.datadog_api_key
    datadog_app_key = var.datadog_app_key
    org_name = var.org_name
    DD_CLIENT_TOKEN = var.DD_CLIENT_TOKEN
    DD_APPLICATION_ID = var.DD_APPLICATION_ID
}

module "eCommerce_app" {
    source = "./modules/eCommerce_app"
}

module "eks-cluster" {
    source = "./modules/eks-cluster"
    aws_region = var.aws_region
    vpc_name = var.vpc_name
}

module "Kubernetes_App" {
    source = "./modules/Kubernetes_App"
    aws_region = var.aws_region
    org_name = var.org_name
    datadog_app_key = var.datadog_app_key
    datadog_api_key = var.datadog_api_key
    DD_CLIENT_TOKEN = var.DD_CLIENT_TOKEN
    DD_APPLICATION_ID = var.DD_APPLICATION_ID
    application_name = var.application_name
}