# AWS Managed Ingress Design
- Platform Infrastructure: Elastic Load Balancing (ELB)
- Core Architecture: Layer 7 Application Load Balancer Routing
- Implementation Logic: Host and Path-pattern Evaluation Rules
## Decision 04: Split-Horizon Domain Name Resolution via Route 53
* **Context**: Public clients require external entry paths to our services, while private internal microservices need consistent name resolution without exposing internal backend network topologies to the internet.
* **Decision**: Implement Split-Horizon DNS using a parallel pair of Route 53 Public and Private Hosted Zones mapped to the same ecom domain name.
* **Justification**: Public zones will expose an AWS Alias record pointing securely to our ecom-nlb-service endpoint. Private zones will map internal host names strictly inside our VPC CIDR block, ensuring backend traffic stays off the public internet, operates with minimal lookups, and avoid external query charges.


