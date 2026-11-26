# Kubernetes - CKA Command Cheat Sheet

## Table of Contents

1. Core Kubernetes Resources
2. Common Flags and Arguments
3. Resource Creation and Management
4. Imperative Commands and YAML Generation
5. Deployments, Scaling and Rollbacks
6. Labels and Selectors
7. Services and Networking
8. DNS and Network Troubleshooting
9. Scheduling and Node Management
10. ConfigMaps and Secrets
11. Storage
12. RBAC and Security
13. Contexts and Kubeconfig
14. Troubleshooting and Debugging
15. Jobs, CronJobs and Autoscaling
16. Cluster Administration - kubeadm
17. etcd Backup and Restore
18. Linux and Container Runtime
19. Helm, Kustomize and CRDs
20. JSONPath and Documentation
21. Terminal Productivity
22. Troubleshooting Reference

---

## 1. Core Kubernetes Resources

```bash
# Pods
$ kubectl get pods
$ kubectl get po

# Deployments
$ kubectl get deployments
$ kubectl get deploy

# ReplicaSets
$ kubectl get replicasets
$ kubectl get rs

# ReplicationControllers
$ kubectl get replicationcontrollers
$ kubectl get rc

# Services
$ kubectl get services
$ kubectl get svc

# Nodes
$ kubectl get nodes
$ kubectl get no

# Namespaces
$ kubectl get namespaces
$ kubectl get ns

# DaemonSets
$ kubectl get daemonsets
$ kubectl get ds

# StatefulSets
$ kubectl get statefulsets
$ kubectl get sts

# ConfigMaps
$ kubectl get configmaps
$ kubectl get cm

# ServiceAccounts
$ kubectl get serviceaccounts
$ kubectl get sa

# Secrets
$ kubectl get secrets

# Events
$ kubectl get events
$ kubectl get ev

# Common workload and service resources
$ kubectl get all

# Multiple resource types
$ kubectl get pods,services,deployments
$ kubectl get po,svc,deploy
```

Note: Singular, plural and supported shortnames are interchangeable.

---

## 2. Common Flags and Arguments

```bash
# All namespaces
$ kubectl get pods --all-namespaces
$ kubectl get po -A

# Specific namespace
$ kubectl get pods --namespace=dev
$ kubectl get po -n dev

# Additional details
$ kubectl get pods --output=wide
$ kubectl get po -o wide

# YAML output
$ kubectl get pods --output=yaml
$ kubectl get po -o yaml

# JSON output
$ kubectl get pods --output=json
$ kubectl get po -o json

# Watch resources in real time
$ kubectl get pods --watch
$ kubectl get po -w

# Filter resources by label
$ kubectl get pods --selector=app=nginx
$ kubectl get po -l app=nginx

# Display labels
$ kubectl get po --show-labels

# Filter by resource field
$ kubectl get po --field-selector=status.phase=Running

# Sort resources
$ kubectl get po --sort-by=.metadata.creationTimestamp

# Display resource names only
$ kubectl get po -o name

# Remove column headers
$ kubectl get po --no-headers

# Display help
$ kubectl get pods --help
$ kubectl get po -h
```

| Full Flag | Short Flag | Purpose |
|---|---|---|
| --namespace | -n | Specify namespace |
| --all-namespaces | -A | All namespaces |
| --output | -o | Output format |
| --selector | -l | Filter by label |
| --filename | -f | Specify file |
| --watch | -w | Watch changes |
| --help | -h | Display help |
| --container | -c | Specify container |
| --stdin | -i | Standard input |
| --tty | -t | Interactive terminal |

---

## 3. Resource Creation and Management

