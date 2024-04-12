# Aleksander Dushku

## Backstage Integration with Dockerized Application Deployment

Here is the process of creating a CI/CD pipeline using Backstage to deploy a Dockerized application. It covers:

* Dockerizing an application
* Setting up Backstage locally
* Integrating the application with Backstage
* Implementing a CI/CD pipeline triggered through Backstage
* Deploying the container locally

**Project Setup**

### 1. Dockerizing an Application

* Creating a simple application (e.g., "Hello World") and containerizing it using Docker.
* Using Flask (python) and utilizing Dockerfile to package the app and deploy it as a container.
* I have created the following files for the app:
  * app.py (contains the code to create for the hello world app)
  * requirements.txt ( contains the code to install libraries that are needed for the app, in this case Flask.)
  * Dockerfile (contains the code to package the app and generate a docker image)
  * The setup:
    * I have create a repo in my org in github called scania_devops where I have stored the files as follow:
      * app.py
      * Dockerfile
      * requirements.txt
      * .github/workflows/build-and-deploy.yaml

### 2. Setting Up Backstage Locally

* Install and configure Backstage locally  following the official guide: https://backstage.io/docs/getting-started/
* Since I was introduced to backstage recently, I went with the setup to install a standalone server for this purpose. Otherwise a dockerised application 
* that can be deployed in k8s or ECS might be better option for running backstage in production.
* Setting it up using the below commands:

  ```shell
      -  npx @backstage/create-app@latest
      -  cd demo-portal
      -  yarn dev
  ```

**Integrating Docker with Backstage**

### 3. Backstage Component Creation

* Integrate your Dockerized application with Backstage.
* I have decided to leave this up to the pipeline to do the building of the image from dockerfile and deploy it locally, this is done to speed up the process from creation to deployment.
* The setup is local for backstage, so to connect with the repository and files I have synced with Github.
  * Setting up a Github token with permissions to create (read/write) repository and also permissions to run workflows
  * Now we have backstage connected with Github repository using Github token.
  * I have created a new template.yaml located under folder templates to that will be used
  * to create new components in backstage and deploy them locally.
  * Also you can find the changes also done to the content folder on files under,  that are 
  * customized to our needs.

* Issues: 
  * By default in the new updates we need to configure github manually by adding a line of
  * code to configure github. You can find the change in the index.ts file in the backend
  * folder, line number 17.
  * Next, you need to run the following command in order to enable the integration in
  * backstage:
    * "yarn --cwd packages/backend add @backstage/plugin-scaffolder-backend-module-github"
 

**CI/CD Pipeline with Backstage Trigger**


### 4. Triggering Mechanisms in Backstage

* To Trigger this in backstage, you need to do the following:
  * After running backstage, we can go to the localhost:3000, where the app is exposed.
    1. Go to Create:
    2. Select template "docker app template".
    3. Fill in the app Name, and click Next.
    4. By default we have configured the host, which is github.com
    5. Add the Owner, that project or this user belongs, I have my user "AleksanderDushku"
    6. Add the name of repository that you want to create,suggestion to keep the same as the app name, and Click Review.
    7. You will be seeing now the name of the app and the Repo Url:
       - github.com?owner=AleksanderDushku&repo=testing
    8. Click Create and you will be seeing the process continue based on the template:
      -  Fetch base.
      - Publish the repo together with the content.
      - Trigger CI / CD to build the image and deploy the container.
      - Registering the component to the catalog. 
    9. View the repository by clicking on repository link.
    10. View the app in the catalog by clicking open in catalog.



### 5. CI/CD Script Functionality

* The triggered CI/CD script will:
    * Build the Docker image.
    * Deploy the container locally (details on port exposure provided in the code).
    * Everything is done in github workflow using github actions:
    * In the configuration we have automated the setup so the workflow works in this way:
    * It takes as an input the component name that we define in the backstate, this is 
    * configured in the template.yaml, and it will continue with the next steps if the name * is given.
    * Next, it will build the image utilizing the dockerfile. I have choosed this setup
    * to increase the speed of delivery and to not overcomplicate it, of course in a prod
    * setup this flows need to be separate.
    

**Deployment**

### 7. Local Deployment

* The script runs the container locally, allowing you to access the deployed application.

### 8. AWS Deployment Considerations

* This document explores potential replacements for Docker functionalities using AWS services.
* Services like AWS CodeBuild, ECR, and ECS can be used for building, pushing, and deploying container images on AWS, integrated with backstage.

**Deliverables**

* Dockerized application source code and Dockerfile.
* Locally running Backstage instance with your application integrated.
* Backstage mechanisms for building and deploying the application (triggered by user interaction).
* Startup script for running the entire solution.
* Documentation on triggering Backstage mechanisms and your development process.
* Documentation on potential AWS service replacements for Docker functionalities.

**Conclusion**

This document provides a basic framework for deploying a Dockerized application through Backstage. We can extend this approach by integrating more sophisticated CI/CD tools, adding unit testing, and exploring advanced deployment strategies.

**Additional Considerations**


The script performs the following tasks:

1. Navigates to the Backstage project directory.
2. Exports the Github token (**never store it in plain text!**).
3. Runs `yarn dev` to spin up Backstage.
4. Includes basic error handling for directory changes and `yarn dev` execution.

* **Environment Variables:** Store the token in a system-managed environment variable and access it within the script using `$GITHUB_TOKEN`.
* **Secure Credential Stores:** Utilize tools like AWS Secrets Manager or HashiCorp Vault to securely store and retrieve the token.

**Replacing Docker with AWS Services**

While the script doesn't directly interact with Docker, the provided `README.md` outlines deploying a Dockerized application with Backstage. Here's how some Docker functionalities can be replaced with AWS services:

* **Building Docker Images:** Replace local Docker builds with **AWS CodeBuild**. CodeBuild is a managed service for building, testing, and packaging code. It integrates seamlessly with other AWS services.

* **Container Registry:** Store and manage Docker images securely using 
* **Amazon Elastic Container Registry (ECR)**. Push images to ECR after building them with CodeBuild.

* **Container Orchestration:** For production environments, we consider deploying containers using 
* **Amazon Elastic Container Service (ECS)**. ECS is a scalable container orchestration service that simplifies managing containerized applications.
