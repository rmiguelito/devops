TDC Observabilidade e DevOps


——
Intro speakers
Ola, boa noite, muito obrigado pelo convite, prazer estar aqui com vocês.

Introduce yourselves (pitch de apresentação)
Claro, vamos lá!
Eu sou Rodrigo Miguel, tenho 17 anos de experiência na area, na maioria deles atuando no segmento financeiro e no governo.
Meu background e baseado em Linux, Network e Application Servers. E de uns 8 anos para cá, eu comecei a me especializar em DevOps, Observabilidade, Cloud e Automação. Eu consegui enxergar que esses temas resolviam muitos problemas que eu tinha no meu dia-a-dia nos projetos.
Daí eu me especializei nesses temas, hoje sou Especialista DevOps no Bradesco, atuo como Tech Lead nas frentes de DevOps e Engenharia de Plataforma em uma squad do Banco que é responsável por definir os padrões de implementação no ecossistema de CI/CD.
Com relação aos hobbies, curto jogar jogar video game, jogo tênis de mesa. Acho que é isso.

Split Fiction: é um jogo coop de ação onde as duas personagens estão presas em seus próprios mundos de ficção que elas escreveram, eles precisam trabalhar juntos para escapar.


Introduzir o que é DevOps

Quando a gente fala em DevOps, estamos falando de uma cultura que aproxima desenvolvimento e operações. Em vez de cada time trabalhar isolado, o DevOps traz colaboração, automação e monitoramento contínuo em todo o ciclo de vida da aplicação — desde o momento que o código é escrito até quando ele chegar em produção.
Isso permite entregar software mais rápido, com mais qualidade e com foco na experiência do usuário final.

Mas DevOps não é apenas ter um pipeline de entrega bem definido, que entrega rápido e com qualidade, automatizar o gerenciamento de clusters Kubernetes.
Existe um conceito super importante nessa cultura, que muitas vezes não recebe a devida atenção: que é a Observabilidade.

Não basta só entregar rápido, a gente precisa ter visibilidade do que está acontecendo em tempo real, entender o comportamento da aplicação e o impacto para o negocio.


Explicar o que é Observabilidade 

Diferença em monitoramento e observabilidade
Enquanto o monitoramento tradicional e somente um conjunto de métricas que ajuda a entender a saúde da sua aplicação, mostra se algo está ‘no ar’ ou ‘fora do ar’. A Observabilidade vai além. Ela traz contexto, detalhes e insights sobre aquela anomalia, mostrando por que isso aconteceu e como resolver. Essa é a diferença fundamental: o monitoramento normalmente reativo, a observabilidade tem a natureza proativa, ajudando que os times se antecipem problemas mesmo antes mesmo que o usuário perceba, e também melhorando o tempo de resposta a um incidente.

Explicar os 3 pilares da observabilidade
Explicar a diferença dos 3 pilares (logs, métricas, traces) 


Importância da observabilidade em DevOps:

Tempo de resposta ao um Incidente
MTTD e MTTR - O seu sistema vai cair em algum momento, aceite isso rs, as big techs também sofrem com outages, é uma change que subiu errado, um problema que ninguém sabe de onde surgiu. O mais importante é você conseguir detectar e resolver de forma rápida, esse que é o diferencial.

Confiança do cliente
Se o seu sistema cair e ficar do ar por muito tempo, o seu cliente vai perder a confiança e vai para o concorrente, normalmente o cliente não perde a confiança fácil e rápido, precisam ter varias ocorrências dele tentar fazer alguma operação e não funcionar, então por isso precisamos identificar e resolver de forma rápida os incidente. Isso mantem a confiança do cliente sempre elevada.

Eficiência do time
Quando vc estiver com um incidente o seu time SRE, que está atendendo ao incidente, ele precisa ser assertivo na investigação, e sem observabilidade, e fica sendo como procurar agulha no palheiro, principalmente com as arquiteturas modernas de sistemas distribuídos em microservicos que temos hoje, o processo de troubleshooting fica bem mais complexo.
Temos serviços que rodam com 100, 200 instancias com varias integrações multicloud e com o onpremisses.