```bash
# Create Pod
$ kubectl run nginx --image=nginx

# Create Deployment
$ kubectl create deployment nginx --image=nginx
$ kubectl create deploy nginx --image=nginx

# Create Deployment with four replicas
$ kubectl create deploy nginx --image=nginx --replicas=4

# Create Namespace
$ kubectl create namespace dev
$ kubectl create ns dev

# Create resource using YAML
$ kubectl create --filename=pod.yaml
$ kubectl create -f pod.yaml

# Create or update declaratively
$ kubectl apply --filename=pod.yaml
$ kubectl apply -f pod.yaml

# Apply all manifests in a directory
$ kubectl apply -f .

# Describe resource
$ kubectl describe pod nginx
$ kubectl describe po nginx

# Edit resource
$ kubectl edit deployment nginx
$ kubectl edit deploy nginx

# Delete resource
$ kubectl delete pod nginx
$ kubectl delete po nginx

# Delete resources using YAML
$ kubectl delete -f pod.yaml

# Delete all Pods in current namespace
$ kubectl delete po --all

# Delete resources using labels
$ kubectl delete po -l app=nginx

# Compare desired and existing configuration
$ kubectl diff -f deployment.yaml

# Patch existing resource
$ kubectl patch deploy nginx -p '{"spec":{"replicas":4}}'
```

| Command | Purpose |
|---|---|
| create | Create a new resource |
| apply | Create or update declaratively |
| get | Retrieve resource information |
| describe | Detailed information and events |
| edit | Modify live configuration |
| patch | Modify specific configuration fields |
| delete | Remove a resource |
| diff | Compare configuration changes |

---

## 4. Imperative Commands and YAML Generation

```bash
# Generate Pod YAML
$ kubectl run nginx --image=nginx --dry-run=client -o yaml

# Generate and save Pod YAML
$ kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml

# Generate Deployment YAML
$ kubectl create deploy nginx --image=nginx --replicas=4 --dry-run=client -o yaml > deployment.yaml

# Generate Service YAML
$ kubectl expose deploy nginx --port=80 --type=NodePort --dry-run=client -o yaml > service.yaml

# Generate Namespace YAML
$ kubectl create ns dev --dry-run=client -o yaml > namespace.yaml

# Generate ConfigMap YAML
$ kubectl create cm app-config --from-literal=ENV=prod --dry-run=client -o yaml > configmap.yaml

# Validate YAML against API server without persisting
$ kubectl apply -f pod.yaml --dry-run=server
```

- `--dry-run=client`: Generate configuration locally without creating the resource.
- `--dry-run=server`: Validate against the API server without persisting the resource.
- `-o yaml`: Display generated YAML.
- `>`: Redirect output into a file.

---

## 5. Deployments, Scaling and Rollbacks

```bash
# Scale Deployment
$ kubectl scale deployment nginx --replicas=5
$ kubectl scale deploy nginx --replicas=5

# Scale ReplicaSet
$ kubectl scale replicaset nginx-rs --replicas=3
$ kubectl scale rs nginx-rs --replicas=3

# Update container image
$ kubectl set image deployment/nginx nginx=nginx:1.28
$ kubectl set image deploy/nginx nginx=nginx:1.28

# Check rollout status
$ kubectl rollout status deployment/nginx
$ kubectl rollout status deploy/nginx

# Check rollout history
$ kubectl rollout history deployment/nginx
$ kubectl rollout history deploy/nginx

# Rollback Deployment
$ kubectl rollout undo deployment/nginx
$ kubectl rollout undo deploy/nginx

# Rollback to specific revision
$ kubectl rollout undo deploy/nginx --to-revision=2

# Restart Deployment
$ kubectl rollout restart deployment/nginx
$ kubectl rollout restart deploy/nginx

# Pause rollout
$ kubectl rollout pause deploy/nginx

# Resume rollout
$ kubectl rollout resume deploy/nginx

# Configure CPU and memory requests and limits
$ kubectl set resources deploy/nginx --requests=cpu=100m,memory=128Mi --limits=cpu=500m,memory=256Mi
```

### Deployment Strategies

| Strategy | Description |
|---|---|
| RollingUpdate | Gradually replaces existing Pods |
| Recreate | Terminates existing Pods before creating replacements |
| maxSurge | Maximum additional Pods during update |
| maxUnavailable | Maximum unavailable Pods during update |
| minReadySeconds | Minimum ready duration before a Pod is considered available |

---

## 6. Labels, Selectors and Annotations

```bash
# Add label
$ kubectl label pod nginx app=frontend
$ kubectl label po nginx app=frontend

# Update existing label
$ kubectl label po nginx app=backend --overwrite

# Remove label
$ kubectl label po nginx app-

# Display labels
$ kubectl get po --show-labels

# Filter using label
$ kubectl get po -l app=nginx

# Filter using multiple labels
$ kubectl get po -l app=nginx,env=prod

# Display labels as columns
$ kubectl get po -L app,env

# Add annotation
$ kubectl annotate po nginx owner=devops

# Remove annotation
$ kubectl annotate po nginx owner-
```

