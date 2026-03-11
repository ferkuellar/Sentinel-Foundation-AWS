# Trade-Off Register

## Trade-Off 1: Custom Foundation vs AWS Control Tower

### Selected

Custom foundation baseline

### Why

- more implementation control
- better for learning
- easier to reproduce in a portfolio

### Accepted downside

- fewer managed guardrails out of the box
- less enterprise-native than Control Tower on day one

---

## Trade-Off 2: Single NAT vs NAT per AZ

### Selected

Single NAT Gateway

### Why

- lower baseline cost
- simpler Terraform topology
- easier demo reproducibility

### Accepted downside

- reduced resilience
- egress single point of failure

---

## Trade-Off 3: CMK vs AWS-Managed Encryption

### Selected

Customer managed KMS key

### Why

- stronger control
- clearer security ownership
- better enterprise narrative

### Accepted downside

- more complexity
- extra policy management
- additional KMS request cost

---

## Trade-Off 4: Bastion vs Session Manager

### Selected

Bastion access pattern for current baseline

### Why

- visible and easy to explain
- useful for portfolio demonstration

### Accepted downside

- larger exposure surface
- weaker posture than a mature Session Manager pattern

## Future Direction

Later phases may shift toward:

- Control Tower alignment
- NAT per AZ
- broader managed encryption decisions where appropriate
- Session Manager-based administration
