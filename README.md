# Multi-Cloud Project

This project demonstrates a DevOps solution for provisioning and managing infrastructure across multiple cloud providers using **Terraform**. It includes CI/CD workflows for automating infrastructure deployment and configuration.

Additionally, this project was used for a sample **MERN (MongoDB, Express.js, React, Node.js)** application, which you can use as a starting point for your own projects.

---

## Project Structure

- **workflows/**  
  Contains CI/CD workflows for automating the deployment process.

- **.gitignore**  
  Specifies intentionally untracked files to ignore.

- **Dockerfile**  
  Defines the Docker image for containerizing the application.

- **main.tf**  
  The main Terraform configuration file for defining resources.

- **outputs.tf**  
  Specifies output variables for the Terraform configuration.

- **providers.tf**  
  Configures the cloud providers (e.g., AWS, Azure, GCP).

- **terraform.tfstate**  
  Tracks the state of your Terraform-managed infrastructure.

- **terraform.tfvars**  
  Contains variable definitions for the Terraform configuration.

- **variables.tf**  
  Declares input variables for the Terraform configuration.

---

## Prerequisites

Ensure the following tools are installed on your local machine:

- [Terraform](https://www.terraform.io/) (v1.x or later)
- [Docker](https://www.docker.com/)
- [Git](https://git-scm.com/)
- [A Cloud Provider Account](https://aws.amazon.com/free/) (e.g., AWS, Azure, GCP)

---
## Sample MERN Application
This project was used for a sample MERN (MongoDB, Express.js, React, Node.js) application. You can integrate your own MERN app by following these steps:

Update the Dockerfile to include your MERN app's dependencies and start command.
Deploy the MERN app by applying the Terraform configuration.
Use the CI/CD workflows in the workflows/ folder to automate deployment.

## Usage Instructions

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/MTalha641/multi-cloud-project.git
cd multi-cloud-project