---

## 7. Services and Networking

```bash
# Services
$ kubectl get services
$ kubectl get svc

# Endpoints
$ kubectl get endpoints
$ kubectl get ep

# EndpointSlices
$ kubectl get endpointslices

# Ingress
$ kubectl get ingresses
$ kubectl get ing

# NetworkPolicies
$ kubectl get networkpolicies
$ kubectl get netpol

# Expose Deployment using ClusterIP
$ kubectl expose deploy nginx --port=80 --target-port=80 --type=ClusterIP

# Expose Deployment using NodePort
$ kubectl expose deploy nginx --port=80 --target-port=80 --type=NodePort

# Expose Deployment using LoadBalancer
$ kubectl expose deploy nginx --port=80 --target-port=80 --type=LoadBalancer

# Create NodePort Service with specific port
$ kubectl create service nodeport nginx --tcp=80:80 --node-port=30080

# Describe Service
$ kubectl describe service nginx
$ kubectl describe svc nginx

# Check Service endpoints
$ kubectl get ep nginx

# Check EndpointSlices associated with Service
$ kubectl get endpointslices -l kubernetes.io/service-name=nginx

# Forward local port to Service
$ kubectl port-forward service/nginx 8080:80
$ kubectl port-forward svc/nginx 8080:80

# Forward local port to Pod
$ kubectl port-forward po/nginx 8080:80

# Create Ingress
$ kubectl create ingress nginx --rule="example.com/*=nginx:80"

# Gateway API resources (if installed)
$ kubectl get gatewayclasses
$ kubectl get gateways
$ kubectl get httproutes
```

### Service Types

| Service | Purpose |
|---|---|
| ClusterIP | Internal cluster access |
| NodePort | External access through Node IP and port |
| LoadBalancer | Access through external load balancer integration |
| ExternalName | DNS alias for an external service |

### Service Ports

| Field | Purpose |
|---|---|
| port | Service listening port |
| targetPort | Destination port on Pod |
| nodePort | Port exposed on Node |

### NodePort Traffic Flow

```text
External Client
      |
      v
Node IP : 30080
      |
      v
Service routing rules
      |
      v
Pod IP : 80
      |
      v
Application
```

The Service ClusterIP is a virtual IP. Traffic does not need to physically pass through a separate Service process.

---

## 8. DNS and Network Troubleshooting

```bash
# Create temporary troubleshooting Pod
$ kubectl run debug --image=busybox:1.36 --restart=Never -- sleep 3600

# DNS lookup
$ kubectl exec debug -- nslookup nginx

# DNS lookup across namespaces
$ kubectl exec debug -- nslookup nginx.dev.svc.cluster.local

# Check Pod IP addresses
$ kubectl get pods --output=wide
$ kubectl get po -o wide

# Check Node IP addresses
$ kubectl get nodes --output=wide
$ kubectl get no -o wide

# Check CoreDNS Pods
$ kubectl get po -n kube-system -l k8s-app=kube-dns

# Check CoreDNS logs
$ kubectl logs -n kube-system -l k8s-app=kube-dns

# Check CoreDNS configuration
$ kubectl get cm coredns -n kube-system -o yaml

# Check DNS configuration inside Pod
$ kubectl exec debug -- cat /etc/resolv.conf

# Remove troubleshooting Pod
$ kubectl delete po debug
```

### Linux Networking Commands

```bash
# Display IP addresses
$ ip addr
$ ip a

# Display routing table
$ ip route
$ ip r

# Display listening ports
$ ss -tulnp

# Test connectivity
$ ping 10.0.0.10

# Test HTTP connectivity
$ curl http://10.0.0.10:80

# DNS resolution
$ nslookup example.com
$ dig example.com

# Trace network route
$ traceroute 10.0.0.10
```

---

## 9. Scheduling and Node Management

