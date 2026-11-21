# Kubernetes Fundamentals

Hands-on notes for learning Kubernetes fundamentals and preparing for the Certified Kubernetes Administrator (CKA) exam.

## 1. Manifest Structure (YAML)

A Kubernetes manifest describes the desired state of a resource.

| Field | Description | Data type |
| --- | --- | --- |
| `apiVersion` | Kubernetes API group and version | String |
| `kind` | Resource type, such as Pod, Deployment or Service | String |
| `metadata` | Resource information, such as name and labels | Dictionary |
| `spec` | Desired configuration of the resource | Dictionary |
| `spec.containers` | Containers within a Pod | List of dictionaries |

## 2. Create a Pod

A Pod is the smallest deployable unit in Kubernetes. It contains one or more containers.

**File: `nginx.yaml`**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
```

### Create or apply a configuration

```bash
kubectl apply -f nginx.yaml                # Create or update using a manifest
kubectl create -f nginx.yaml               # Create a new resource using a manifest
kubectl run nginx-pod --image=nginx        # Create a Pod directly from the CLI
```

These are alternative methods of creating the same Pod. `create` and `run` fail if the resource already exists.

## 3. Inspect Resources

```bash
kubectl cluster-info                       # Display cluster information
kubectl get nodes                          # List nodes
kubectl get pods                           # List Pods in the current namespace
kubectl get pods -A                        # List Pods across all namespaces
kubectl describe pod nginx-pod             # Display Pod details and events
kubectl get pods -o wide                   # Include Pod IP and assigned node
kubectl get nodes -o wide                  # Display additional node details
kubectl get deployments -o wide            # Display additional Deployment details
kubectl get services -o wide               # Display additional Service details
```

| Flag / command | Purpose |
| --- | --- |
| `-A` | All namespaces |
| `-o` | Specify the output format |
| `-o wide` | Display additional columns |
| `describe` | Inspect resource configuration, status and available events |

### Access a running container

```bash
kubectl exec -it nginx-pod -- sh           # Open an interactive shell
```

- `-i`: Keep standard input open.
- `-t`: Allocate a terminal.
- `--`: Separate kubectl arguments from the command run inside the container.

### Delete resources

```bash
kubectl delete pod nginx-pod                # Delete a Pod and terminate its containers
kubectl delete node worker1                 # Remove the Node resource from Kubernetes
```

> Deleting a Node resource does not shut down or delete its VM or physical machine. In production, drain the node before planned removal to safely evict eligible workloads.

## 4. Namespaces

A namespace logically groups resources within a Kubernetes cluster, similar to a folder.

```bash
kubectl get namespaces                     # List namespaces
kubectl create namespace development       # Create a namespace
kubectl get pods -n development             # List Pods in a specific namespace
kubectl get pods -A                         # List Pods across all namespaces
```

- `-n`: Specify a namespace.
- `-A`: All namespaces.
- Namespaces are not physical boundaries; nodes are cluster-scoped resources.

## 5. ReplicationController and ReplicaSet

Both controllers maintain the desired number of Pod replicas through reconciliation.

| Feature | ReplicationController (RC) | ReplicaSet (RS) |
| --- | --- | --- |
| API version | `v1` | `apps/v1` |
| Selector | Equality-based | Equality-based and set-based |
| Usage | Legacy | Typically managed by a Deployment |

- **Self-healing:** Creates replacement Pods when managed Pods are deleted or reach a terminal state.
- **Scaling:** Creates or removes Pods to match the desired replica count.

### Production workload hierarchy

**Deployment → ReplicaSet → Pods → Containers**

A Deployment manages ReplicaSets and application rollouts. ReplicaSets maintain Pod replicas, and Pods run containers.

### ReplicationController manifest

**File: `nginx-rc.yaml`**

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx-rc
spec:
  replicas: 3                 # Desired number of Pods
  selector:
    app: nginx-rc             # Selects managed Pods
  template:                   # Blueprint for creating Pods
    metadata:
      labels:
        app: nginx-rc         # Must match the selector
    spec:
      containers:
        - name: nginx-container
          image: nginx
```

```bash
kubectl apply -f nginx-rc.yaml              # Create or update the controller
kubectl get rc                              # List ReplicationControllers
kubectl get replicationcontroller           # Same as kubectl get rc
kubectl describe rc nginx-rc                # Inspect the controller
kubectl scale rc nginx-rc --replicas=5      # Scale to five Pods
kubectl delete rc nginx-rc                  # Delete the controller and its Pods
```

### ReplicaSet manifest

