Incluir depois ou estudar
DevOps Insights
CRA
Docker Lint
Unit-tests - acho que dá para fazer melhor com o Maven

Vamos usar Dockerfile ou S2I?
Se for usar Dockerfile o arquivo vai ficar no repo da aplicação?


source <(curl -sSL "https://us-south.git.cloud.ibm.com/open-toolchain/commons/-/raw/main/scripts/check_and_deploy_kubectl.sh")

**Shift left:** executar pipeline de testes, a cada PR/MR, isso ajuda a identificar problemas e vulnerabilidades mais cedo, em tempo de build.

**Pipeline ToolChain Simples**

Issues -> Repo App                -> CI                            -> CD
          Repo Tekton Pipelines       -> Clone                       -> Deploy App (STG)
          Repo Tekton Catalog         -> Build App                   -> Deploy App (PRD)
                                      -> Unit Tests
                                      -> Static Analysis (Sonar)
                                      -> Build/Push Container Image
                                      -> Deploy App (DEV)

**Pipeline ToolChain DevSecOps**

Issues -> Repo App                -> CI                                             -> CD                            -> Learn
          Repo Tekton Pipelines       -> Clone                                         -> Change Request Process        -> DevOps Insights
          Repo Tekton Catalog         -> Build App                                     -> Deploy App (STG)
                                      -> Unit Test                                     -> Deploy App (PRD)
                                      -> Static Analysis (Sonar)
                                      -> Code Risk Analyzer (CRA)
                                      -> Sign Image (Skopeo)
                                      -> Build/Push Container Image
                                      -> Deploy App (DEV)
                                      -> Dinamic Analysis (ZAP API SCAN)
                                      -> Container Image Scan (Compliance Baseimage)
                                      -> Push all compliance evidence to Evidence Storage
                                      -> Trigger PR inventory integration


Esse Fluxo inclui também o pipeline de PR/MR para aplicar o Shift Left


**Estou analisando os seguintes opções:**
1. CI/CD with DevSecOps practices (Utilizar o template toolchain de DevSecOps, ele é bem completo mas também e muito mais complexo)
2. Develop a Kubernetes app (com ou sem Helm): (É um template mais simples que o DevSecOps)
3. Build your own toolchain (Criar o nosso toolchain do zero)
5. Não utilizar o toolchain da IBM Cloud (Criar a nossa propria stack com outras ferramentas)


**Contras Toolchain pronto**
Muitos scripts SH no repo e no toolchain
Muita duplicidade de codigo no toolchain (codigo repetido)
Manifests Kubernetes no repo da app
Pipelines de complexo entendimento
Manutenção de codigo dos Pipelines

**Prós Toolchain pronto**
Agilidade na entrega
Menor tempo de desenvolvimento de pipelines
Muitos casos de uso e fluxos já contemplados
Pipelines compliance com a IBM
Facilidade de integração com outros componentes (Sonar)
Dashboard centralizado para controle de qualidade e performance dos times (DevOps Insights)


------
Duvidas???
- Um pipeline de CD para todos os ambientes?
Se for como vamos separar as variaveis de ambiente da aplicação por ambiente?
Para o cluster e o namespace é possivel alterar em tempo de execução.

Como injetar variaveis de ambiente no pipeline?

É tudo orientado ao repo git de inventoty?
Os ambientes são orientados


A variavel cluster-namespace não é orientada a variavel de target-environment.
Criei outro Delivery Pipeline

O processo de aprovação é feito com base nos testes que foram feitos no processo de CI

Workers Tekton, vão ser privados ou publicos?
IBM Managed workers in SAO PAULO


Precisaremos ter uma solução de artifacts (Nexus, Jfrog) ou somente o registry??

**Outras Ferramentas**
Gitlab CI
Argo CD
Helm



https://cloud.ibm.com/docs/devsecops?topic=devsecops-tutorial-cd-devsecops#devsecops-cd-toolchain-explore
https://cloud.ibm.com/docs/devsecops?topic=devsecops-cd-devsecops-apps-byoa
https://cloud.ibm.com/docs/devsecops?topic=devsecops-cd-devsecops-automate-changemgmt
https://cloud.ibm.com/docs/devsecops?topic=devsecops-cd-devsecops-inventory
https://cloud.ibm.com/docs/devsecops?topic=devsecops-cd-devsecops-apps-rollback
https://www.ibm.com/cloud/blog/announcements/find-source-code-vulnerabilities-with-code-risk-analyzer



## Analise ferramentas

### Source Code Management - SCM
**Gitlab CE managed IBM Cloud**
Vantangens:
- Projeto incubado pela CNCF
- Serviço gerenciado pela IBM Cloud
- Open Source
- Não há necessidade de sustentar o serviço


### Continuos Integration - CI
**Tekton Pipelines**
Vantangens:
- Projeto incubado pela CNCF
- Serviço gerenciado pela IBM Cloud
- Integração Nativa com o K8S e Openshift
- Open Source
- Não há necessidade de sustentar o serviço

### Continuos Delivery/Deployment - CD
**ArgoCD**
Vantangens:
- Projeto incubado pela CNCF
- Open Source

### Static Analysis - SAST
**SonarQube**
Vantangens:
- Open Source com versão community
- Lider de mercado em inspeção continua de qualidade de codigo
- Container Image Oficial
- Exemplos de configuração e execução sob demanda no Toolchain DevOpsSecOps (IBM Cloud)
- Não há necessidade de sustentar o serviço

### Dinamic Analysis - DAST**
**OWASP ZAP**
https://owasp.org/www-community/Vulnerability_Scanning_Tools

Vantangens:
- Projeto criado pela propria OWASP
- Container Image Oficial
- Open Source Free
- Exemplos de configuração e execução sob demanda no Toolchain DevOpsSecOps (IBM Cloud)
- Não há necessidade de sustentar o serviço