## Comandos básicos Terraform

```bash
terraform init
terraform plan
terraform validate
terraform apply
terraform destroy
```

Passar lista como variavel:
```bash
terraform init --backend-config="access_key=value" --backend-config="secret_key=value"
terraform apply -var "ibmcloud_api_key=value" -var 'users_to_invite=["yan@gmail.com","karen@gmail.com","camila@gmail.com"]'
terraform destroy -var "ibmcloud_api_key=value"
```