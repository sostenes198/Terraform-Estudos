### Tutorial de exemplo: [https://medium.com/@bm54cloud/deploy-a-kubernetes-cluster-with-terraform-b5bf6a7a369a](https://medium.com/@bm54cloud/deploy-a-kubernetes-cluster-with-terraform-b5bf6a7a369a)


### Instalar `aws-iam-authenticator`: [https://github.com/kubernetes-sigs/aws-iam-authenticator/releases](https://github.com/kubernetes-sigs/aws-iam-authenticator/releases)

### Comando para configurar credenciais na aws-cli: `aws configure`

### Comando para verificar se esta autenticado na aws: `aws sts get-caller-identity`

### Comando para configurar kubetcl: `aws eks update-kubeconfig --region {REGION} --name {NAME_EKS}`

### Comando para exibir o contexto atual: `kubectl config current-context`

### Comando para exibir os contextos do kubectl: `kubectl config get-contexts`

### Comandoalterar contexto do kubectl: `kubectl config use-context`

### Comando exluir contexto do kubectl: `kubectl config delete-context {NAME}`

### Comando para verificar cluster: `kubectl cluster-info`