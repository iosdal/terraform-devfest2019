variable "client_id" {
}
variable "client_secret" {
}
variable "tenant_id" {
}
variable "subscription_id" {
}
variable "location" {
    default = "westeurope"
}
variable "cluster_name" {
    default = "myk8s"
}
variable "agent_count" {
    default = "1"
}
variable "dns_prefix" {
    default = "devfestdemo"
}
variable "terraform_resource_group" {
    default = "devfest"
}
variable "terraform_env" {
    default = "Devfest Demo"
}
variable "terraform_env_owner" {
    default = "ivandal77@gmail.com"
}
