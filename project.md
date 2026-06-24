# Capstone Project — Cloud API‑Based Network Application Security for Small Company Services

**Subject:** NT219 - Cryptography

**Project Title:** Cloud API-Based Network Application Security for Small Company Services — design, deployment, and evaluation of API/Network protection measures suitable for small organizations

---

## 1. Project Synopsis

The project guides students to design, deploy, and evaluate an **API-first system for a small company service** (e.g., small B2B SaaS, e-commerce microservice, or internal admin API), focusing on:

* API plane protection (authentication, authorization, token management).
* Network flow protection (TLS/mTLS, service-to-service auth, network segmentation).
* Cost-effective, easy-to-operate solutions for SMEs (managed services, serverless).
* Detection & response capabilities (logging, tracing, alerting, lightweight SIEM).
* Pentest & hardening practices (OWASP API Top 10, webhook security, signed requests).

Students will create a prototype (Docker/Kubernetes or serverless), configure an API Gateway + IdP, apply authz policies (RBAC/OPA), deploy rate-limiting/WAF, run automated security test suites, simulate attacks (replay, BOLA, SSRF, token leak), and write a rollout proposal report for a small company.

---

## 2. Learning Objectives

1.  Understand the API security model: authentication (OAuth2/OIDC, mTLS, API keys), authorization (RBAC/ABAC/OPA), and token lifecycle.
2.  Deploy an API Gateway, client authentication (Authorization Code + PKCE, Client Credentials), webhook signing, and request signing (JWS/HMAC).
3.  Set up network controls: VPC, subnet segmentation, security groups, egress filtering; apply mTLS for service-to-service communication.
4.  Practice intrusion detection and logging: structured logs, correlation IDs, distributed tracing, SIEM/lightweight alerting.
5.  Security assessment (automated SAST/DAST, OWASP ZAP, API fuzzing), developing incident response runbooks, and evaluating cost/operational trade-offs for SMEs.

---

## 3. Relevance

* Small companies increasingly rely on APIs (mobile apps, SPAs, 3rd-party integrators) and often lack security operational capacity. An incident (token leak, stolen API key, BOLA) can destroy their reputation and cause severe financial losses.
* Due to human resource and budget constraints, solutions must prioritize managed services, automation, ease of deployment, and operational clarity.

---

## 4. Research Questions & Hypotheses (RQ & Hypotheses)

**RQ1:** Which simple architecture (API Gateway + IdP + managed WAF + KMS) best balances security, operations, and costs for a small company?

**RQ2:** Can the most common API attack vectors for SMEs (BOLA, token theft, webhook hijack, SSRF) be effectively prevented using policies, automation, and testing?

**Hypothesis:** A standard stack consisting of an API Gateway (rate limit + WAF + JWT validation), IdP (OIDC), short-lived tokens, HSM/KMS for secrets, and automated detection (alerts + basic anomaly rules) will reduce >80% of common risks for SMEs at an acceptable operational cost.

---

## 5. Background (Brief Overview)

* **OAuth2/OIDC:** Authorization Code + PKCE for public clients, Client Credentials for backend; refresh tokens; token introspection.
* **JWT pitfalls:** long-lived tokens, alg none, kid confusion, no revocation.
* **mTLS & mutual auth:** strong option for S2S in microservices or service providers.
* **API Gateway / Edge:** terminates TLS, enforces authN/authZ, rate limits, injects tracing headers, connects to WAF.
* **WAF/Rate Limiting:** stops mass scanning, reduces brute force and credential stuffing.

---

## 6. Literature & Standards

* OWASP API Security Top 10 (BOLA, Broken Auth, Excessive Data Exposure, Rate Limiting)
* OAuth 2.0 / OIDC RFCs; best practices (token binding, PKCE, rotating refresh tokens)
* NIST guidance on secure web services, JSON Web Token (RFC 7519 / JWS 7515) guidance

> Requirement: Students must cite at least 5 canonical/official sources (OWASP, RFCs, NIST) and 3 sample stacks/tools (API Gateway, Keycloak/Okta, HashiCorp Vault).

---

## 7. System Components & Resources

### 7.1. Main Components (microservice & edge view)

* **Client (web/mobile):** SPA + mobile app; Authorization Code + PKCE; local secure storage (Keystore/Keychain).
* **API Gateway (edge):** AWS API Gateway / CloudFront, Cloudflare Workers + Access, Kong/Envoy/Egress; tasks: TLS, JWT verification, rate limiting, WAF, logging.
* **Identity Provider (IdP):** Keycloak (self-hosted) or Auth0/Okta; manages users, clients, scopes, refresh policies.
* **Backend Microservices:** Order, User, Billing, Admin APIs — all enforce authz; S2S via mTLS or short-lived client credentials.
* **Key Management / Secrets:** AWS KMS / GCP KMS / HashiCorp Vault; HSM for high-value keys if affordable.
* **Logging & Monitoring:** ELK/EFK or managed CloudWatch + Datadog or Sumo Logic; simple SIEM rules for anomalies.
* **CI/CD & Supply Chain:** GitHub Actions / GitLab + signed artifacts, dependency scanning (Snyk), secrets scanning.

