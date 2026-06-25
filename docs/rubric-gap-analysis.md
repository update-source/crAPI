# Rubric Gap Analysis Against `project.md`

## 1. Purpose of this document

This document compares the current project state against the evaluation rubric and implementation expectations described in `project.md`. Its goal is to identify:

- what has already been achieved
- what is only partially implemented
- what is still missing
- which next steps would have the highest impact on the final score

This is a **gap analysis**, not a replacement for the final report.

---

## 2. Reference rubric from `project.md`

According to `project.md`, the suggested assessment rubric is:

- **Architecture & threat modeling: 20%**
- **Implementation & reproducibility (IaC, automation): 30%**
- **Security testing & remediation (DAST, fuzzing, pentest): 30%**
- **Documentation, runbooks & presentation: 20%**

---

## 3. Overall assessment summary

Based on the current project state, the strongest areas are:

- architecture and threat modeling
- practical deployment context
- documentation momentum

The weakest area, relative to the rubric, is:

- security testing and remediation evidence

A second weaker area is:

- implementation reproducibility and automation, especially compared with the more ambitious target architecture in `project.md`

---

## 4. Category-by-category comparison

### 4.1 Architecture & threat modeling (20%)

#### Expected by the rubric

The project expects:

- a clear architecture view
- an explicit threat model
- identification of attack surfaces
- a security-oriented system decomposition
- linkage between architecture choices and security controls

#### What has already been done

Current strengths include:

- the deployed system has been decomposed into core services, data stores, support components, and deployment layers
- solution architecture and deployment scenario have been explicitly separated
- trust boundaries have been identified
- a deployed-environment threat model has been written
- STRIDE has been applied by layer
- diagrams have been added to the threat model markdown

#### What is still missing or weaker

- a formal threat register table is not yet included in the current documentation set
- mitigation mapping is still high-level rather than tied to individual threats in a table
- canonical references are mentioned conceptually, but the report should explicitly cite standards and official sources
- the threat model should ideally link each major security objective to specific architectural decisions

#### Assessment

This category is currently one of the strongest.

#### Estimated position

**Approximate standing: 14/20 to 17/20**

#### Highest-impact next steps

- add a threat register table
- map major threats to mitigations and residual risk
- add references to OWASP, NIST, and relevant RFCs in the report

---

### 4.2 Implementation & reproducibility (30%)

#### Expected by the rubric

The rubric and project description emphasize:

- reproducible deployment
- infrastructure-as-code or clearly repeatable deployment steps
- automation where possible
- implementation of meaningful protection mechanisms
- evidence that the system can be redeployed or reproduced

#### What has already been done

Current strengths include:

- the system is deployed on a real Oracle Cloud Ubuntu VM
- a real domain is used
- Cloudflare proxying and TLS are configured
- Docker Compose deployment is in place
- Kong is part of the deployed stack
- trusted TLS between internal services has been introduced in multiple places
- Grafana, Loki, and Promtail have been deployed in practice

#### What is still missing or weaker

Compared to the ambition of `project.md`, the current implementation is less complete in the following areas:

- infrastructure-as-code is not yet a central part of the deliverable
- deployment reproducibility has not yet been presented as a step-by-step reproducible process for external evaluators
- the project.md target mentions components such as a formal IdP, WAF, KMS/Vault, and stronger policy automation; these are not fully implemented in the current system
- the implementation strategy is more practical and incremental than the original idealized architecture

#### Assessment

This category is acceptable but not yet strong relative to the rubric's expectations.

#### Estimated position

**Approximate standing: 15/30 to 21/30**

#### Highest-impact next steps

- document exact deployment steps so the system is demonstrably reproducible
- explicitly explain which parts of `project.md` were implemented, partially implemented, or deferred
- add a small “reproducibility” section listing prerequisites, deployment steps, and validation checks
- if feasible, add at least lightweight infrastructure automation or deployment scripting evidence

---

### 4.3 Security testing & remediation (30%)

#### Expected by the rubric

The project description strongly emphasizes:

- DAST
- fuzzing
- pentest activities
- attack simulation
- remediation evidence
- testing of OWASP-style API risks

#### What has already been done

From the current project state, the visible work is stronger on:

- deployment hardening direction
- observability setup
- threat modeling
- architecture analysis

#### What is still missing or weaker

This is currently the biggest gap area.

The report would benefit significantly from concrete evidence such as:

- DAST results using OWASP ZAP or equivalent
- at least one or two API abuse or attack simulation scenarios
- evidence of findings and remediation
- before/after behavior showing that a mitigation reduced risk
- tests aligned with the attack surface of the deployed system

Examples of suitable scenarios:

