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



----------------------------------------------------------------------------------------------------------------------------------------


# Kubernetes: Deployment Updates and Rollbacks

## 1. Update a Deployment

**Option 1: Update using YAML**

```
kubectl apply -f deployment-definition.yml
```

- Creates or updates resources based on the YAML configuration.
- If the Pod template changes, Kubernetes triggers a rollout.

**Option 2: Update the container image directly**

```
kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1
```

- Updates the container image directly in the running cluster.
- No YAML editing required.
- Triggers a Rolling Update by default if the image changes.
- Does not modify the original YAML file.

## 2. Deployment Update Strategies

### Recreate

- Scales down the old ReplicaSet to **0 Pods**.
- Creates or scales up the new ReplicaSet with the updated configuration.
- Causes downtime because old Pods terminate before new ones start.
- The old ReplicaSet is generally retained for rollback.

### RollingUpdate (Default)

- Gradually replaces old Pods with new Pods.
- Old and new ReplicaSets coexist during the update.
- Helps maintain application availability.
- Updates are **not necessarily one Pod at a time**.

Controlled by:

- `maxSurge`: Maximum extra Pods allowed during an update (default: 25%).
- `maxUnavailable`: Maximum unavailable Pods allowed during an update (default: 25%).

## 3. Check Update Status and History

**Check rollout status:**

```
kubectl rollout status deployment/myapp-deployment
```

**View revision history:**

```
kubectl rollout history deployment/myapp-deployment
```

## 4. Rollback (Undo Changes)

**Rollback to the previous revision:**

```
kubectl rollout undo deployment/myapp-deployment
```

- Restores the previous Deployment Pod template, including its container image.
- Kubernetes performs the rollback using the Deployment's update strategy.
- Useful when an updated application version fails.

**Rollback to a specific revision:**

```
kubectl rollout undo deployment/myapp-deployment --to-revision=1
```

**Note:** Kubernetes does not automatically roll back a failed Deployment by default.

## 5. Quick Command Summary

| Action             | Command                                                           |
| ------------------ | ----------------------------------------------------------------- |
| Create             | `kubectl create -f deployment-definition.yml`                     |
| Get Deployments    | `kubectl get deployments`                                         |
| Apply YAML changes | `kubectl apply -f deployment-definition.yml`                      |
| Update image       | `kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1` |
| Check rollout      | `kubectl rollout status deployment/myapp-deployment`              |
| View history       | `kubectl rollout history deployment/myapp-deployment`             |
| Rollback           | `kubectl rollout undo deployment/myapp-deployment`                |

**CKA Key Takeaway:**

`Deployment → ReplicaSet → Pods → Containers`

- **Apply:** Create/update resources using YAML.
- **Set image:** Update the container image directly.
- **RollingUpdate:** Gradually replace Pods (default).
- **Recreate:** Terminate old Pods before starting new ones.
- **Rollback:** Restore the previous Deployment Pod template.
