```bash
# Display nodes
$ kubectl get nodes
$ kubectl get no

# Describe node
$ kubectl describe node worker01
$ kubectl describe no worker01

# Add node label
$ kubectl label node worker01 disk=ssd
$ kubectl label no worker01 disk=ssd

# Remove node label
$ kubectl label no worker01 disk-

# Add taint
$ kubectl taint nodes worker01 dedicated=app:NoSchedule
$ kubectl taint no worker01 dedicated=app:NoSchedule

# Remove taint
$ kubectl taint no worker01 dedicated:NoSchedule-

# Prevent new Pods from being scheduled
$ kubectl cordon worker01

# Evict eligible workloads for maintenance
$ kubectl drain worker01 --ignore-daemonsets

# Allow scheduling again
$ kubectl uncordon worker01

# Delete Node object
$ kubectl delete node worker01
$ kubectl delete no worker01

# Display Pods running on specific Node
$ kubectl get po -A --field-selector=spec.nodeName=worker01
```

### Scheduling Concepts

| Concept | Purpose |
|---|---|
| nodeSelector | Schedule Pod on matching Node labels |
| nodeAffinity | Advanced Node selection |
| podAffinity | Schedule Pods near other Pods |
| podAntiAffinity | Distribute Pods away from other Pods |
| Taints | Repel Pods without matching tolerations |
| Tolerations | Permit Pods to tolerate matching taints |
| Cordon | Prevent normal new scheduling |
| Drain | Cordon and evict eligible workloads |
| Uncordon | Enable scheduling |

---

## 10. ConfigMaps and Secrets

```bash
# ConfigMaps
$ kubectl get configmaps
$ kubectl get cm

# Create ConfigMap from literal
$ kubectl create configmap app-config --from-literal=ENV=prod
$ kubectl create cm app-config --from-literal=ENV=prod

# Create ConfigMap from file
$ kubectl create cm app-config --from-file=config.txt

# Inspect ConfigMap
$ kubectl get cm app-config -o yaml

# Secrets
$ kubectl get secrets

# Create Secret
$ kubectl create secret generic app-secret --from-literal=password=example

# Create Secret from file
$ kubectl create secret generic app-secret --from-file=password.txt

# Create TLS Secret
$ kubectl create secret tls app-tls --cert=tls.crt --key=tls.key

# Inspect Secret
$ kubectl get secret app-secret -o yaml

# Decode Secret
$ kubectl get secret app-secret -o jsonpath='{.data.password}' | base64 -d

# Set environment variable
$ kubectl set env deploy/nginx ENV=production

# Import variables from ConfigMap
$ kubectl set env deploy/nginx --from=configmap/app-config

# Import variables from Secret
$ kubectl set env deploy/nginx --from=secret/app-secret
```

Security: Base64 encoding is not encryption. Avoid exposing production credentials in terminal history, logs or Git repositories.

---

## 11. Storage

```bash
# PersistentVolumes
$ kubectl get persistentvolumes
$ kubectl get pv

# PersistentVolumeClaims
$ kubectl get persistentvolumeclaims
$ kubectl get pvc

# StorageClasses
$ kubectl get storageclasses
$ kubectl get sc

# Describe PersistentVolume
$ kubectl describe persistentvolume my-pv
$ kubectl describe pv my-pv

# Describe PersistentVolumeClaim
$ kubectl describe persistentvolumeclaim my-pvc
$ kubectl describe pvc my-pvc

# Create PersistentVolume
$ kubectl apply -f pv.yaml

# Create PersistentVolumeClaim
$ kubectl apply -f pvc.yaml

# Create StorageClass
$ kubectl apply -f storageclass.yaml

# Inspect PVC configuration
$ kubectl get pvc my-pvc -o yaml

# Expand PVC (if supported)
$ kubectl patch pvc my-pvc -p '{"spec":{"resources":{"requests":{"storage":"10Gi"}}}}'
```

### Storage Architecture

```text
Pod
 |
 v
PersistentVolumeClaim (PVC)
 |
 v
PersistentVolume (PV)
 |
 v
Physical / Cloud Storage
```

### Storage Concepts

| Concept | Purpose |
|---|---|
| PV | Storage resource |
| PVC | Request for storage |
| StorageClass | Defines storage provisioning |
| emptyDir | Temporary Pod-scoped storage |
| hostPath | Mount Node filesystem |
| ReadWriteOnce | Read/write access from one Node |
| ReadWriteMany | Read/write access from multiple Nodes |
| ReadOnlyMany | Read-only access from multiple Nodes |
| ReadWriteOncePod | Read/write access from one Pod |
| Retain | Retain underlying storage after claim release |
| Delete | Delete underlying storage when supported |

