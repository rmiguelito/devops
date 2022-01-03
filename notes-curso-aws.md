# Notes AWS
## Infraestrutura global
REGION (Site multiplos datacenters) -> AZ (Zonas de Disponibilidade) -> Pontos de presença (Cache distribuido CDN, CloudFront e Route53)
sa-east-1 -> A, B e C -> Rio de Janeiro, Brasil; São Paulo, Brasil; Bogotá, Colômbia; Buenos Aires, Argentina; Santiago, Chile

## Calculadora de preços da AWS
https://calculator.aws/#/

hints:
1. Deixar sempre os recursos nas mesmas regions para evitar latencia
2. Na virginia sempre é mais barato que sa-east-1 (verificar regulamento abroad)

## Monitoramento de billing
Habilitar monitoramento de billing (receber alertas nivel de gratuidade)
Definir alerta no CloudWatch para fatura chegar em 5 dolares
Metrica de faturamento existe apenas na virginia us-east-1


## Criar Conta
rmiguel.aws@gmail.com
senha new 2021
cartão Nubank
IbmNew2022!

## IAM
1. O user root consegue apagar a conta na AWS, então é boa pratica criar outro user no IAM.
2. Ativar o MFA para a conta root (tirar print do QRCODE)
3. Existem users de console e user de API (pode ser os 2)
4. Tags servem para identificar os serviços, mesmo conceito do K8s

### Usuários
1. Criei o user yan com a role administrator
2. Criar alias da conta, para facilitar a URL de login (Exemplo CNJ = conselho)
3. https://rmiguel-lab.signin.aws.amazon.com/console

### Grupos
1. Permissão inserida diretamente em user, tem precedencia sobre o grupo.
2. Definir permissão por grupos e roles
3. Criação de 2 grupos distintos com roles

### Politica de senha
1. Definir um padrão para senha, tempo de expiração e talz
2. Boa pratica para segurança da cloud
3. Rever parametros

### Politicas de permissão
A vantagem é conseguir definir permissões especificas para usuários ou grupos, quando as politicas existentes não atenderem a necessidade do negocio.
Policies também podem ser de DENY
1. Exemplo de Policies em json
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3-object-lambda:Get*",
                "s3-object-lambda:List*"
            ],
            "Resource": "*"
        }
    ]
}
```
2. Conceder permissão somente do Range X de IP criar um repo no ECR
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ecr:CreateRepository",
            "Resource": "arn:aws:ecr:*:383776957631:repository/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": "210.75.12.75/16"
                }
            }
        }
    ]
}
```
### Funções/Roles
Pelo que entendi as roles são criadas para serviços e elas agrupam policies.
Mas na frente devo entender a aplicabilidade

### Relatório de Acesso
Verificar acessos dos usuários as roles e policies

## VPC - Networking (Amazon Virtual Private Cloud)
A VPC é uma rede na essencia, uma VPC não consegue falar com a outra
Dentro da VPC existem varias SUBNETs, as SUBNETS dentro das VPCs podem ser publicas ou privadas
1. Publica: Acessivel pela internet - Fica tudo que o enduser vai precisar acessar (frontend, api)
2. Privada: Acessivel somente pela AWS (mesmo em outra VPC) - Fica todos os serviços internos (Database, fila)

Cada region vem por default com 1 VPC e com uma SUBNET publica em cada AZ
Boa praticas não usar o VPC e SUBNETS default.
VPC é criada dentro da region e a SUBNET dentro do AZ

### Criando um VPC
1. Criar uma VPC com o CIDR 10.0.0.0/16
2. Habilitar DHCP, DNS e HOSTNAME Resolution
3. my-vpc

### Criando as subnets
Usar o block /16 nas subnets
Criar uma rede publica é uma privada em cada AZ dentro do VPC
```bash
private01 - 10.0.1.0/24 - sa-east-1a
public01 - 10.0.2.0/24 - sa-east-1a
private02 - 10.0.3.0/24 - sa-east-1b
public02 - 10.0.4.0/24 - sa-east-1b
```

### Internet Gateway e Router Table
Router table associada a um internet gateway significa que é uma rede publica
Internet Gateway e a porta de entrada e saida para a internet da nossa VPC