- broken access control / ownership abuse
- authentication misuse or token-related abuse
- rate-limit or abuse testing
- sensitive exposure testing through support interfaces or logs

#### Assessment

This category currently appears underdeveloped compared to its weight in the rubric.

#### Estimated position

**Approximate standing: 8/30 to 15/30**

#### Highest-impact next steps

- run at least one meaningful DAST workflow
- document one or more realistic attack scenarios against the deployed stack
- record findings, fixes, and post-fix validation
- create a short findings-to-remediation table

---

### 4.4 Documentation, runbooks & presentation (20%)

#### Expected by the rubric

The rubric expects:

- coherent reporting
- clear diagrams
- operational clarity
- runbooks or practical handling procedures
- presentable, structured deliverables

#### What has already been done

Current strengths include:

- a substantial threat model document exists
- diagrams have been added
- deployment context is clearly described
- security objectives are identified
- the distinction between architecture and deployment has been clarified

#### What is still missing or weaker

- runbooks are not yet clearly present as standalone operational artifacts
- incident-response style handling steps are not yet documented
- there should be concise procedures for handling issues like exposed ports, log exposure, certificate rotation, and service failure
- the presentation narrative should explicitly explain why the implementation deviates from the idealized target in `project.md`

#### Assessment

This category is in reasonably good shape and is relatively easy to improve further.

#### Estimated position

**Approximate standing: 13/20 to 17/20**

#### Highest-impact next steps

- add short runbooks for a few realistic incidents
- add figure captions and polished report wording
- prepare a short presentation narrative connecting goals, constraints, risks, and mitigations

---

## 5. Consolidated score outlook

The following is a rough score outlook based on the current project state.

| Category | Weight | Estimated current range |
|---|---:|---:|
| Architecture & threat modeling | 20 | 14–17 |
| Implementation & reproducibility | 30 | 15–21 |
| Security testing & remediation | 30 | 8–15 |
| Documentation, runbooks & presentation | 20 | 13–17 |

### Estimated total range

**Approximate total: 50/100 to 70/100**

A more realistic midpoint estimate is around:

**60–65/100**

This estimate assumes the current state remains mostly unchanged and that the final grading follows the suggested rubric in `project.md` relatively closely.

---

## 6. Key mismatch between `project.md` and current implementation

A major point to communicate clearly in the final report is that the current project follows a **practical adaptation strategy** rather than a full implementation of every ideal component suggested by `project.md`.

### `project.md` envisions a more ambitious target stack

Examples include:

- a formal IdP-centered design
- WAF integration
- KMS or Vault style secret management
- policy engines such as OPA
- stronger automation and IaC
- systematic attack simulation and automated security testing

### Current project direction is more practical and bounded

The current project instead focuses on:

- deploying a real crAPI-based stack
- hardening it incrementally
- improving internal TLS and service trust
- using real cloud deployment context
- adding observability and exposure analysis
- building a realistic threat model tied to the deployed environment

This is not inherently wrong, but it must be explained explicitly so the evaluators understand the scope and trade-offs.

---

## 7. Highest-impact actions to improve the final score

### Priority 1 — Improve security testing and remediation evidence

This is the largest scoring opportunity and the current weakest area.

Minimum high-value additions would be:

- one DAST workflow
- one or two attack scenarios
- a findings table
- proof of remediation or mitigation impact

### Priority 2 — Strengthen reproducibility and implementation narrative

Useful additions include:

- a reproducible deployment section
- exact deployment steps
- environment assumptions
- what was implemented versus deferred from `project.md`

### Priority 3 — Add concise runbooks and operational procedures

Examples:

- public port exposure response
- certificate rotation or expiration response
- suspicious log exposure response
- service outage response

### Priority 4 — Formalize threat tracking

Useful additions include:

- threat register
- mitigation mapping
- residual risk summary

---

## 8. Recommended framing for the final report

To make the project look coherent and defensible, the final report should present the work as:

> A practical deployment and hardening study of a modified OWASP crAPI system in a real cloud environment, with a focus on threat modeling, exposure analysis, service trust hardening, and operational visibility, while acknowledging that some of the broader idealized controls from the original project brief were only partially implemented due to system complexity and time constraints.

This framing is important because it explains:

- why the implementation does not match every ambitious feature in `project.md`
- why the chosen scope is still meaningful
- how the work remains aligned with the learning goals in a realistic way

---

## 9. Final conclusion

At the current stage, the project is strongest in:

- architecture and threat modeling
- real deployment awareness
- documentation potential

The biggest score risk is the lack of strong, explicit evidence in:

- security testing
- remediation validation
- reproducibility and automation depth

If the next effort is focused on those gaps, the final score can improve significantly without requiring a full architectural rewrite of the system.