---

## 12. RBAC and Security

```bash
# ServiceAccounts
$ kubectl get serviceaccounts
$ kubectl get sa

# Create ServiceAccount
$ kubectl create serviceaccount developer
$ kubectl create sa developer

# Create ServiceAccount token
$ kubectl create token developer

# Display Roles
$ kubectl get roles

# Display RoleBindings
$ kubectl get rolebindings

# Display ClusterRoles
$ kubectl get clusterroles

# Display ClusterRoleBindings
$ kubectl get clusterrolebindings

# Create Role
$ kubectl create role pod-reader --verb=get,list,watch --resource=pods -n dev

# Create RoleBinding
$ kubectl create rolebinding read-pods --role=pod-reader --user=developer -n dev

# Create ClusterRole
$ kubectl create clusterrole node-reader --verb=get,list --resource=nodes

# Create ClusterRoleBinding
$ kubectl create clusterrolebinding read-nodes --clusterrole=node-reader --user=developer

# Check permissions
$ kubectl auth can-i get pods

# Check another user's permissions
$ kubectl auth can-i delete pods --as=developer -n dev

# Check ServiceAccount permissions
$ kubectl auth can-i list pods --as=system:serviceaccount:dev:developer -n dev

# Display available permissions
$ kubectl auth can-i --list

# Certificate Signing Requests
$ kubectl get certificatesigningrequests
$ kubectl get csr

# Approve CSR
$ kubectl certificate approve developer-csr

# Deny CSR
$ kubectl certificate deny developer-csr
```

### RBAC Architecture

```text
User / ServiceAccount
         |
         v
RoleBinding / ClusterRoleBinding
         |
         v
Role / ClusterRole
         |
         v
Resources + Allowed Verbs
```

---

## 13. Contexts and Kubeconfig

```bash
# Display current context
$ kubectl config current-context

# Display available contexts
$ kubectl config get-contexts

# Switch context
$ kubectl config use-context cluster1

# Display kubeconfig
$ kubectl config view

# Display current context configuration
$ kubectl config view --minify

# Change default namespace
$ kubectl config set-context --current --namespace=dev

# Execute command against specific context
$ kubectl get po --context=cluster1

# Specify kubeconfig file
$ kubectl --kubeconfig=config.yaml get nodes

# Display cluster information
$ kubectl cluster-info

# Display Kubernetes version
$ kubectl version
```

CKA: Always verify the required cluster context and namespace before modifying resources.

---

## 14. Troubleshooting and Debugging

```bash
# Display Pods
$ kubectl get pods
$ kubectl get po

# Describe Pod
$ kubectl describe pod nginx
$ kubectl describe po nginx

# Display container logs
$ kubectl logs nginx

# Follow logs
$ kubectl logs nginx --follow
$ kubectl logs nginx -f

# Previous container logs
$ kubectl logs nginx --previous
$ kubectl logs nginx -p

# Logs from specific container
$ kubectl logs nginx --container=web
$ kubectl logs nginx -c web

# Logs from all containers
$ kubectl logs nginx --all-containers=true

# Last 100 lines
$ kubectl logs nginx --tail=100

# Logs from last hour
$ kubectl logs nginx --since=1h

# Execute command inside Pod
$ kubectl exec nginx -- ls

# Open interactive shell
$ kubectl exec nginx --stdin --tty -- sh
$ kubectl exec nginx -it -- sh

# Open shell in specific container
$ kubectl exec nginx -it -c web -- sh

# Display events
$ kubectl get events
$ kubectl get ev

# Sort events chronologically
$ kubectl get ev --sort-by=.metadata.creationTimestamp

# Display Node resource utilization
$ kubectl top nodes
$ kubectl top no

# Display Pod resource utilization
$ kubectl top pods
$ kubectl top po

# Debug using ephemeral container
$ kubectl debug -it nginx --image=busybox:1.36

# Debug Node
$ kubectl debug node/worker01 -it --image=ubuntu

# Copy file from Pod
$ kubectl cp nginx:/tmp/log.txt ./log.txt

# Copy file into Pod
$ kubectl cp ./config.txt nginx:/tmp/config.txt

# Wait until Pod is ready
$ kubectl wait --for=condition=Ready pod/nginx --timeout=60s
```