1. Criar um Internet Gateway para a nossa VPC (ig_curso_aws)
2. Attachar o Internet Gateway em nossa VPC
3. Criar duas router tables, public e private, contendo as subnets dentro do nosso VPC (rt_private, rt_public)
4. As routes da rt_private fica do jeito que está, somente acesso local dentro da VPC.
5. Na rt_public adicionar uma route apontando para o internet gateway apontando para os IPs IPV4 e IPV6
0.0.0.0/0
::/0
Essa ação ira fazer os serviços das subnets private01 e private02 serem acessados somente via rede interna, e os serviços da public01 e public02 poderão ser acessados via internet (separação de camadas)

### Security Group X NetworkACL

NetworkACL - Segurança no nivel de rede - aplicado na camada de rede (firewall ativo de rede)
Security Group - Aplicado no nivel de serviço ou instancia (firewall local na estação/sistema operacional)

Boa pratica é usar os dois, na NetworkACL pode ser feita uma regra mais abrangente e no Security Group mais especifico.

### Criando NetworkACL
Por default as NetworkACL que são criadas automaticamente liberam o acesso any to any, e importante criar as suas customizadas.

1. Criar duas NetworkACL private e public e associar as subnets respectivas
2. Verificar se as regras de inbound e outbound estão com DENY all

#### NetworkACL Inbound/Outbound
Ordem das rules faz diferença, é interessante pular de 10 em 10 para ter espaço para criar outras regras no meio.

1. Criar regras de Inbound no public para as portas
22
80
443
2. Criar regras de Outbound no public para as portas
Portas de Controle - 1024 - 65535
80
443
53 tcp/udp

3. Criar regras de Inbound no private para as portas
3306
5432
80
443
22
2. Criar regras de Outbound no private para as portas
portas de controle - 1024-65535
80
443
53 tcp/udp

### Security Group
Firewall a nivel de serviço ou instancia
Criar o SG relacionado a aplicação ou o serviço (sg_my_app)
O trafego outbound normalmente é liberado full, pois é controlado nas NetworkACLs
Security Group somente libera não nega nada, por isso não tem precedencia.

1. Criar sg_webapp e liberar as portas 80 e 443

## EC2 - Elastic Computing Cloud

https://aws.amazon.com/pt/ec2/

### Key Pairs
1. Criar chave formato pem

### Tipos de Instancia
https://aws.amazon.com/pt/ec2/instance-types

Instancias do tipo T geram Creditos de CPU, capacidade de CPU intermitente, pode gerar ** segurando a CPU.
A1 =
T3 =
T3a =
T2 =
M5 =

### Planos das Instancias
1. Sob demanda: usou pagou
2. Spot: Leilão de instancias, a qualquer hora pode ser desligado,
Casos de uso: autoscaling, quero testar algo rapido, aplicação totalmente stateless.
3. Savings Plans: Uma reserva mais flexivel, você reserva o recurso e não a instancia.
4. Instancia Reservada: Reservar o tipo de instancia que vou usar por 1 ano por exemplo, para ganhar desconto.
Mesmo desligada ela vai cobrar
Pagar antes tem desconto
Não pode alterar o tipo de instancia durante o periodo
A região altera o valor do preço
Deixar para reservar somente quando tiver em produção
Faz muito sentido para RDS ou aplicações stateful

### Criando uma instancia

Alterar o tipo de instancia altera o IP publico, o Elastic IP resolve isso.
Get system boot log
Get screenshot
1. Criar uma EC2 CentOS e utilizar a rede public01
2. Logar e instalar o apache
3. Criar Security group para os Linux

### Redes EC2
O IP publico da instancia é dinamico
O IP fixo é o Elastic IP
Ele é gratuito se você estiver usando, ec2 desligado paga e EIP sem estar atachado a nenhuma instancia
Eu posso levar o meu bloco de IP publico para a Amazon se eu quiser
1. Criar um Elastic IP
2. Associar a uma instancia
Se der release no IP, eu não vou conseguir pegar o mesmo.

### Network Interface
E possivel alterar a instancia que está ataxada a interface de rede
1. Adicionar segunda interface na instancia
2. Verificar
3. Adicionar multiplos IPs a segunda interface
4. Associar um EPI a uma interface
5. Dar release no EPI


