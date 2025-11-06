# team5
# project 3 
This is a containerized Python-based web application developed as part of a cloud infrastructure training project. The application demonstrates core DevOps principles by integrating AWS deployment, Docker containerization, and Jenkins-based CI/CD automation.

The application is designed to run inside a Docker container, with infrastructure configured for deployment on Amazon Web Services (AWS).

✅ Key Features:

Built with Python

Deployed on AWS EC2 instance inside a Virtual Private Cloud (VPC)

Containerized using Docker

Automated deployment pipeline configured with Jenkins

Dependency management via requirements.txt

Infrastructure and deployment automation using manifest.yaml and dockerfile

🛠 Tech Stack

Category--Tools/Tech
Language--Python
Infrastructure--AWS EC2, VPC
Container--Docker
CI/CD--Jenkins
Deployment--Bash, YAML, Dockerfile, manifest
Version Control--GitHub

🚀 Deployment Overview

Source code is committed to GitHub.

Jenkins monitors the repository and triggers a build pipeline.

The app is packaged into a Docker image using the provided dockerfile.

The image is deployed to an EC2 instance running inside an AWS VPC.

Resources and configurations are defined through manifest.yaml.

📌 Notes

This project serves as a practical demonstration of how to integrate infrastructure-as-code, container orchestration, and cloud deployment for a simple web application. While minimal in scope, it provides a strong foundation for scaling into more complex cloud-native solutions.
