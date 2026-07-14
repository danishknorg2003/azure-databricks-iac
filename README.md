# Azure Databricks Infrastructure as Code (Terraform + Azure DevOps)

Production-ready, modular Terraform project that deploys an Azure Databricks Premium
workspace (VNet-injected, No Public IP / Secure Cluster Connectivity, Unity Catalog
enabled) and configures Unity Catalog objects, driven by an Azure DevOps pipeline with
Init → Validate → Fmt → Plan → Manual Approval → Apply → (optional) Destroy stages.

---

## 1. Pre-requisites

Everything below must exist **before** the pipeline is run for the first time.

### 1.1 Azure subscription & identity
- An **Azure Subscription** with `Owner` or `Contributor + User Access Administrator`
  rights for whoever bootstraps the project (needed to create RBAC role assignments).
- **Resource Providers registered** on the subscription:
  `Microsoft.Databricks`, `Microsoft.Storage`, `Microsoft.Network`,
  `Microsoft.ManagedIdentity`, `Microsoft.EventGrid`, `Microsoft.Insights`.
  ```bash
  az provider register --namespace Microsoft.Databricks
  az provider register --namespace Microsoft.Storage
  az provider register --namespace Microsoft.Network
  az provider register --namespace Microsoft.ManagedIdentity
  az provider register --namespace Microsoft.EventGrid
  az provider register --namespace Microsoft.Insights
  ```

### 1.2 Terraform remote backend (must exist before `terraform init`)
Terraform's own state can't create the storage it lives in, so provision this manually
or with a one-time bootstrap script (**outside** this project):
- One **Storage Account** (per environment or shared, your choice) with a
  **Blob Container** for state (e.g. `tfstate`).
- Azure AD-based access (`use_azuread_auth = true` is set in `backend.tf`) — grant the
  pipeline's identity **Storage Blob Data Contributor** on that storage account.

### 1.3 Azure DevOps
- An **Azure DevOps Project** with **Azure Repos** (or GitHub) containing this codebase.
- An **Azure Service Connection** (ARM), ideally using **Workload Identity Federation /
  OIDC** (no stored client secret) — referenced in the pipeline as `serviceConnectionName`.
- **Azure DevOps Environments** named `databricks-dev`, `databricks-test`,
  `databricks-prod` (and `databricks-<env>-destroy` if you want a separate destroy gate),
  each with **Approvals and checks** configured for the manual-approval stage.
- **Variable Groups** named `tf-databricks-dev`, `tf-databricks-test`,
  `tf-databricks-prod`, each containing:
  | Variable | Description |
  |---|---|
  | `serviceConnectionName` | Name of the Azure DevOps service connection |
  | `ARM_SUBSCRIPTION_ID` | Target subscription ID |
  | `backendResourceGroup` | RG holding the state storage account |
  | `backendStorageAccount` | State storage account name |
  | `backendContainerName` | State container name (e.g. `tfstate`) |
- A **self-hosted or Microsoft-hosted pipeline agent** capable of outbound HTTPS to
  Azure management/Databricks endpoints (Microsoft-hosted `ubuntu-latest` works for most
  networks; use a self-hosted agent inside the VNet if the workspace/backend are
  network-restricted).

### 1.4 Tooling
- **Azure CLI** ≥ 2.60 (for local testing / bootstrap).
- **Terraform** ≥ 1.7.0 (the pipeline installs this automatically via `TerraformInstaller@1`).
- **Git** access to the repository.

### 1.5 Databricks
- A **Databricks Account** (account console access) if you plan to manage account-level
  Unity Catalog metastore assignment outside this project (this project assumes a
  metastore already exists at the account level, or that catalogs can be created
  directly against the workspace — adjust `unity-catalog` module if you need to also
  create the metastore itself via `databricks_metastore` / `databricks_metastore_assignment`).
- **Required RBAC roles** for the identity running Terraform:
  - `Contributor` on the target Resource Group (create workspace, network, storage).
  - `User Access Administrator` (or `Owner`) scoped to the storage account, to create
    the four role assignments for the Access Connector's managed identity.
- No Databricks PAT tokens or service-principal client secrets are required — the
  `databricks` provider authenticates via Azure AD using the pipeline's Managed
  Identity/OIDC service connection, and Unity Catalog storage access uses the Access
  Connector's **system-assigned managed identity**.

### 1.6 Networking
- Confirm the chosen VNet address space (`environments/<env>/<env>.tfvars`) does not
  overlap with any existing hub/spoke VNets you will peer with.

---

## 2. Project structure

```
terraform/
  backend.tf            # Remote state backend (partial config, filled by pipeline)
  providers.tf           # azurerm + databricks provider configuration
  versions.tf             # Terraform & provider version pins
  variables.tf             # Root input variables
  outputs.tf                # Root outputs
  main.tf                    # Module wiring
  terraform.tfvars.example    # Example variable values
  modules/
    resource-group/
    network/
    storage/
    access-connector/
    role-assignment/
    databricks/
    unity-catalog/
environments/
  dev/dev.tfvars
  test/test.tfvars
  prod/prod.tfvars
azure-pipelines/
  azure-pipelines.yml
README.md
```

## 3. Pipeline stages

1. **Init** – configures the remote backend and initializes providers.
2. **Validate** – `terraform validate` (backend-less init for speed).
3. **Format Check** – `terraform fmt -check -diff`, fails the build on drift.
4. **Plan** – produces and publishes a plan artifact (`tfplan`).
5. **Manual Approval** – gated by an Azure DevOps Environment's approvals.
6. **Apply** – applies the exact plan artifact from stage 4 (no re-planning).
7. **Destroy (optional)** – only runs when the `runDestroy` pipeline parameter is `true`,
   behind its own approval gate.

Run the pipeline with the `environment` parameter set to `dev`, `test`, or `prod`.

## 4. First-time run checklist

1. Complete every item in **Section 1**.
2. Fill in the Variable Group values for the target environment.
3. Review/adjust `environments/<env>/<env>.tfvars`.
4. Queue the pipeline with `environment = dev`, `runDestroy = false`.
5. Review the **Plan** stage output, then approve in the **Manual Approval** stage.
6. Verify workspace, storage, Unity Catalog objects after **Apply**.

## 5. Notes on secure design choices

- **No secrets committed**: authentication end-to-end uses Azure AD / OIDC / Managed
  Identity — the service connection, the Access Connector's system-assigned identity,
  and Azure AD-based backend auth.
- **No Public IP** is enabled on the workspace, so cluster nodes have no public IPs;
  all traffic flows through the injected VNet.
- **State locking** is handled natively by the `azurerm` backend (blob lease).
- **Immutable custom_parameters**: the Databricks module ignores changes to
  `custom_parameters` post-creation since Azure does not support modifying VNet
  injection settings in place.