## EBS - Elastic Block Store
Tipos de volume -
SSD - estado solido
HDD - disco rigido
https://aws.amazon.com/pt/ebs/features/
IO2 - IOPS SSD - SSD maior performance, menor latencia mais caro
IO1 - IOPS SSD - SSD um pouco inferior ao IO2
GP2 - General Purpose - padrão para tudo
ST1 - HDD - Baixo custo e otimizado por taxa de transferencia (logs)
SC1 - Cold HDD - Disco frio, indicado para backup
Magnetic - standard - descontinuado não usar
** Verificar tamanhos minimos e maximos dos volumes
** Os volumes tem que ser criados na mesma zona (AZ) que a sua instancia
** Um volume pode ser migrado entre instancias
1. Criar volume EBS
2. Montar no Linux
** Criar na mesma zona AZ que a instancia


### SNAPSHOT
1. Criar
2. Criar um volume a partir de um snapshot.
3. deletar snapshot3

### Lifecycle Manager
Cron de backup
Backup é feito com base nas tags


## AMI - Imagens de S.O
Podem ter imagens publicas, privadas ou compartilhadas
Imagens são salvas como snapshot
Imagens são baseadas em snapshots
Dispensavel por enquanto

### AWS MARKETPLACE
Tem umas imagenzinhas legais, mas é VM.

## ELB - (Elastic Load Balance)
VIP Maroto
Classic LB = deprecated
Application LB = HTTP, HTTPS - somente L7 (aplicação)
Network LB = TCP, UDP, TLS - somente L4 (transporte)
Com o Network LB é possivel fazer PAT de porta, entra na 5000 e encaminha para 3389
5000 -> 3389

**User Data:** Executa comandos no start da instancia

Load balancer interno - like a service k8s

### Target Group - Agrupa instancias para o LB
1. Criar um ou dois target groups
2. Criar um Application Load Balancer
3. Testar funcionamento
4. Alterar e explorar as rules dentro no APP LB

## SNS - Simple Notification Service
MQ

* FIFO Topics - Fila respeitada rigorosamente, primeiro a entrar, primeiro a sair.
* Standard Topics - Padrão, ordenação pelo melhor esforço (best effort)
https://aws.amazon.com/pt/sns/
Um serviço pode gerar um evento e o topico SNS manda para outro serviço consumir.

Topic é a conf em sí, onde fica as configurações de acesso e permissões
Assinatura é quem consume o serviço

## CloudWatch
Monitoramento
Logs
Metricas
Eventos
Alarme

**Preço:**
free: 5 minutos de range metricas simples
https://aws.amazon.com/pt/cloudwatch/

Alarmes são TOP estudar mais

### Eventos
Eventos geram destinos, que podem ser msg para a SNS, autoscale, criar snapshot
Exemplo de Evento: instancia EC2 desligada ou terminada

Evento -> Target
Eventos baseadas em TAG

Podem ser usados como CRON tb para desligar os servidores

### Logs
Ficar de olho na retenção

## Auto Scaling
E feito horizontalmente
Não há custo adicional, somente o servico escalado.
Metricas vem do cloudWatch

### Launch template - modelo de execução
é um template que pode ser usado para fazer o autoscale

**Alterar a VPC**
Atribuir IP publico por default

### Autoscale Group
Precisa criar um LoadBalancer antes

1. Atribuir IP publico nas subnets por default
2. Criar um Launch template
3. Criar um LoadBalancer e TargetGroup
4. Criar Auto Scaling groups
5. Ver funcionando
6. Configurar ação programada
7. Predictive scaling policies - avg por CPU em uso
8. Dynamic scaling policy - simple scaling olhando para o CloudWatch (alertas)
9. Dynamic scaling policy - step scaling olhando para o CloudWatch
Voce pode fazer etapas para escalar
ex: alerta quantidade de CPU maior que 50% aumenta 1 instancia e maior que 70% aumenta 3 instancias.

## AWS CLI
https://aws.amazon.com/pt/cli/
https://docs.aws.amazon.com/cli/latest/reference/

