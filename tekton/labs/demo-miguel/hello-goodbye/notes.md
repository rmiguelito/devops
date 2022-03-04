kubectl apply -f task-hello.yaml
tkn task start hello --dry-run

# use tkn's --dry-run option to save the TaskRun to a file
tkn task start hello --dry-run > taskRun-hello.yaml
# create the TaskRun
kubectl create -f taskRun-hello.yaml
# view logs
tkn taskrun logs --last -f