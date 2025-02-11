resource "aws_iam_role" "irsa" {
  for_each = var.irsa_roles

  name = each.value.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = module.eks[each.value.cluster_key].oidc_provider_arn
        }
        Condition = {
          "StringEquals" = {
            "${replace(module.eks[each.value.cluster_key].oidc_provider_arn, "arn:aws:iam::", "")}:sub" = "system:serviceaccount:${each.value.namespace}:${each.value.service_account}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "irsa_policies" {
  for_each = { for role_name, role in var.irsa_roles : role_name => role if length(role.policies) > 0 }

  name        = each.key
  description = "IAM Policies for ${each.key}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = flatten([
      for policy in each.value.policies : policy.statements
    ])
  })
}

resource "aws_iam_role_policy_attachment" "irsa_attach" {
  for_each = { for role_name, role in aws_iam_role.irsa : role_name => role if length(var.irsa_roles[role_name].policies) > 0 }

  policy_arn = aws_iam_policy.irsa_policies[each.key].arn
  role       = aws_iam_role.irsa[each.key].name
}