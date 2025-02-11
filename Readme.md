# **Terraform AWS Demo with Terragrunt**

## **📌 Overview**
This repository manages the infrastructure for an **Amazon EKS cluster** using **Terraform** and **Terragrunt**.  
It follows **Infrastructure as Code (IaC)** principles

---

## **🚀 Setup Steps**
### **1️⃣ Prerequisites**
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)

---

### **2️⃣ Bootstrap the Infrastructure**
1. **Clone the repository:**
   ```sh
   git clone https://github.com/luzerz/terraform-eks.git
   ```

2. **Initialize Terragrunt:**
   ```sh
   cd terraform-eks-demo/environments/dev
   terragrunt run-all init
   ```

3. **Deploy the VPC:**
   ```sh
   cd ../vpc
   terragrunt apply
   ```

4. **Deploy the EKS Cluster:**
    ```sh
    cd ../eks
    terragrunt apply
    ```


5. **Configure `kubectl` for the EKS cluster:**
   ```sh
   aws eks update-kubeconfig --region ap-southeast-1 --name dev-cluster
   ```

6. **Verify cluster connectivity:**
   ```sh
   kubectl get nodes
   ```
7. **Deploy RDS:**
    ```sh
    cd ../rds
    terragrunt apply
    ```

8. **Deploy S3:**
    ```sh
    cd ../s3
    terragrunt apply
    ```
---

## **1️⃣ Initial ArgoCD Setup**
ArgoCD is deployed **via Helm** within the EKS cluster.

1. **Verify ArgoCD is running:**
   ```sh
   kubectl get pods -n argocd
   ```

2. **Get the initial admin password:**
   ```sh
   kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   ```

3. **Access ArgoCD UI:**
   ```sh
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   Open a browser and go to [https://localhost:8080](https://localhost:8080).

4. **Login to ArgoCD:**
   ```sh
   argocd login localhost:8080 --username admin --password <password>
   ```


---

## **📌 Summary**
| **Component** | **Description** |
|--------------|---------------|
| **Terraform + Terragrunt** | Infrastructure as Code (IaC) for EKS, IAM, and networking |
| **EKS Cluster** | Deploys a scalable Kubernetes cluster on AWS |
| **ArgoCD** | Manages GitOps-driven application deployments |


🚀 **Now you have a fully automated AWS EKS infrastructure!** 🎯

