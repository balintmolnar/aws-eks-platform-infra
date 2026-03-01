resource "helm_release" "nginx" {
  chart = "ingress-nginx"
  name  = "ingress-nginx"
  namespace = "ingress-nginx"
  create_namespace = true
  repository = "https://kubernetes.github.io/ingress-nginx"
  depends_on = [var.eks_initialization]

  values = [
    yamlencode({
      controller = {
        service = {
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type"   = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
          }
        }
      }
    })
  ]
}