locals {
  nodegroup_arn = module.eks.eks_managed_node_groups[local.node_group_name].iam_role_arn
  map_users = <<-USERS
%{for user in data.aws_iam_group.admins.users}- groups:
  - system:masters
  userarn: ${user.arn}
  username: ${user.user_name}
%{endfor}
USERS

  map_roles = <<-ROLES
  - groups:
    - system:bootstrappers
    - system:nodes
    rolearn: ${local.nodegroup_arn}
    username: system:node:{{EC2PrivateDNSName}}
ROLES
}


resource "kubernetes_namespace" "argo_cd" {
  metadata {
    annotations = {
      name = "argocd"
    }

    labels = {
      namespace = "argocd"
    }

    name = "argocd"
  }

  depends_on = [module.eks.aws_eks_cluster]
}

resource "kubernetes_config_map_v1_data" "aws_auth" {

  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = local.map_users
    mapRoles = local.map_roles
  }
}
