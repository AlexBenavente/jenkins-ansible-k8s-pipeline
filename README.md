# Jenkins CI/CD Pipeline

<img src="https://github.com/AlexBenavente/Images/blob/main/jenkins-logo.png" align="right"
     alt="jenkins logo" width="157" height="256">

<!-- TABLE OF CONTENTS -->
## Table of Contents
  <ul>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#workflow">Workflow</a>
      <ul>
        <li><a href="#AWS-Terraform">AWS Terraform IaC</a></li>
        <li><a href="#jenkins-project">Jenkins Project</a></li>
        <li><a href="#apache-maven">Apache Maven</a></li>
        <li><a href="#ansible-docker-kubernetes">Ansible Docker Kubernetes</a></li>
      </ul>
  </ul>




<!-- ABOUT THE PROJECT -->
## About The Project

The goal of this project is to develop DevOps skills by building a CI/CD pipeline using Jenkins. This project will also employ several other DevOps tools including AWS, Docker, Kubernetes, Terraform, Ansible and Apache Maven. CI/CD pipelines add automation to different stages of app development. Jenkins is a CI/CD tool that automates builds, deployments and configurations.


### Built With

* ![Terraform]
* ![Jenkins]
* ![ApacheMaven]
* ![Ansible]
* ![Docker]
* ![Kubernetes]



<!-- GETTING STARTED -->
## Workflow

For my automated CI/CD workflow, I am using a Jenkins pipeline to build a Java Spring Boot web application into a JAR artifact package with Maven. The Jenkins CI/CD pipeline then uses Ansible to build a Docker container image from the build artifact and upload it to my DockerHub image repository. The pipeline then uses Ansible to pull the container image and deploy it to my Kubernetes cluster running in AWS.

![Jenkins Pipeline](https://github.com/AlexBenavente/Images/blob/main/jenkins-pipeline.png)

### Terraform AWS

First I created the cloud infrastructure in AWS using Terraform as Infrastructure as Code:

![AWS Jenkins](https://github.com/AlexBenavente/Images/blob/main/aws-jenkins.png)

I created 3 EC2 instances and a VPC network via Terraform. One instance to run the Jenkins CI/CD pipeline, one to run Ansible and a third instance for Kubernetes. I included a script in the User Data for the EC2 deployments to install and start Jenkins, Docker and Ansible.


### Jenkins Project

I use a Jenkins project to create a CI/CD pipeline. The Jenkins pipeline uses the Apache Maven plugin to build the project code into a JAR artifact. The Jenkins pipeline then sends the JAR build artifact to the Ansible server via SSH.

![Jenkins Project](https://github.com/AlexBenavente/Images/blob/main/jenkins-project.png)

### Apache Maven

Apache Maven is a widely used build automation and project management tool in software development. It streamlines the process of compiling, testing, and packaging code by managing project dependencies and providing a consistent build lifecycle. Maven employs XML-based configuration files (POM files) to define project structure, dependencies, and tasks, enabling developers to efficiently manage and deploy complex software projects.

![Jenkins Maven](https://github.com/AlexBenavente/Images/blob/main/jenkins-maven.png)


### Ansible Docker Kubernetes

On the Ansible EC2 server, I configure Ansible and connect to my DockerHub image repository.

In my Jenkins project configuration, I reference a Java Spring Boot web application source repository in my GitHub.

The Jenkins CI/CD pipeline uses Apache Maven to build my application code into a JAR artifact and send it to the ansible server. Once the build artifact is on the Ansible server, the pipeline runs an Ansible playbook that builds a Docker container image from the JAR artifact and uploads the container image to my Dockerhub container repository.

![Jenkins Ansible Files](https://github.com/AlexBenavente/Images/blob/main/jenkins-ansible-files.png)
![Jenkins DockerHub](https://github.com/AlexBenavente/Images/blob/main/jenkins-dockerhub.png)

Then another Ansible playbook runs a Kubernetes deployment to update my Kubernetes cluster with the new container image.

Then when we open the web browser to our exposed Kubernetes service load balancer, we can see that the cluster is now running the current version of our application.

![Jenkins v1](https://github.com/AlexBenavente/Images/blob/main/jenkins-v1.png)

Then if we update our application code and run the Jenkins CI/CD build pipeline again, when we reload the web browser, we can see that the web application was updated and is now running the new version on the Kubernetes cluster, thanks to the Jenkins CI/CD pipeline.

![Jenkins b2](https://github.com/AlexBenavente/Images/blob/main/jenkins-build2.png)
![Jenkins v2](https://github.com/AlexBenavente/Images/blob/main/jenkins-v2.png)

<!-- MARKDOWN LINKS & IMAGES -->
[Terraform]: https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white
[Jenkins]: https://img.shields.io/badge/jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white
[ApacheMaven]: https://img.shields.io/badge/Apache%20Maven-C71A36?style=for-the-badge&logo=Apache%20Maven&logoColor=white
[Ansible]: https://img.shields.io/badge/ansible-%231A1918.svg?style=for-the-badge&logo=ansible&logoColor=white
[Docker]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[Kubernetes]: https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=Kubernetes&logoColor=white