### 7.2. Hardware Resources & Costs for SMEs

* Cloud managed resources: serverless functions or small k8s (k3s) nodes; managed DB (RDS/Firebase) to cut ops.
* Budget considerations: prefer managed IdP & API Gateway to avoid ops costs; a small HSM can be replaced by cloud KMS in the early stages.

---

## 8. Real-world Deployment Scenarios

### 8.1. Single-region startup (lowest ops)

* API Gateway (managed) + Lambda (serverless) or a single small k8s cluster; IdP as a managed service; KMS cloud; WAF managed. Cost optimized, low ops.

### 8.2. Small multi-tenant SaaS

* Multi-tenant data isolation patterns, per-tenant keys (envelope encryption); mTLS between services; per-tenant rate limits; OPA for per-tenant policy enforcement.

### 8.3. Hybrid on-prem + cloud integration

* On-prem internal services talk to cloud APIs via VPN; use mutual TLS and token exchange; central IdP with federated SSO.

---

## 9. Attack Surface Analysis (Risk & weaknesses by scenario)

### 9.1. Broken Object Level Authorization (BOLA)

* **Description:** Attacker manipulates object id in API path/param to access others' resources.
* **Cause:** Lack of server-side ACL checks; relying on client-side filtering.
* **Mitigation:** Enforce per-request server-side authz, use stable opaque IDs, and tests (BOLA fuzzing).

### 9.2. Broken Authentication / Token theft

* **Description:** Long-lived access/refresh tokens stolen (XSS, insecure storage), or leaked API keys.
* **Mitigation:** Short-lived tokens, PKCE, rotate refresh tokens, refresh token rotation & binding, httpOnly secure cookies for web, token revocation list & introspection, device binding.

### 9.3. Excessive Data Exposure

* **Description:** APIs return more fields than necessary.
* **Mitigation:** Schema-driven responses (OpenAPI), fields filtering server-side, use DTOs, automated contract tests.

### 9.4. Rate limiting & abuse

* **Description:** Brute force, account enumeration, scraping, credential stuffing.
* **Mitigation:** Per-IP and per-user rate limits, CAPTCHA, progressive backoff, global and per-tenant quotas.

### 9.5. Webhooks & Third-party callbacks

* **Description:** Webhook endpoints used by 3rd party; attacker forges callbacks.
* **Mitigation:** Signed webhooks (HMAC with shared secret), replay nonce + timestamp, IP allowlist, strict validation.

### 9.6. SSRF / Open Redirect / Injection

* **Description:** SSRF via URL fetch endpoints, metadata service access in the cloud.
* **Mitigation:** Block outbound to metadata/169.254.169.254, strict URL validation, allowlist hosts, network egress control.

### 9.7. Supply chain & CI/CD risks

* **Description:** Secrets in repos, compromised dependencies, malicious third-party libs.
* **Mitigation:** Secrets scanning, SCA tools, artifact signing, minimal third-party use, SBOM.

---

## 10. Methodology (Pipeline & PoC Experiments)

Students should implement a reproducible set of experiments. Suggested pipeline:

1.  **Stack setup:** API Gateway (Kong/Envoy) or AWS API Gateway + Lambda / small k8s cluster; IdP (Keycloak or Auth0 free tier); HashiCorp Vault or AWS KMS.
2.  **Implement APIs:** User, Resource (CRUD), Admin endpoints with server-side authN/authZ; use OpenAPI schema.
3.  **Harden edge:** Configure WAF rules, rate limits, CORS safe config, TLS 1.2+/1.3, HSTS.
4.  **S2S security:** Implement mTLS or short-lived client credentials via IdP; use mutual TLS for internal services or JWT with short lifetime.
5.  **Logging & detection:** Structured logs (JSON), correlation IDs, export to ELK or cloud logs; add simple anomaly rules (spike in failed auths, new IPs, sudden rate).
6.  **Automated testing:** Run SAST (Bandit/Brakeman/ESLint), DAST (OWASP ZAP), API fuzzing (fuzzapi, restler), and BOLA test suites.
7.  **Attack emulation:** Simulate BOLA, token replay, SSRF, webhook forgery, and observe detection & mitigation.

---

## 11. Implementation & Tools (Cost-saving suggestions)

