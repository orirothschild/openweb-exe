# OpenWeb Home Task

This project involves deploying a ToDo list application provided by the OpenWeb team. The goal is to containerize the application, set up a CI/CD pipeline, and deploy it on Kubernetes with a durable MySQL database.

## Project Overview

The project consists of the following components:

1. **Dockerfile**: Containerizes the application.
2. **CircleCI Configuration**: Builds the Docker image and pushes it to Docker Hub.
3. **Kubernetes Manifests**: Deploys the application and MySQL database, ensuring high availability and durability.

## CircleCI Configuration

The CircleCI pipeline builds the Docker image using the provided `Dockerfile` and pushes it to Docker Hub. The key environment variables used in CircleCI are:

- `DOCKER_IMAGE_NAME`: The name of the Docker image.
- `DOCKER_LOGIN`: Docker Hub login username.
- `DOCKER_PASSWORD`: Docker Hub private token with write permissions.

The Docker Hub Orb (`circleci/docker@2.6.0`) is used to streamline Docker-related tasks:
- **build**: Builds the Docker image.
- **push**: Pushes the image to Docker Hub.

## Kubernetes Deployment

### Application Deployment

- **Deployment**: Manages the `openweb-app` application, running a minimum of 3 replicas to ensure high availability. The deployment is configured to be resilient to voluntary disruptions. It mounts a ConfigMap containing environment variables and listens on port 8080.
- **Service**: Exposes the `openweb-app` application through a LoadBalancer service, allowing external access on port 80 and routing traffic to port 4040 in the container.
- **HorizontalPodAutoscaler (HPA)**: Automatically scales the number of replicas for the `openweb-app` deployment based on CPU utilization.
- **PodDisruptionBudget (PDB)**: Ensures that a minimum number of pods are available during voluntary disruptions, contributing to the application's high availability.

### MySQL Deployment

- **Secret**: Stores the root password for the MySQL database.
- **Service**: Exposes the MySQL database internally within the cluster on port 3306.
- **StatefulSet**: Manages the MySQL database instance with persistent storage for durability and a predefined root password. Ensures the MySQL service is stable and reliable.
- **PersistentVolumeClaim**: Requests persistent storage for the MySQL database.
- **StorageClass**: Defines the storage class for provisioning the persistent volume.

## Application Setup

1. **Environment Variables**: The `.env` file is used to configure the application. It specifies the port (`4040`), MySQL host (`mysql`), user (`root`), and password (`ori-root-pass`).
2. **Database Setup**: On startup, the application connects to the MySQL database, creates a new database (`gotodo`), and sets up the required tables.

## Summary

This project ensures that:
- The application is highly available, with automatic scaling and resilience to voluntary disruptions.
- The MySQL database is durable, with persistent storage and reliable access within the Kubernetes cluster.

All Kubernetes manifests are provided in the `k8s` folder and are ready to be applied using `kubectl`.
