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
terraform apply -var "ibmcloud_api_key=" -var='users_to_invite=["yan@gmail.com","karen@gmail.com","camila@gmail.com"]'
```

terraform destroy -var "ibmcloud_api_key="