Note: `kubectl top` requires Metrics Server.

### Troubleshooting Flow

```text
kubectl get
     |
     v
kubectl describe
     |
     v
kubectl logs
     |
     v
kubectl get events
     |
     v
kubectl exec / debug
     |
     v
Identify Root Cause
     |
     v
Fix and Verify
```

---

## 15. Jobs, CronJobs and Autoscaling

```bash
# Display Jobs
$ kubectl get jobs

# Create Job
$ kubectl create job test-job --image=busybox -- echo hello

# Display CronJobs
$ kubectl get cronjobs
$ kubectl get cj

# Create CronJob
$ kubectl create cronjob test-cron --image=busybox --schedule="*/5 * * * *" -- echo hello

# Manually trigger CronJob
$ kubectl create job manual-job --from=cronjob/test-cron

# HorizontalPodAutoscaler
$ kubectl get horizontalpodautoscalers
$ kubectl get hpa

# Configure autoscaling
$ kubectl autoscale deployment nginx --min=2 --max=5 --cpu=80%
$ kubectl autoscale deploy nginx --min=2 --max=5 --cpu=80%

# PodDisruptionBudgets
$ kubectl get poddisruptionbudgets
$ kubectl get pdb

# ResourceQuotas
$ kubectl get resourcequotas
$ kubectl get quota

# LimitRanges
$ kubectl get limitranges
$ kubectl get limits
```

Note: Autoscaling flags vary by Kubernetes version. Older versions use `--cpu-percent=80`. Verify using `kubectl autoscale --help`.

---

## 16. Cluster Administration - kubeadm

```bash
# Initialize Control Plane
$ sudo kubeadm init

# Initialize with Pod network CIDR
$ sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Configure kubectl access
$ mkdir -p $HOME/.kube
$ sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Generate Worker Node join command
$ sudo kubeadm token create --print-join-command

# Display available tokens
$ sudo kubeadm token list

# Check certificate expiration
$ sudo kubeadm certs check-expiration

# Renew certificates
$ sudo kubeadm certs renew all

# Check upgrade plan
$ sudo kubeadm upgrade plan

# Upgrade first Control Plane
$ sudo kubeadm upgrade apply VERSION

# Upgrade additional Node configuration
$ sudo kubeadm upgrade node

# Display kubeadm version
$ kubeadm version

# Reset Node
$ sudo kubeadm reset
```

### Cluster Upgrade Overview

```text
Check Current Version
        |
        v
Check Upgrade Plan
        |
        v
Upgrade kubeadm
        |
        v
Upgrade Control Plane
        |
        v
Drain Node
        |
        v
Upgrade kubelet / kubectl
        |
        v
Restart kubelet
        |
        v
Uncordon Node
        |
        v
Verify Cluster
```

Warning: Follow version-specific upgrade documentation. Never reset a functioning production Node without understanding the consequences.

---

## 17. etcd Backup and Restore

```bash
# Check etcd health
$ etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  endpoint health

# Backup etcd
$ etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /tmp/backup.db

# Verify snapshot
$ etcdutl snapshot status /tmp/backup.db -w table

# Restore snapshot into new directory
$ etcdutl snapshot restore /tmp/backup.db \
  --data-dir=/var/lib/etcd-restore
```

These are example commands for a kubeadm cluster. Verify certificate paths, endpoints and etcd version.

A complete restore requires coordinating etcd shutdown, data directory configuration and restart. Kubernetes recovery may also require revision bump and compaction options.

---

## 18. Linux and Container Runtime

### System Services

```bash
# Check kubelet
$ systemctl status kubelet

# Restart kubelet
$ sudo systemctl restart kubelet

# Check containerd
$ systemctl status containerd

# Restart containerd
$ sudo systemctl restart containerd

# Reload systemd configuration
$ sudo systemctl daemon-reload

# Display kubelet logs
$ journalctl --unit=kubelet
$ journalctl -u kubelet

# Follow kubelet logs
$ journalctl -u kubelet -f

# Last 100 log entries
$ journalctl -u kubelet -n 100
```

### Container Runtime

