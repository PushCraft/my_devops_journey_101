# Microservices Architecture

Microservices Architecture divides a large application into
multiple smaller, independent services.

Each microservice performs a specific business function and
can be independently deployed, scaled, updated and managed.

## Example: E-Commerce Application

- Frontend Service       -> User interface
- Authentication Service -> User login
- Payment Service        -> Payment processing
- Inventory Service      -> Stock management
- Notification Service   -> Emails and alerts

## Advantages

- Granular control: Manage individual application components.
- Independent scaling: Scale only the required microservice.
- Fault isolation: One service failure may not affect others.
- Independent updates: Update or roll back individual services.
- Cost optimization: Allocate resources where required.
- Independent security and access controls.

## Example 1: Independent Scaling

During Black Friday, the Payment Service requires more resources.

Frontend:       3 Pods
Authentication: 2 Pods
Payment:        2 Pods -> 10 Pods
Inventory:      2 Pods

Only the Payment Deployment needs to be scaled.

kubectl scale deployment payment --replicas=10

## Example 2: Fault Isolation

If the Notification Service crashes:

- Customers may still be able to place orders.
- Payment processing may continue.
- Email notifications may temporarily stop.

Fault isolation depends on how the services are designed
and how they depend on each other.

## Example 3: Independent Updates

Update only the Payment Service without redeploying
the entire application.

kubectl set image deployment/payment payment=payment:v2

If the update fails:

kubectl rollout undo deployment/payment

## Microservices in Kubernetes

- Deployment: Manages each microservice's Pods.
- ReplicaSet: Maintains the desired number of Pods.
- ClusterIP: Internal communication between microservices.
- LoadBalancer: External application access.
- Labels/Selectors: Connect Services to matching Pods.
- CoreDNS: Resolves Service names.
- HPA: Automatically scales individual microservices.

## Communication

External User
    |
LoadBalancer Service
    |
Frontend Pods
    |
    |--- ClusterIP -> Payment Pods
    |--- ClusterIP -> Authentication Pods
    |--- ClusterIP -> Inventory Pods

## Disadvantages

- Increased network complexity.
- More difficult troubleshooting.
- Service dependency failures.
- Increased infrastructure and management overhead.

## Monolithic vs Microservices

| Feature        | Monolithic       | Microservices        |
|----------------|------------------|----------------------|
| Architecture   | One application  | Independent services |
| Scaling        | Entire app       | Individual service   |
| Updates        | Entire app       | Individual service   |
| Fault Isolation| Limited          | Potentially better   |
| Complexity     | Lower            | Higher               |
| Control        | Application level| Granular             |

## Remember

Microservices = Application Architecture.
Kubernetes    = Container Orchestration Platform.

Microservices divide the application into independent components.
Kubernetes helps deploy, scale, network and manage those components.