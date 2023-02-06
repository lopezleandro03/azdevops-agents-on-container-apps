# Deploying Azure DevOps Agents on Azure Container Apps

[[_TOC_]]

## Introduction

This project provides a solution to modernize your pipeline infrastructure by migrating from IaaS pipelines infrastructure to PaaS. By using Azure Container Apps, you can optimize cloud costs by reducing the need for VMs. Additionally, you can leverage Kubernetes Event Driven Autoscaling (KEDA) to deploy more container apps based on the jobs queue length, allowing you to do more with less.

## Prerequisites

- An Azure account
- An Azure DevOps account with a Service Connection to your Azure account

## Configuration

1. Create an Azure DevOps Agent Pool:
   - Log in to your Azure DevOps account
   - Go to the "Agent Pools" section in the left-side menu
   - Click on the "+ New Agent Pool" button
   - Give the agent pool a name, for example, "azure-container-apps-pool"

2. Create an Azure DevOps Library:
   - Log in to your Azure DevOps account
   - Go to the "Libraries" section in the left-side menu
   - Click on the "+ New definition" button
   - Select "Azure DevOps Agent (Preview)"
   - Give the library a name, for example, "azdevops-agent-aca"
   - Fill in the following variables:
     - `azpToken`
     - `azpUrl`
     - `azpPool`
     - `azpPoolId`

## Instructions

To get started, follow these instructions to configure an Azure DevOps pipeline based on the `.yaml` in the repo:

1. Clone this repository to your local machine
2. Navigate to the cloned repo
3. Create the Azure DevOps library with the required variables
4. Add the `.yaml` file to your Azure DevOps pipeline
5. Run the pipeline

That's it! Your Azure DevOps agents are now deployed on Azure Container Apps.

## Contributions

Contributions are welcome! If you have any suggestions or bug reports, please open an issue or submit a pull request.
