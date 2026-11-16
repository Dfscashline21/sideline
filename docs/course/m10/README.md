# M10 · Cloud, IaC, security and cost: module overview

> **Epic:** [#11](https://github.com/Dfscashline21/sideline/issues/11) ·
> **Weeks:** 18 to 19 · **Ready when:** you can tear down and rebuild the
> whole platform from code in under an hour.

> **Written ahead of time.** These labs were drafted before M2 to M9
> existed. They use the default names from the course (bucket
> `sideline-lake`, Dagster in `orchestration/`, dbt in `transform/`,
> leagues `nba`, `wnba`, `ncaa_m`, `ncaa_w`). Where you built something
> differently, keep your names and adapt the steps.

## Cost safety first: read before you create anything

This is the first module that can cost real money. Two habits, from
day one:

1. **Budget alarm before the first resource.** Before M10.2 creates
   anything, create an AWS Budget by hand in the console: a monthly cost
   budget at a number you'd be annoyed but not hurt to lose (e.g. $20),
   with email alerts at 50%, 80% and 100% of *actual* and 100% of
   *forecasted* spend. M10.9 later replaces it with Terraform. Until then
   the hand-made one is your seatbelt.
2. **Teardown is part of every session.** End each working session with
   `terraform destroy` on anything that bills by the hour (ECS services,
   RDS, NAT gateways, load balancers), or at least scale ECS services to 0.
   Keep a `make cloud-down` target (M10.2) so it's one command.

The usual surprise bills on a small platform, in rough order:

| Resource | Why it surprises people |
|---|---|
| NAT gateway | Hourly charge *plus* per-GB processing, even when idle. Often the biggest line item on a hobby platform |
| RDS instance | Bills every hour it exists, even with no queries |
| Application Load Balancer | Hourly charge whether or not anyone visits |
| Snowflake / BigQuery | Warehouses left running; trial credits run out quietly |
| Secrets Manager, KMS keys | Small per-month charges per secret or key that add up and linger |
| Public IPv4 addresses | AWS charges for every public IPv4 address, including Fargate tasks with public IPs |

Look prices up on the [AWS pricing pages](https://aws.amazon.com/pricing/)
for your region rather than trusting any number in a tutorial; they change.

Use a **separate AWS account** for Sideline (AWS Organizations makes a
member account free), never your employer's, and enable MFA on the root
user before anything else.

## The path

```
                         M10.1 study (IAM, VPC, state, FinOps)
                                        │
                                        ▼
                         M10.2 Terraform layout + remote state
                          │             │                  │
                          ▼             ▼                  ▼
                 M10.3 S3 lakehouse   M10.9 budget alarm   M10.8 PII masking
                   + catalog            + cost report       (local first, then cloud)
                   │       │
                   ▼       ▼
     M10.4 Dagster on ECS   M10.5 warehouse reads Iceberg
                   │
                   ▼
     M10.7 CI/CD deploy dev → prod
                   │
                   ▼
     M10.6 IAM least-privilege review   (needs every policy to exist)
                   │
                   ▼
     M10.10 cut cost 30%   (needs ~1 week of cost data from M10.9 tags)
                   │
                   ▼
     M10.11 security-boundary diagram ──► M10.12 closed-book teardown/rebuild

     M10.13 STAR story: any time
```

M10.3, M10.8 and M10.9 can run in parallel once M10.2 is merged. M10.10
needs real spend to measure, so turn on cost-allocation tags (M10.9)
**early** and let a few days of data accumulate.

## Where your work goes

```
infra/
├── README.md                    # how to bootstrap, plan, apply, destroy
├── terraform/
│   ├── bootstrap/               # state bucket; applied once with local state
│   ├── modules/
│   │   ├── network/             # VPC, subnets, endpoints, security groups
│   │   ├── lake/                # S3 buckets, encryption, lifecycle
│   │   ├── catalog/             # Glue database(s) or REST catalog service
│   │   ├── orchestrator/        # ECS cluster, Dagster services, RDS
│   │   ├── ci/                  # GitHub OIDC provider + deploy roles
│   │   └── cost/                # budgets, SNS, cost allocation tags
│   └── envs/
│       ├── dev/                 # backend.tf, main.tf, variables
│       └── prod/
└── scripts/
    └── cost_report.py           # M10.9
docs/
├── adr/NNN-cloud-catalog.md     # Glue vs REST catalog (M10.3)
├── cost/                        # monthly reports, the 30% write-up (M10.9, M10.10)
└── notes/m10.md
```

## Versions checked when these labs were written (Nov 2026)

| Tool | Version | Note |
|---|---|---|
| Terraform | 1.17.x | S3 backend native locking via `use_lockfile` |
| AWS provider | 6.73.x | Pin with `~> 6.0` and commit the lock file |
| `aws-actions/configure-aws-credentials` | v6.3.0 | Pin the exact tag (lesson from M0.5) |
| Dagster | 1.13.x | `dagster-aws` provides `EcsRunLauncher` |

## Concepts you'll use everywhere in M10

| Concept | One-line version |
|---|---|
| Implicit deny | Everything is denied unless some policy allows it; an explicit `Deny` beats any `Allow` |
| Identity vs resource policy | Attached to a role/user ("what can I do?") vs attached to a bucket/key ("who can touch me?") |
| Role assumption | Services, CI and Snowflake never get long-lived keys; they assume a role and get temporary credentials |
| Remote state + lock | State lives in S3 so CI and you share it; the lock stops two applies at once |
| Tags → cost allocation | Tags only show up in Cost Explorer after you **activate** them as cost allocation tags, and only for spend after activation |
| Stateful vs stateless | Buckets and the catalog hold data; ECS and RDS for Dagster can be rebuilt. Design so teardown never loses the lake by accident |

## Gotchas in this repo

- **`.gitignore` ignores `*.tfvars` and `.terraform.lock.hcl`** (set in
  M0.1). HashiCorp recommends **committing** the lock file, so remove that
  line in M10.2. For per-environment values, either commit non-secret
  settings as `locals` in `envs/<env>/main.tf`, or add a negation
  (`!infra/terraform/envs/*/terraform.tfvars`). Never commit secrets either way.
- **The repo is public.** Account IDs aren't secret, but don't commit them
  casually, and never commit access keys. CI uses OIDC (M10.7), not keys.
- **Region.** Pick one (e.g. `us-east-1`) and use it everywhere. Billing
  metrics for CloudWatch alarms live only in `us-east-1`.

## Labs

| Ticket | Lab | Mode |
|---|---|---|
| [M10.1](https://github.com/Dfscashline21/sideline/issues/131) | [Study: IAM, VPC, Terraform state, FinOps](m10.1-study.md) | hand |
| [M10.2](https://github.com/Dfscashline21/sideline/issues/132) | [Terraform layout and remote state](m10.2-terraform-layout.md) | mixed |
| [M10.3](https://github.com/Dfscashline21/sideline/issues/133) | [S3 lakehouse and catalog](m10.3-s3-lakehouse.md) | agent |
| [M10.4](https://github.com/Dfscashline21/sideline/issues/134) | [Dagster on ECS](m10.4-orchestrator-ecs.md) | agent |
| [M10.5](https://github.com/Dfscashline21/sideline/issues/135) | [Warehouse reading Iceberg](m10.5-warehouse-iceberg.md) | mixed |
| [M10.6](https://github.com/Dfscashline21/sideline/issues/136) | [IAM least-privilege review](m10.6-iam-review.md) | hand |
| [M10.7](https://github.com/Dfscashline21/sideline/issues/137) | [CI/CD deploy across environments](m10.7-cicd-deploy.md) | agent |
| [M10.8](https://github.com/Dfscashline21/sideline/issues/138) | [PII masking for the analyst role](m10.8-pii-masking.md) | hand |
| [M10.9](https://github.com/Dfscashline21/sideline/issues/139) | [Budget alarm and cost-per-league report](m10.9-budget-cost-report.md) | mixed |
| [M10.10](https://github.com/Dfscashline21/sideline/issues/140) | [Cut cost 30%](m10.10-cut-cost.md) | hand |
| [M10.11](https://github.com/Dfscashline21/sideline/issues/141) | [Security-boundary diagram](m10.11-security-diagram.md) | hand |
| [M10.12](https://github.com/Dfscashline21/sideline/issues/142) | [Ready-when check: teardown and rebuild](m10.12-ready-when.md) | hand |
| [M10.13](https://github.com/Dfscashline21/sideline/issues/143) | [STAR story](m10.13-star-story.md) | hand |
