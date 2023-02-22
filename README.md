# Deploying Azure DevOps Agents on Azure Container Apps

## Introduction

This project provides an starter solution to modernize your AzDevOps pipeline infrastructure by migrating from IaaS to PaaS using Azure Container Apps.
Optimizing costs by eliminating user managed VMs. Additionally, it uses Kubernetes Event Driven Autoscaling (KEDA) to auto-scale based on the jobs queue length.

The Container Apps will be deployed in a Container Apps Environment injected into a vNet, which sets the foundation to stablish private connectivity with workloads in the same vNet or a peered vNets. The Container Apps Environment sends logs and metrics to an Azure Log Analytics Workspace.

![image](https://user-images.githubusercontent.com/12474226/217368742-af15b4bd-1d73-403a-9fb6-94dec0db3f4b.png)

*Azure Key Vault and Azure Container Registry are not included in this deployment.*

This project uses Azure DevOps pipelines and Bicep to deploy the deploy Azure resources. Before deploying, create an Azure DevOps Agent pool and an Azure DevOps library with required variables that will be used during the agent configuration. These 2 steps are executed manually following the instructions under the `Configuration` section.

## Prerequisites

- An Azure account
- An Azure DevOps project and Service Connection to your Azure account

## Configuration

1. Create an Azure DevOps Agent Pool:
   - Log in to your Azure DevOps account and go to your project
   - Go to your project settings
   - Go to the "Agent Pools" section in the left-side menu
   - Click on the "Add Pool" button
   - Select "new", type as "Self-hosted" and give the agent pool a name, for example, "azure-container-apps-pool".
   - Click on "Create"
   - Open the Pool and get the PoolId from the URL, you will need it next.

2. Create an Azure DevOps Library:
   - Log in to your Azure DevOps account and go to your project
   - Go to the "Library" section in the left-side menu
   - Click on the "+ Variable Group" button
   - Give the library a name, for example, "azdevops-agent-aca"
   - Fill in the following variables:
     - `azpToken` (pat token - make sure you make this variable a secret)
     - `azpUrl` (url to your az devops project)
     - `azpPool` (pool name given when creating the az devops agent pool)
     - `azpPoolId` (pool id extracted earlier)

3. Set pipeline variables:
    - Fork this repo
    - Edit the file `pipelines\azdevops-agent.yml` and set the right values for:
     - `group` (must match the new library name)
     - `azureServiceConnection`
     - `resourceGroupName`
     - `location`

## Agent Deployment

To deploy the Azure DevOps agents on Azure Container Apps, create a pipeline based on the `.yml` file in this Github repository.

Here are the instructions to create a pipeline:

1. Go to your Azure DevOps organization's Pipelines.
2. Click on New pipeline.
3. Select the source control that contains the `pipelines\azdevops-agent.yml`.
4. Follow the steps to authorize Azure DevOps to access your Github repository.
5. Select the repository that contains the `.yml` file.
6. Select the `pipelines\azdevops-agent.yml` file.
7. Run the pipeline. The first time you might need to authorize the pipeline to use the Azure Service Connection and the Library.

Wait until the pipeline finishes and that's it! You have now set an Azure DevOps agent pool with auto-scaling agents running on Azure Container Apps.

## (Optional) Sample Pipeline Deployment

Follow the steps below to create a dummy pipeline based on the file `pipelines\sample-pipeline.yml`
This creates a starter pipeline that simply echo messages. You can use it to queue as many jobs you like and Kubernetes Events Driven Auto-scaling in action.

1. Go to your Azure DevOps organization's Pipelines.
2. Click on New pipeline.
3. Select the source control that contains the `pipelines\sample-pipeline.yml`.
4. Follow the steps to authorize Azure DevOps to access your Github repository.
5. Select the repository that contains the `.yml` file.
6. Select the `pipelines\sample-pipeline.yml` file.
7. Run the pipeline. The first time you might need to authorize the pipeline to use the Azure Service Connection and the Library.

You can use the Azure CLI DevOps extension to queue multiple jobs easily, the statement below assumes that your dummy pipeline id is `1`.
If you need help getting the Azure CLI DevOps extention, check out the references section.

```bash
1..10 | % { az pipelines run --id 1 }
```

Parallel jobs restrictions might apply when attempting to run jobs at the same time. Check rhe references section to learn how to configure parallel jobs.

## Outcome

If the pipeline ran successfully, you should see these resources deployed on the Azure resource group provided:

![image](https://user-images.githubusercontent.com/12474226/216915593-39044b3b-aeb0-454d-a86e-0584e142bce9.png)

Check the Azure DevOps agent pool UI to see how agents are provisioned and destroyed by Kubernetes based on the jobs queue length:

![image](https://user-images.githubusercontent.com/12474226/216915815-7f0df19c-7cc8-4fb0-869f-892b9ea0b2f3.png)

## Docker Container

I created my own Docker Container to bootstrap the agent based on Microsoft doc: [Running self-hosted agents in Docker](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops).

You might want to add extra layers to the container image to bake in the tools that you need.

Additionally, you should push into a private container registry.

## Limitations

- Azure Container Apps currently supports only Linux containers.
- Azure Container Apps Environments require a dedicated subnet with a CIDR range /23 or larger. Support for smaller subnets (/27) will be available on Public Preview on early April 2023.

## References

- [KEDA Azure Pipelines Scaler](https://keda.sh/docs/2.8/scalers/azure-pipelines/#authentication-parameters)
- [Running self-hosted agents in Docker](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)
- [Azure DevOps CLI](https://learn.microsoft.com/en-us/azure/devops/cli/?view=azure-devops)
- [Azure DevOps Parallel jobs](https://learn.microsoft.com/en-us/azure/devops/pipelines/licensing/concurrent-jobs?view=azure-devops&tabs=ms-hosted)
- [Azure Container Apps Roadmap](https://github.com/orgs/microsoft/projects/540)

## Contributions

Contributions are welcome! If you have any suggestions or bug reports, please open an issue or submit a pull request.
