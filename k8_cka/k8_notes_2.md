# Kubernetes — Deployment

## 1. Fundamentals

A Deployment manages ReplicaSets and provides:

- **Scaling:** Increase or decrease the number of Pods.
- **Self-healing:** Replace failed Pods through ReplicaSets.
- **Rolling updates:** Gradually replace Pods with a new application version.
- **Rollbacks:** Restore a previous application version.
- **Revision history:** Track Pod template revisions.

### Architecture

```mermaid
flowchart TD
    A[Deployment] --> B[ReplicaSet]
    B --> C[Pod 1]
    B --> D[Pod 2]
    B --> E[Pod 3]
    C --> F[Container]
    D --> G[Container]
    E --> H[Container]
```

| Resource | Responsibility |
|---|---|
| Deployment | Manages application versions |
| ReplicaSet | Maintains the desired Pod count |
| Pod | Hosts one or more containers |
| Container | Runs the application |

## 2. Rolling Update

When the container image changes, the Deployment:

1. Creates a new ReplicaSet.
2. Gradually creates Pods with the new image.
3. Gradually removes Pods with the old image.
4. Completes the update while maintaining availability when properly configured.

Unlike a standalone ReplicaSet, a Deployment automatically replaces existing Pods when its Pod template changes.

## 3. Definition File — nginx-deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: nginx-deployment

spec:
  replicas: 3

  selector:
    matchLabels:
      app: nginx

  template:
    metadata:
      labels:
        app: nginx

    spec:
      containers:
        - name: nginx
          image: nginx:1.26
```

The basic definition is almost identical to a ReplicaSet, except for `kind: Deployment`.

## 4. Commands

```bash
kubectl apply -f nginx-deployment.yaml      # Create or update
kubectl get deploy                         # List Deployments
kubectl get rs                             # List ReplicaSets
kubectl get pods                           # List Pods
kubectl describe deploy nginx-deployment   # View details
kubectl edit deploy nginx-deployment       # Edit live configuration
kubectl delete deploy nginx-deployment     # Delete Deployment
```

### Scaling

```bash
kubectl scale deploy nginx-deployment --replicas=5
```

### Update Image

```bash
kubectl set image deploy nginx-deployment nginx=nginx:1.28
```

Syntax: `container-name=new-image`

### Rollout Management

```bash
kubectl rollout status deploy nginx-deployment   # Update progress
kubectl rollout history deploy nginx-deployment  # Revision history
kubectl rollout undo deploy nginx-deployment     # Rollback
kubectl rollout restart deploy nginx-deployment  # Restart Pods
```

## 5. Troubleshooting

| Command | Purpose |
|---|---|
| `kubectl get pods` | Check Pod status |
| `kubectl get rs` | Check old and new ReplicaSets |
| `kubectl describe pod pod-name` | Investigate errors and events |
| `kubectl logs pod-name` | Check application logs |

## 6. ReplicaSet vs Deployment

| Feature | ReplicaSet | Deployment |
|---|---|---|
| Self-healing | Yes | Yes |
| Scaling | Yes | Yes |
| Rolling updates | No | Yes |
| Rollbacks | No | Yes |
| Revision history | No | Yes |

**Production rule:** Manage the Deployment instead of directly modifying its underlying ReplicaSets or Pods.

**Remember:** Deployment = Version management. ReplicaSet = Quantity management. Pod = Hosts containers.
