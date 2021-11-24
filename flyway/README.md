# Lab Flyway

Este repositório descreve o procedimento para execução de SQL migrations utilizando o Flyway rodando no Kubernetes utilizando a command line com container image customizada e init container.

## Configuração de ambiente

É necessário ter instalado o __Podman__ localmente e um cluster __Kubernetes__ para ambientes de desenvolvimento sugerimos utilizar o Kind [Kind](../kind/README.md)

## Procedimentos

### Instalação e configuração do Banco de dados

1. Instalar e configurar o spawnctl localmente

   ```bash
   curl -sL https://run.spawn.cc/install | sh
   export PATH=$PATH:$HOME/.spawnctl/bin
   ```

1. Criar um data-container para teste com lifetime de 6 horas e coletar as informações do banco de dados

   ```bash
   spawnctl create data-container --image postgres-pagila:v11.0 --name spawn-tutorial --lifetime 6h
   spawnctl get data-container spawn-tutorial -o yaml
   ```

1. Iniciar container do PGADMIN e conectar no database recém criado

   ```bash
   podman run --rm -p 8000:80 -e PGADMIN_DEFAULT_EMAIL=sdmiguelvieira@gmail.com -e     PGADMIN_DEFAULT_PASSWORD=admin docker.io/dpage/pgadmin4
   ```
Para acessar o __PGADMIN__ acesse o endereço http://localhost:8000 efetue login as credenciais informadas nas variaveis PGADMIN_DEFAULT_EMAIL e PGADMIN_DEFAULT_PASSWORD, e configure o acesso ao banco.

### Criação da imagem customizada do Flyway

O diretório sql dentro de [migration](migration) contém os scripts SQL que serão copiados para imagem oficial do Flyway, o diretório temp_sql é usado somente para controlar as versões, inicialmente dentro de sql deixaremos apenas o arquivo PJE_1__create_user.sql para simular a versão 1 da nossa SQL migration.

```bash
podman build -t docker.io/rmiguel/flyway:1 -f migration/Dockerfile
podman login --username *** --password *** docker.io
podman push docker.io/rmiguel/flyway:1
```

### Criação dos objetos kubernetes e execução da migration
O diretório [k8s](k8s) contém os manifests para criação dos objetos no cluster kubernetes.
Os arquivos configmap.yml e secret.yml precisam ser modificados com as configurações do banco de dados que foi criado anteriormente e pode ser visualizados atravez do comando 
```bash 
spawnctl get data-container spawn-tutorial -o yaml
```
O valor a variavel FLYWAY_PASSWORD é o campo password convertido para base64.
```bash
echo -n '<campo_password>' | base64
```

#### Executando criação dos objetos no cluster Kubernetes e rodando a primeira migration
Ajuste o context e namespace do Kubernetes de acordo com a sua infraestrura

```bash
kubectl --context staging create namespace sample-flyway
kubectl --context staging -n sample-flyway apply -f k8s/
```
Identifique o nome do POD que foi criado e verifique nos logs do init container se a migration foi executada com sucesso.

```bash
PODNAME=`kubectl --context staging -n sample-flyway get pods -l app=nginx-deployment -o=jsonpath='{range .items[0]}{.metadata.name}{"\n"}'`
kubectl --context staging -n sample-flyway logs $PODNAME -c flyway-migrate
# output esperado
Flyway is up to date
Flyway Community Edition 8.0.5 by Redgate
Database: jdbc:postgresql://34m49unv.instances.spawn.cc:32737/postgres (PostgreSQL 11.0)
Successfully validated 1 migration (execution time 00:00.686s)
Creating Schema History table "public"."flyway_schema_history" ...
Current version of schema "public": << Empty Schema >>
WARNING: outOfOrder mode is active. Migration of schema "public" may not be reproducible.
Migrating schema "public" to version "1 - create user"
Successfully applied 1 migration to schema "public", now at version v1 (execution time 00:05.363s)
```
Este processo executou o script **PJE_1__create_user.sql** no banco de dados, esse SQL cria o usuário __foo__ e concede algumas permissões verifique no PGADMIN ou via query sql, se o usuário foi criado.


#### Executando a segunda migration

Para executar o segundo script sql via Flyway, precisamos mover o arquivo do diretório **temp_sql** para o **sql**

```bash
mv migration/temp_sql/PJE_2__create_db.sql migration/sql/
```
Executar novamente o procedimente de criação de imagem, porém agora vamos __taggear__ a imagem com tag 2.

```bash
podman build -t docker.io/rmiguel/flyway:2 -f migration/Dockerfile
podman push docker.io/rmiguel/flyway:2
```

Atualize o arquivo **deployment.yml** com a nova tag da imagem que foi construida e execute o apply novamente.

```bash
Alterar linha 23 do arquivo deployment.yml para "image: docker.io/rmiguel/flyway:2"
kubectl --context staging -n sample-flyway apply -f k8s/
```

Verifique novamente os logs do POD

```bash
PODNAME=`kubectl --context staging -n sample-flyway get pods -l app=nginx-deployment -o=jsonpath='{range .items[0]}{.metadata.name}{"\n"}'`
kubectl --context staging -n sample-flyway logs $PODNAME -c flyway-migrate
# output esperado
Flyway is up to date
Flyway Community Edition 8.0.5 by Redgate
Database: jdbc:postgresql://34m49unv.instances.spawn.cc:32737/postgres (PostgreSQL 11.0)
Successfully validated 2 migrations (execution time 00:00.836s)
Current version of schema "public": 1
WARNING: outOfOrder mode is active. Migration of schema "public" may not be reproducible.
Migrating schema "public" to version "2 - create db" [non-transactional]
Successfully applied 1 migration to schema "public", now at version v2 (execution time 00:06.953s)
```
Este processo executou o script **PJE_2__create_db.sql** no banco de dados, esse SQL cria database __foo__ e verifique no PGADMIN ou via query sql, se o usuário foi criado.

Execute o script **PJE_3__grant_privileges.sql** utilizando os mesmos procedimentos executados nessa seção.