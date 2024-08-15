#### [https://developer.hashicorp.com/terraform/language/settings/backends/azurerm#data-source-configuration](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm#data-source-configuration)

### Logs de inicialização dos scripts rodados estão dentro de: `var/log/cloud-init-output.log`

### Comando para inicia configurações do terraform lendo as configurações do backend dinâmicamente: `terraform init -backend-config=./azure-backend.conf -auto-approve`

### Comando para criar chave `ssh`: `ssh-keygen -f azure-key`

### Comando para acessar máquina via `ssh`: `ssh -i azure-key terraform@IP_MAQUINA`

### Comando para stream de logs em um arquivo no ubuntu via ssh: `tail -F {FILE_NAME}`

