variable "kubernetes_cluster_name" {
  type = string
}

variable "kubernetes_cluster_version" {
  type = string
}

variable "eks_tags" {
  type = map(string)
}

variable "kubernetes_cluster_enabled_log_types" {
  type = list(string)
}

