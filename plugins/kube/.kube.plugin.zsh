# fork from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/kubectl/kubectl.plugin.zsh
if type kubectl >/dev/null; then

    alias k="kubectl "

    # apply a YML file
    alias kaf="kubectl apply -f "

    # drop into an interactive terminal on a container
    alias keit="kubectl exec -it "

    # contexts
    alias kcg="kubectl config get-contexts "
    alias kcu="kubectl config use-context "
    alias kcs="kubectl config set-context "
    alias kcc="kubectl config current-context "
    # alias kcd="kubectl config delete-context "

    # namespace
    if ! typeset -f kcns > /dev/null; then
        function kcns() {
            case $1 in
                (*) kubectl config set-context --current --namespace=$1 ;;
            esac
        }
    fi

    # pod
    alias kgp="kubectl get pods "                    # List all pods in ps output format.
    alias kgpw="kubectl get pods --watch "
    alias kgpwide="kubectl get pods -o wide "        # List all pods in ps output format with more information (such as node name).
    alias kgpl="kubectl get pods -l "                # get pod by label
    function kgpa() { kubectl get pods -l app=$1 }   # get pod by label "app=myapp"
    alias kep="kubectl edit pods "
    alias kdp="kubectl describe pods "
    alias kdelp="kubectl delete pods "

    # logs
    alias kl="kubectl logs "
    alias kl1h="kubectl logs --since 1h "
    alias kl1m="kubectl logs --since 1m "
    alias kl1s="kubectl logs --since 1s "
    alias klf="kubectl logs -f "
    alias klf1h="kubectl logs --since 1h -f "
    alias klf1m="kubectl logs --since 1m -f "
    alias klf1s="kubectl logs --since 1s -f "
    function kla() { kubectl logs -f -l app=$1 }

    # svc
    alias kgs="kubectl get svc "
    alias kgsw="kgs --watch "
    alias kgswide="kgs -o wide "
    alias kes="kubectl edit svc "
    alias kds="kubectl describe svc "
    alias kdels="kubectl delete svc "

    # port forwarding
    alias kpf="kubectl port-forward "

    # namespae
    alias kgns="kubectl get namespaces "
    alias kens="kubectl edit namespace "
    alias kdns="kubectl describe namespace "
    alias kdelns="kubectl delete namespace "

    # cronjob
    alias kgcj="kubectl get cronjob "
    alias kecj="kubectl edit cronjob "
    alias kdcj="kubectl describe cronjob "
    alias kdelcj="kubectl delete cronjob "

    # job
    alias kgj="kubectl get job "
    alias kej="kubectl edit job "
    alias kdj="kubectl describe job "
    alias kdelj="kubectl delete job "

    # secret
    alias kgsec="kubectl get secret "
    alias kdsec="kubectl describe secret "
    alias kdelsec="kubectl delete secret "

    # deployment
    alias kgd="kubectl get deployment "
    alias kgdw="kgd --watch "
    alias kgdwide="kgd -o wide "
    alias ked="kubectl edit deployment "
    alias kdd="kubectl describe deployment "
    alias kdeld="kubectl delete deployment "
    alias ksd="kubectl scale deployment "
    # kres(){
    #     kubectl set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
    # }

    # # ingress
    # alias kgi="kubectl get ingress "
    # alias kei="kubectl edit ingress "
    # alias kdi="kubectl describe ingress "
    # alias kdeli="kubectl delete ingress "

    # configmap
    alias kgcm="kubectl get configmaps "
    alias kecm="kubectl edit configmap "
    alias kdcm="kubectl describe configmap "
    alias kdelcm="kubectl delete configmap "

    # # rollout
    # alias kgrs="kubectl get rs "
    # alias krsd="kubectl rollout status deployment "
    # alias krh="kubectl rollout history "
    # alias kru="kubectl rollout undo "

    # # statefulset management.
    # alias kgss="kubectl get statefulset "
    # alias kgssw="kgss --watch "
    # alias kgsswide="kgss -o wide "
    # alias kess="kubectl edit statefulset "
    # alias kdss="kubectl describe statefulset "
    # alias kdelss="kubectl delete statefulset "
    # alias ksss="kubectl scale statefulset "
    # alias krsss="kubectl rollout status statefulset "

    # # tools for accessing all information
    # alias kga="kubectl get all "

    # # file copy
    # alias kcp="kubectl cp "

    # # node
    # alias kgno="kubectl get nodes "
    # alias keno="kubectl edit node "
    # alias kdno="kubectl describe node "
    # alias kdelno="kubectl delete node "

    # # pvc
    # alias kgpvc="kubectl get pvc "
    # alias kgpvcw="kgpvc --watch "
    # alias kepvc="kubectl edit pvc "
    # alias kdpvc="kubectl describe pvc "
    # alias kdelpvc="kubectl delete pvc "

    # # service account
    # alias kdsa="kubectl describe sa "
    # alias kdelsa="kubectl delete sa "

    # # daemonset
    # alias kgds="kubectl get daemonset "
    # alias kgdsw="kgds --watch "
    # alias keds="kubectl edit daemonset "
    # alias kdds="kubectl describe daemonset "
    # alias kdelds="kubectl delete daemonset "

fi