```bash
# Running containers
$ crictl ps

# All containers
$ crictl ps -a

# Container images
$ crictl images

# Pod sandboxes
$ crictl pods

# Container logs
$ crictl logs CONTAINER_ID

# Inspect container
$ crictl inspect CONTAINER_ID

# Open container shell
$ crictl exec -it CONTAINER_ID sh

# Runtime information
$ crictl info
```

### System Troubleshooting

```bash
# Memory utilization
$ free -h

# Disk utilization
$ df -h

# Directory size
$ du -sh /var/lib/containerd

# Running processes
$ ps aux

# Resource utilization
$ top

# Listening ports
$ ss -tulnp

# Display CPU count
$ nproc

# Display hostname
$ hostname
```

### Important Kubernetes File Locations

| File / Directory | Purpose |
|---|---|
| /etc/kubernetes/manifests/ | Static Pod manifests |
| /etc/kubernetes/admin.conf | Administrator kubeconfig |
| /etc/kubernetes/pki/ | Kubernetes certificates |
| /var/lib/kubelet/config.yaml | Kubelet configuration |
| /var/lib/etcd/ | Default local etcd data |
| /etc/containerd/config.toml | Containerd configuration |
| /etc/cni/net.d/ | CNI configuration |
| /opt/cni/bin/ | CNI binaries |
| ~/.kube/config | Default kubeconfig |
| /var/log/pods/ | Pod logs |

---

## 19. Helm, Kustomize and CRDs

### Helm

```bash
# Add repository
$ helm repo add REPO_NAME REPO_URL

# Update repositories
$ helm repo update

# Search repositories
$ helm search repo nginx

# Display releases
$ helm list
$ helm ls

# Display releases across all namespaces
$ helm list --all-namespaces
$ helm ls -A

# Display chart values
$ helm show values REPO_NAME/CHART_NAME

# Install chart
$ helm install web REPO_NAME/CHART_NAME

# Install using custom values
$ helm install web REPO_NAME/CHART_NAME -f values.yaml

# Upgrade release
$ helm upgrade web REPO_NAME/CHART_NAME

# Install or upgrade
$ helm upgrade --install web REPO_NAME/CHART_NAME

# Check release status
$ helm status web

# Check release history
$ helm history web

# Rollback release
$ helm rollback web 1

# Render chart without installing
$ helm template web REPO_NAME/CHART_NAME

# Uninstall release
$ helm uninstall web
```

### Kustomize

```bash
# Preview customized YAML
$ kubectl kustomize ./overlays/dev

# Apply Kustomize configuration
$ kubectl apply --kustomize=./overlays/dev
$ kubectl apply -k ./overlays/dev

# Delete Kustomize resources
$ kubectl delete -k ./overlays/dev
```

### Custom Resource Definitions

```bash
# Display CRDs
$ kubectl get customresourcedefinitions
$ kubectl get crd

# Describe CRD
$ kubectl describe crd example.example.com

# Display available API resources
$ kubectl api-resources

# Display API versions
$ kubectl api-versions

# Install operator resources
$ kubectl apply -f operator.yaml
```

---

## 20. JSONPath and Documentation

```bash
# Display supported resources and shortnames
$ kubectl api-resources

# Display namespaced resources
$ kubectl api-resources --namespaced=true

# Display cluster-scoped resources
$ kubectl api-resources --namespaced=false

# Explain Pod structure
$ kubectl explain pod
$ kubectl explain po

# Explain specific fields
$ kubectl explain pod.spec
$ kubectl explain pod.spec.containers

# Explain Deployment structure recursively
$ kubectl explain deployment --recursive

# Export resource configuration
$ kubectl get deploy nginx -o yaml > deployment.yaml

# Retrieve Pod IP
$ kubectl get po nginx -o jsonpath='{.status.podIP}'

# Retrieve container names
$ kubectl get po nginx -o jsonpath='{.spec.containers[*].name}'

# Retrieve container images
$ kubectl get po nginx -o jsonpath='{.spec.containers[*].image}'

# Retrieve Deployment container names
$ kubectl get deploy nginx -o jsonpath='{.spec.template.spec.containers[*].name}'

# Retrieve Deployment replica count
$ kubectl get deploy nginx -o jsonpath='{.spec.replicas}'

# Retrieve all Node names
$ kubectl get no -o jsonpath='{.items[*].metadata.name}'

# Custom output columns
$ kubectl get po -o custom-columns=NAME:.metadata.name,IP:.status.podIP

# Command documentation
$ kubectl create deployment --help
$ kubectl create deployment -h
```