* **API Gateway / Edge:** Kong (open source), Envoy, AWS API Gateway (managed), Cloudflare Workers & Access.
* **IdP:** Keycloak (self-hosted), Auth0/Okta (managed).
* **Secrets & KMS:** HashiCorp Vault (dev/OSS) or AWS KMS/Secrets Manager.
* **WAF:** Cloudflare WAF (managed), AWS WAF, ModSecurity.
* **Auth libs:** oidc-client, oauth2-sdk, jose/jwt libs (use well-maintained libs).
* **Testing:** OWASP ZAP, Postman/Newman, restler, fuzzapi, Burp for manual pentest.
* **Logging / SIEM:** ELK stack, Grafana Loki, or managed CloudWatch + GuardDuty.
* **Policy engine:** OPA (Open Policy Agent) for authorization decisions.

---

## 12. Evaluation Plan & Metrics

* **Security:** Number of detected/blocked attack attempts in the lab, % of OWASP API Top 10 tests mitigated.
* **Performance & cost:** Added latency at edge (median/p95) from Gateway/WAF, KMS call overhead, monthly cost estimate for managed services.
* **Operational:** Mean time to detect (MTTD) for simulated compromises, mean time to remediate (MTTR), frequency of false positives in alert rules.

---

## 13. Timeline & Milestones (12 weeks)

* **Weeks 1–2:** Requirement & threat model, choose stack (cloud vs self-hosted), provision infra.
* **Weeks 3–4:** Implement core APIs, IdP integration (Auth code + PKCE), OpenAPI schema.
* **Weeks 5–6:** Configure API Gateway & WAF, implement rate limits, webhook signing, and mTLS for S2S.
* **Week 7:** Implement logging/tracing & simple detection rules.
* **Week 8:** Setup CI/CD with SAST and dependency scanning; add artifact signing.
* **Week 9:** Run DAST + fuzzing and fix findings.
* **Week 10:** Attack simulation (BOLA, token theft, SSRF, webhook forgery) and measure defenses.
* **Week 11:** Run resilience drills: key rotation, token revocation, incident response.
* **Week 12:** Finalize report, reproducible repo (Terraform/Helm/Docker), slides & demo video.

---

## 14. Deliverables

1.  **Mid-term:** Architecture diagram, threat model, skeleton repo.
2.  **Final report & repo:** Reproducible infra (IaC), API code, test scripts, DAST/ZAP reports, logs, and remediation notes.
3.  **Demo:** Recorded live demo of secure flows and attack emulation.
4.  **Runbooks:** Incident response, key rotation, onboarding new client (BFF) patterns.

---

## 15. Assessment & Rubric (Suggestions)

* Architecture & threat modeling: 20%
* Implementation & reproducibility (IaC, automation): 30%
* Security testing & remediation (DAST, fuzzing, pentest): 30%
* Documentation, runbooks & presentation: 20%

---

## 16. Risks, Limitations & Ethical Considerations

* **Pen-testing ethics:** Only test lab infra and consented targets; do not run scans against third-party services.
* **Managed services cost:** Document cost estimates; don't use production secrets in demos.
* **Privacy:** Use synthetic data for tests; sanitize logs before sharing.

---

## 17. Mitigations & Best Practices (Summary recommendations)

* **Use strong authN/AuthZ:** OAuth2 + OIDC (PKCE), short-lived access tokens, refresh token rotation, OPA for fine-grained policies.
* **Harden edge:** TLS 1.3, strict CORS, WAF, rate limiting, signed webhooks, HMAC validation.
* **Service-to-service security:** mTLS or short-lived client credentials + certificate rotation.
* **Secrets & keys:** Centralize in KMS/Vault, enforce least privilege, automate rotation.
* **Observability:** Structured logging, distributed tracing, anomaly alerts, periodic security scans.
* **CI/CD & supply chain:** SAST, SCA, artifact signing, SBOM, minimal runtime dependencies.

---

## 18. Extensions & Future Work

* Add ML-based anomaly detection for API abuse; integrate with SOAR for automated response.
* Evaluate PoP tokens (DPoP/mTLS bound tokens) and token binding to reduce replay.
* Integrate with WAF rule tuning based on ML and real traffic.

---

## 19. Suggested Tools & Resources

* Keycloak, Auth0, Okta, Kong/Envoy, AWS API Gateway, Cloudflare Access, HashiCorp Vault, OPA, OWASP ZAP, Burp Suite, restler/fuzzapi, ELK/CloudWatch/Grafana.

---

## 20. Appendix: Repository Structure (Template)

```text
project-root/
  ├─ infra/              # Terraform / Helm charts for API Gateway, IdP, k8s
  ├─ services/           # user/, resource/, admin/ microservices
  ├─ gateway/            # Kong/Envoy configs, WAF rules
  ├─ idp/                # Keycloak realm exports, client configs
  ├─ tests/              # zap/, restler/, fuzzapi scripts, unit tests
  ├─ ci/                 # SAST, SCA, artifact signing workflows
  ├─ docs/               # runbooks, threat model, final report
  └─ demo/               # scripts to replay demo scenarios + dataset (synthetic)