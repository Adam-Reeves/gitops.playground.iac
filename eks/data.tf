data "aws_iam_group" "admins" {
  group_name = "admins"
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id

  depends_on = [module.eks.aws_eks_cluster]
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:type"
    values = ["private"]
  }
}

data "kubectl_file_documents" "argocd" {
  content = file("./manifests/argocd.yaml")
}