---

## 21. Terminal Productivity

```bash
# Create kubectl alias
$ alias k=kubectl

# Full command
$ kubectl get pods --all-namespaces

# Short command
$ k get po -A

# Enable Bash autocompletion
$ source <(kubectl completion bash)

# Enable alias autocompletion
$ complete -o default -F __start_kubectl k

# Set default editor
$ export KUBE_EDITOR=vim
```

### Vim Commands

| Command | Purpose |
|---|---|
| i | Insert mode |
| Esc | Normal mode |
| :w | Save |
| :wq | Save and quit |
| :q! | Quit without saving |
| dd | Delete line |
| yy | Copy line |
| p | Paste |
| u | Undo |
| /keyword | Search |
| gg | Beginning of file |
| G | End of file |
| :set number | Display line numbers |
| :set paste | Paste mode |
| :set expandtab | Use spaces instead of tabs |
| :set tabstop=2 shiftwidth=2 | YAML indentation |

---

## 22. Common Troubleshooting Scenarios

| Problem | First Command |
|---|---|
| Pending Pod | kubectl describe po POD |
| CrashLoopBackOff | kubectl logs POD -p |
| ImagePullBackOff | kubectl describe po POD |
| OOMKilled | kubectl describe po POD |
| Pod not ready | kubectl describe po POD |
| Node NotReady | kubectl describe no NODE |
| Service unreachable | kubectl get svc,ep |
| DNS failure | kubectl get po -n kube-system |
| PVC Pending | kubectl describe pvc PVC |
| Permission denied | kubectl auth can-i VERB RESOURCE |
| Failed rollout | kubectl rollout status deploy/NAME |
| Kubelet failure | systemctl status kubelet |
| Runtime failure | systemctl status containerd |
| API server unavailable | crictl ps -a |
| Insufficient resources | kubectl describe no NODE |

---

## CKA Practical Readiness Checklist

- [ ] Core Kubernetes resources
- [ ] Common flags and shortnames
- [ ] Imperative commands
- [ ] Declarative resource management
- [ ] YAML generation
- [ ] Deployments and ReplicaSets
- [ ] Rolling updates and rollbacks
- [ ] Labels and selectors
- [ ] Services
- [ ] ClusterIP, NodePort and LoadBalancer
- [ ] DNS and CoreDNS
- [ ] Ingress
- [ ] Gateway API
- [ ] NetworkPolicies
- [ ] CNI, CSI and CRI
- [ ] Node selectors and affinity
- [ ] Taints and tolerations
- [ ] Resource requests and limits
- [ ] Liveness, readiness and startup probes
- [ ] Node maintenance
- [ ] ConfigMaps and Secrets
- [ ] PersistentVolumes and PVCs
- [ ] StorageClasses
- [ ] RBAC
- [ ] ServiceAccounts
- [ ] Certificates
- [ ] Kubeconfig and contexts
- [ ] Jobs and CronJobs
- [ ] Autoscaling
- [ ] Cluster installation
- [ ] Cluster upgrades
- [ ] Highly available control plane architecture
- [ ] etcd backup and restore
- [ ] Container runtime troubleshooting
- [ ] Helm
- [ ] Kustomize
- [ ] CRDs and Operators
- [ ] JSONPath
- [ ] Kubernetes troubleshooting
- [ ] Timed mock exams

---

## Official Documentation

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Quick Reference](https://kubernetes.io/docs/reference/kubectl/quick-reference/)
- [kubectl Command Reference](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/)
- [CKA Curriculum](https://github.com/cncf/curriculum)
- [Helm Documentation](https://helm.sh/docs/)

---

## Study Rules

1. Learn the concept.
2. Execute the commands.
3. Complete hands-on labs.
4. Intentionally break resources.
5. Troubleshoot and fix them.
6. Rebuild from memory.
7. Push practical examples to GitHub.
8. Complete timed CKA mock exams.

Do not memorize every command.

Understand the architecture, develop command familiarity,
and learn how to troubleshoot independently.
