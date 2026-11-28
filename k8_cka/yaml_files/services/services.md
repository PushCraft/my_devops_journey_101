
## Kubernetes Services

### 1. Simple Explanation
- **Pod:** Runs the application. Its IP can change.
- **Deployment:** Manages Pods, replicas, and updates.
- **Service:** Provides stable networking access to Pods.
- A Service is **not a physical server, Pod, or container**.
- Services select Pods using **labels and selectors**.

### 2. Types of Services

| Type | Purpose |
|---|---|
| ClusterIP | Internal cluster communication (default) |
| NodePort | External access using `NodeIP:NodePort` |
| LoadBalancer | External access using a load balancer |



--------------------

# Kubernetes Services

A Service provides a stable network endpoint for accessing Pods.
It uses labels and selectors to identify the target Pods.

## 1. ClusterIP

- Default Service type in Kubernetes.
- Assigns an internal virtual IP to the Service.
- Used for communication within the cluster.
- Not directly accessible externally by default.

Traffic Flow:
Internal Pod → ClusterIP:Port → Target Pod:TargetPort

Example:
10.96.0.100:80 → 10.244.1.5:8080

```yaml
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 8080
```
Use Case: Frontend communicating with backend APIs or databases.

## 2. NodePort
- Exposes the Service through a port on the nodes.
- Allows external machines to access the application.
- Default NodePort range: 30000–32767.
- Also receives a ClusterIP.

Traffic Flow:
External Machine → NodeIP:NodePort → Service → Target Pod

Example:
192.168.1.10:30080 → Service:80 → Pod:8080

```yaml
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30080
```
Use Case: Development, testing and external application access.

## 3. LoadBalancer

- Exposes the Service through an external load balancer.
- Requires a supported cloud provider or load balancer implementation.
- Automatically provisions a load balancer when supported.
- Also receives a ClusterIP and typically a NodePort.
- May incur additional cloud costs.

Traffic Flow:
External Machine → Load Balancer → Kubernetes Backend Pods

```yaml
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 8080
```
Use Case: Exposing production applications externally.

## Common Port Definitions
- port: Port exposed by the Service.
- targetPort: Application's listening port inside the Pod.
- nodePort: Port exposed on the nodes.

## Common Commands

```bash
kubectl get services
kubectl get svc
kubectl describe svc nginx-service
kubectl get svc -o wide
kubectl delete svc nginx-service
```

## Differences Between Services

| Feature         | ClusterIP     | NodePort       | LoadBalancer     |
|-----------------|---------------|----------------|------------------|
| Internal Access | Yes           | Yes            | Yes              |
| External Access | No (default)  | Yes            | Yes              |
| ClusterIP       | Yes           | Yes            | Yes              |
| NodePort        | No            | Yes            | Typically yes    |
| Load Balancer   | No            | No             | Yes              |
| Access Method   | Service IP    | Node IP:Port   | LB IP/DNS        |
| Default Type    | Yes           | No             | No               |
| Common Use      | Internal APIs | Testing        | Production       |

## Quick Remember

ClusterIP    = Internal communication.
NodePort     = External access through Node IP and Port.
LoadBalancer = External access through a Load Balancer.

All three use selectors to identify target Pods
when configured with a selector.
--------------------

### 4. Service YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30008
```



### 5. Advanced / CKA Notes
- Service provides a stable **ClusterIP and DNS name**.
- `kube-proxy` (or an alternative implementation) handles Service traffic forwarding.
- Service selectors must match Pod labels.
- Services typically distribute connections across eligible, ready Pods.
- **EndpointSlices** track backend Pod IPs and ports.
- If a Pod is replaced, EndpointSlices are updated automatically.
- If labels don't match, the Service has no matching backend Pods.
- NodePort requires network/firewall access to the Node IP and port.
- LoadBalancer requires a supported load balancer implementation.



**Remember:** Deployment manages Pods. Service provides stable access to them.



![alt text](image.png)
![kub](image-1.png)



# To list all supported Kubernetes resource names and their short forms:
$ kub kubectl api-resources 