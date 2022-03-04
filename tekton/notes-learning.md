## Tekton Notes
[]: # Language: markdown
[]: # Path: devops/tekton/notes-learning.md

### Resources
1. Task
Defines a series of steps which launch specific build or delivery tools that ingest specific inputs and produce specific outputs.
2. TaskRun
Instantiates a Task for execution with specific inputs, outputs, and execution parameters. Can be invoked on its own or as part of a Pipeline.
3. Pipeline
Defines a series of Tasks that accomplish a specific build or delivery goal. Can be triggered by an event or invoked from a PipelineRun.
4. PipelineRun
Instantiates a Pipeline for execution with specific inputs, outputs, and execution parameters.
5. Pipelines Resources (Deprecated):
They are inputs of a pipeline.
Is a datasource that provides a list of resources that can be used in a pipeline.
Git
Volume
6. Run (Alpha)
Instantiates a Custom Task for execution when specific inputs.


**Steps:** a execução das ações em si
**Tasks:** um monte de steps que executam varias steps (rodam no mesmo node)
**Pipelines:** é uma colletion de tasks que podem ser executadas em paralelas ou sequencialmente, não podemos garantir que todas as tasks sejam executadas no mesmo node.
**PipelineRun:** São instancias que voce pode executar Pipelines, com especificos inputs, outputs e parametros.
**TaskRun:** São instancias que voce pode executar Tasks, com especificos inputs, outputs e parametros.
**Tekton Catalogo:** é uma coleção de resources que podem ser usadas em pipelines.
O pipeline só faz sentido quando você tem muitas tasks, como como no ambiente de PRD.
Para testes a ambientes somente de build o taskrun é suficiente.

São os runs que executam os pipelines e as tasks, sem eles não é possivel executar.
No taskrun e no pipelinerun pode ser passar todas as informações de runtime, assim podemos ter Tasks e Pipelines genericos.

Pipelines que não contem, ordem de execução, por padrão são executadas sequencialmente.
Use e abuse do RunAfter

Building blocks
Building blocks
Building blocks

### Cons
1. It's not easy
For the proposal be a building block for teams that want to create pipeline as a service, Tekton is kind of complex to understand and manage.
2. Events are under-developed
Tekton hasn't been designed to be used with events, so it's not easy to integrate with other systems, like github, gitlab, etc.
3. Web UI could be better
Tekton has a web UI, but it's not very intuitive, and don't have a CICD flow user friendly.
Don't have a interdependency between tasks, so it's not easy to understand what's going on.

### Pros
1. Documentation is great
Tekton has a great documentation, has a lot of examples, and is easy to understand.
Tekton catalog is amazin, has a lot of resources.
2. A lot of resuable tasks
In Tekton catalog you can find a lot of reusable tasks, like build, deploy, test, etc.
3. Buildind Blocks
Is very helpful for teams that want to create pipeline as a service.
Teams members can create their own tasks, and use them in pipelines.


Steps -> Tasks -> Pipelines -> PipelineRuns
           -> TaskRuns

### Input and Output Resources
A compilation task, for example, may have a git repository as **input** and a container image as **output**

### Best Practices
- Use retries and retry-count (context) to avoid infinite loops.
- Use timeouts pipelines, tasks and finally.
- Use When
- Use Workspaces
To save secrets, artifacts, and other resources, use the `workspace` resource.
- Use variable substitution
- Use results
A Pipeline can pass the Result of a Task into the Parameters or when expressions of another.
A Pipeline can itself emit Results and include data from the Results of its Tasks
- Passing one Task’s Results into the Parameters or when expressions of another
- Use finally
To run tasks in parallel, after all tasks have completed, run a final tasks.
- Executtion Status
```yaml
finally:
  - name: finaltask
    params:
      - name: task1Status
        value: "$(tasks.task1.status)"
    taskSpec:
      params:
        - name: task1Status
      steps:
        - image: ubuntu
          name: print-task-status
          script: |
            if [ $(params.task1Status) == "Failed" ]
            then
              echo "Task1 has failed, continue processing the failure"
            fi
```
**Note:** A PipelineRun automatically creates corresponding TaskRuns for every Task in your Pipeline.
Consider use LimitRange in your pipelines
And explore Input/Output and Params


- Workspaces
Workspaces can be Configmaps, Secrets, and PersistentVolumeClaims(created or VolumeClaimTemplate) or simply an emptydir that is discarded when the TaskRun completes.
1. Workspaces can serve the following purposes:
Storage of inputs and/or outputs
Sharing data among Tasks
A mount point for credentials held in Secrets
A mount point for configurations held in ConfigMaps
A mount point for common tools shared by an organization
A cache of build artifacts that speed up jobs

**mountPath - A path to a location on disk where the workspace will be available to Steps. If a mountPath is not provided the workspace will be placed by default at /workspace/<name> where <name> is the workspace’s unique name.**

- Use Workspace variables in Tasks

**The subPath specified in a Pipeline will be appended to any subPath specified as part of the PipelineRun workspace declaration. So a PipelineRun declaring a Workspace with subPath of /foo for a Pipeline who binds it to a Task with subPath of /bar will end up mounting the Volume’s /foo/bar directory.**

**Workspaces**
On **Task and Pipelines** you can declare a Workspace, and inform a path that will be mounted to the Task’s container.
On **PipelineRuns and TaskRuns** you can declare a Workspace, which is a volume that will be mounted to the TaskRun’s container, could be a ConfigMap, Secret, PersistentVolumeClaim or emptyDir.


###  Triggers and EventListeners
1. EventListeners

The params of TriggerBinding are passed to the triggertemplate.
Tekton can use a TriggerBinding to access data in the headers and body of an HTTP JSON payload.
 $(body.head_commit.id)
 "https://github.com/$(body.repository.full_name)"

The TriggerBinding capture the data from the EventListener (request http) and pass it to the TriggerTemplate.

Interceptor runs before the triggerbinding
Tekton Triggers ships with the following Interceptors to help you get started: - Webhook Interceptors - GitHub Interceptors - GitLab Interceptors - Bitbucket Interceptors - CEL Interceptors


EventListeners -> Triggers -> TriggerBindings -> TriggersTemplates -> PipelineRuns
                    -> Interceptors

**EventListeners**: Fica escutando os eventos que ocorrem no github, gitlab, bitbucket.
Nele podemos colocar os **interceptors** que queremos filtrar para ativar trigger, como eventos de push, merge ou até mesmo commit. E também podemos fazer filtros para somente ativar a trigger somente com eventos na branch main.
```yaml
filter: "body.ref == 'refs/heads/main'"
```
Os **TriggerBinding** e **TriggerTemplate** também são referenciados no **EventListener**.

O **TriggerBinding** captura o dado do **EventListener** e passa para o **TriggerTemplate** através do **params**.

O **TriggerTemplate** é o que vai ser executado quando o **TriggerBinding** for ativado, e o **TriggerTemplate** chama/cria o **PipelineRun**
That's all folks!