**File: `nginx-rs.yaml`**

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3                 # Desired number of Pods
  selector:
    matchLabels:
      app: nginx              # Selects managed Pods
  template:                   # Blueprint for creating Pods
    metadata:
      labels:
        app: nginx            # Must match the selector
    spec:
      containers:
        - name: nginx-container
          image: nginx
```

| Field | Purpose |
| --- | --- |
| `replicas` | Desired number of Pods |
| `selector` | Determines which Pods belong to the controller |
| `template` | Blueprint used to create new Pods |
| `labels` | Key-value pairs used to identify resources |

### ReplicaSet commands

```bash
kubectl apply -f nginx-rs.yaml              # Create or update the ReplicaSet
kubectl get rs                              # List ReplicaSets
kubectl get replicaset                      # Same as kubectl get rs
kubectl get pods                            # List Pods
kubectl get pods -o wide                    # Show Pod IPs and assigned nodes
kubectl describe rs nginx-rs                # Inspect ReplicaSet configuration and status
kubectl scale rs nginx-rs --replicas=5      # Scale to five Pods
kubectl delete rs nginx-rs                  # Delete the ReplicaSet and its Pods
```

### Understanding ReplicaSet status

| Column | Meaning |
| --- | --- |
| `DESIRED` | Number of Pods requested in the spec |
| `CURRENT` | Number of active replicas currently observed |
| `READY` | Number of Pods that are ready |

`DESIRED=4`, `CURRENT=4`, `READY=0` means four active replicas exist, but none is ready yet. Inspect the Pods for image-pull errors, startup failures or failed readiness checks.

```bash
kubectl get pods -l app=nginx
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

## 6. Labels and Selectors

- **Label:** Identifies a resource using a key-value pair.
- **Selector:** Filters resources based on matching labels.
- **ReplicaSet:** Manages matching Pods to maintain the desired replica count.

### How selectors work

```yaml
selector:
  matchLabels:
    app: nginx
template:
  metadata:
    labels:
      app: nginx
```

- Every selector requirement must match the Pod template's labels; otherwise, Kubernetes rejects the manifest.
- The Pod template may contain additional labels.
- A ReplicaSet's own `metadata.labels` is independent of the Pod selector.
- A ReplicaSet can adopt matching Pods in the same namespace that have no controlling owner.
- Avoid overlapping selectors between controllers.

### Filter and delete Pods using labels

```bash
kubectl get pods --show-labels              # Display Pod labels
kubectl get pods -l app=nginx               # Filter matching Pods
kubectl delete pods -l app=nginx            # Delete matching Pods in the current namespace
kubectl delete pods --all                   # Delete all Pods in the current namespace
```

`-l` specifies a label selector. Always verify matching Pods before deleting them. A ReplicaSet automatically recreates deleted Pods to maintain its desired replica count.

## 7. Scaling and Editing Resources

### Declarative scaling

Update the replica count in `nginx-rs.yaml`:

```yaml
spec:
  replicas: 5
```

Then apply the manifest:

```bash
kubectl apply -f nginx-rs.yaml
```

### Imperative scaling

```bash
kubectl scale rs nginx-rs --replicas=5      # Update the live replica count
```

Kubernetes creates or removes replicas to reach the requested count. Imperative commands change the live resource, not the local YAML file.

### Edit a live resource

```bash
kubectl edit pod nginx-pod                  # Edit a Pod's supported fields
kubectl edit rs nginx-rs                    # Edit a ReplicaSet
```

`kubectl edit` opens the live resource in a text editor and submits changes when saved. Only fields supported for updates can be modified.

| Method | Use case |
| --- | --- |
| `kubectl edit` | Quick live changes and CKA tasks |
| `kubectl scale` | Quickly adjust the replica count |
| YAML + `kubectl apply` | Repeatable, version-controlled configuration |

> **Important:** Editing a ReplicaSet's Pod template does not automatically update existing Pods. Newly created Pods use the updated template. In a lab, delete old managed Pods to replace them; in production, use a Deployment for controlled rolling updates. Keep the source manifest in sync with any live changes, since applying an updated manifest can overwrite those changes.

## 8. Troubleshooting and Reference

```bash
kubectl explain pod                        # Inspect the Pod API schema
kubectl explain replicaset                 # Inspect the ReplicaSet API schema
kubectl explain replicaset.spec.selector   # Inspect a specific field
kubectl get events                         # Inspect recent namespace events
```

**CKA focus:** Create, inspect, edit, scale and troubleshoot resources using `kubectl`. Understand the relationship between desired state, selectors and controllers instead of memorizing every YAML field.

**Production practice:** Keep manifests in version control and manage replicated applications through Deployments.