Sem observalidade os times tendem as restartar os serviços de backend e frontend de forma na aleatória, na tentativa e erro de restabelecer.
Com uma stack de observabilidade bem definida e configurada, vc precisa verificar somente os 3 pilares que o Fiche comentou, Logs, Metricas e Traces, se possivel em uma ferramenta apenas rs. E com essa visão vc vai conseguir avaliar a causa raiz de fato do problema, e atacar especificamente o serviço que esta degradado.Com isso a gente a eficiência do time, e consequentemente identifica e resolve o incidente mais rápido.

Abordar SLOs, SLIs e KPIs:
Importância das métricas: Entender as suas métricas de negocio e super importante, pois são nelas que vc precisa focar a sua observabilidade, como por exemplo: quantidade transações efetuadas por minuto, taxa de conversão, quantidade de usuários logados, enfim. 
A observabilidade ela precisa ser capaz de identificar desvios nessas métricas, e correlacionar com métricas de sistemas, como por exemplo spike de CPU, enfileiramento em um message bus, exausted de memória em algum servidor ou POD. Essa correlação entre as duas métricas te ajuda a identificar causa raiz de forma mais rápida.
A partir de uma métricas de negocio, correlacionada com uma métrica técnica a gente consegue identifica a causa raiz de um problema.
 

Ferramentas
Falar um pouco das ferramentas mais comuns do mercado.


Melhores praticas para os times

Tenha os logs centralizado -> apenas uma fonte da verdade

Evite dashboards com informações desnecessárias
Evite alertas desnecessárias, para evitar a fadiga de alertas (existe ate um tempo em ingles chamado: alert fatigue), que é justamente isso, aquele alerta aparece toda e ninguém se importa, já e comum. Dai quando acontece um problema real ninguém consegue separar o que falso positivo do problema real.
Configure alerta para somente o que é for critico e que alguém precisa tomar alguma ação.

E um ponto bem importante para evoluir a cultura de Observabilidade na organização, e a gente evitar a caça as bruxas durante um incidente, a gente nao pode ficar culpados, precisamos focar na investigação e resolução e no postmortem, avaliar onde erramos e como evoluir para aquele problema nao ocorrer novamente.
A cultura de Observabilidade, tem que ser um aprendizado constante.


Observabilidade nao é uma ferramenta, é um mindset!
Ter o pensamento e encorajar os times a criarem os produtos já pensando em Observabilidade, com logs bem definidos, métricas e traces.
Nao implementar esses features depois de ter um problema. Entao se a sua companhia tem esse mindset no momento da criação de um produto, vai facilitar muito a observabilidade e manter esse serviço funcionando de forma estável para os clientes.



Deploy progressivo baseado em métricas com Argo Rollouts

Analysis & Progressive Delivery
Background Analysis¶
testing in production - https://www.youtube.com/watch?v=sFzKrGSaIr8
Canary Deployments using Argo Rollouts. Learn how to control traffic with Istio and automate decision-making using Prometheus metrics
Uso de Analysis Templates para validar SLOs (ex: latência, erros, consumo de recursos).
Estamos pilotando no Banco, e uma quebra de paradigma, e um grande desafio principalmente para os times de operação.


Encerramento
Encerrar live.

Mensagem de Divulgação da Live
Acompanhe mais uma edição do TDC Community Talks, com o tema DevOps e Observabilidade. Nesta conversa, especialistas do Bradesco irão compartilhar experiências práticas sobre como integrar cultura DevOps com estratégias de observabilidade para aumentar a confiabilidade, a performance e a segurança em ambientes complexos.

Vamos explorar como times de tecnologia podem antecipar problemas, responder mais rápido a incidentes e impulsionar a inovação contínua, garantindo uma visão clara do que realmente importa para o negócio.