```bash
aws <service> <subcommand> help
```
1. Instalar
2. Configurar user do IAM
3. S3 no CLI
```bash
aws s3 cp from_local to_bucket
aws s3 rm bucket/file
```
Comando sync é um rsync
4. EC2 no CLI
```bash
aws ec2 describe-instances
aws ec2 describe-instances //usar querys e filters para facilitar
```
5. EBS no CLI
```bash
aws ec2 create-volume --availability-zone us-east-1e --size 3 --volume-type gp2
aws ec2 attach-volume --device "/dev/xvdb" --volume-id vol-klfsaf --instance-id id
```

6. Profiles no CLI
Muitos users no CLI

1. Criar novo profile //igual ao kube context
```bash
aws configure --profile another-account --region sa-east-1
aws s3 ls --profile another-account
```

2. Enviroment variables CLI
```bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY_ID
AWS_DEFAULT_REGION
AWS_CONFIG_FILE
AWS_SHARED_CREDENTIALS_FILE
```
## Metadata
São informações da instancia EC2, tipo uma API local de cada instancia.

A opção IAM Role na criação das instancias ou SDK define o nivel de acesso aos recursos da AWS, a partir desse servidor (FICAR DE OLHO NISSO.)

### UserData
#### Cloudinit
Vai ser executado antes da instancia ligar, é melhor usar terraform com AMI.

## Route53
1. Criar domain no Frenom
http://freenom.com/
2. Criar Zona hospedada //custa 0.50 USD por mes
3. Registrar os nameservers da AWS no Frenom
4. Criar o primeiro registro simples
4.1 tipo A
4.2 tipo CNAME para LB
5. Criar Ponderado //Round Robin com peso
6. Criar registro Geolocalização // Dependendo da geolocalização o endpoint vai ser diferente
6. Criar registro com base em Latencia // Verifica a latencia da Region
7. Criar registro com base em Failover // Fazer multi cloud
Precisa habilitar a verificação de integridade
Pode fazer o failover apontando para uma pagina estatica de erro.
*lab legal*
8. Varios valores - round robin puro
9. Fluxo de trafego - 50doletas por mês
Fluxo de DNS
10. Registrar um dominio na AWS
11. Resolver -

## ACM - AWS Certificate manager
Certificado HTTPS
1. Criando um certificado
2. Aprovar via DNS
3. Criar novo listener 443 no LB
4. Adicionar porta 443 no security group
5. Criar redirecionamento de 80 para 443
6. testar

## RDS //Banco de Dados relacional como Plataforma

## S3 - Simple Storage Service

Ele não é um servidor de arquivos, ele armazena objetos.
Free tier 5G

1. Classes de armazenamento
- S3 Standard // ele é o padrão e mais rapido
- S3 Intelligent Tiering  // Vai migrando os dados entre as categorias automaticamente
- S3 Standard AI // Infrequente Access, mais barato, mas tem custo para restore
- S3 One Zone AI // Mesma coisa do anterior mas só fica em uma AZ
- S3 Glacier e Glacier Deep Archive // tempo de retenção e recomendado para gravação de video por exemplo

Buckets com muitos arquivos pequenos é interessante deixar no Standard ou Intelligent Tiering, pois existe cobrança minima por tamanho e duração
Se o arquivo tiver 1k o s3 vai considerar 128k.

Buckets tem nomes unicos dentro da AWS.

2. Versionamento
3. Logs do S3 para outro S3
4. Permissionamento - Por padrão o acesso publico vem desabilitado
- Existe um generator policy
5. Gerenciamento
- Replicação:
- Ciclo de vida - Rotacionamento
- Inventario
6. Lab Site Estatico
Site estatico, apenas após compilado, então funciona com o react, angular.
Pipeline de build para buildar e jogar para o Bucket.
6.1 Criar Bucket
6.2 Liberar acesso publico de get para a internet
6.3 Habilitar site estatico no S3

## DevOps Tools //Ferramentas de desenvolvimento
### Code Commit
É o repositório de fonte
1. Criar repo
2. Criar um user no IAM e configurar uma HTTPS keys
3. Criar um repo no CodeCommit
4. Conectar no repo
### Code Build
1. Criar um build
2. Criar um bucket s3 para o build
3. Adicionar o buildspec no repo
