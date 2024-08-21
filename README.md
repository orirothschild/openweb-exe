# OpenWeb Home Task

This project involves deploying a ToDo list application provided by the OpenWeb team. The solution includes containerizing the application, setting up a CI/CD pipeline, and deploying it on Kubernetes with a durable MySQL database.

## Project Overview

The project consists of the following components:

1. **Dockerfile**: Containerizes the application.
2. **CircleCI Configuration**: Builds the Docker image and pushes it to Docker Hub.
3. **Kubernetes Manifests**: Deploys the application and MySQL database, ensuring high availability and durability.

## CI/CD Flow

### CircleCI Pipeline

The CircleCI pipeline automates the process of building, testing, and deploying the application. Here’s a detailed breakdown of the pipeline:

1. **Pipeline Configuration**: Defined in `.circleci/config.yml`.

2. **Jobs**:
   - **build-and-push**: This job performs the following steps:
     - **Setup Remote Docker**: Prepares the Docker environment for building and pushing images.
     - **Checkout**: Retrieves the code from the repository.
     - **Docker Build**: Builds the Docker image using the `Dockerfile` in the repository.
     - **Docker Push**: Pushes the built Docker image to Docker Hub.
     - **Run Digest Command**: Outputs the digest of the pushed Docker image for verification.

3. **Workflows**:
   - **commit**: This workflow triggers the `build-and-push` job whenever code is committed to the repository.

### Docker Hub Integration

The Docker Hub Orb (`circleci/docker@2.6.0`) is used to streamline Docker-related tasks:

- **docker/build**: Builds the Docker image with the specified name and tag.
- **docker/push**: Pushes the Docker image to Docker Hub, using the credentials provided by the environment variables.

**Environment Variables Required in CircleCI**:
- `DOCKER_IMAGE_NAME`: The name of the Docker image to be built and pushed.
- `DOCKER_LOGIN`: Docker Hub login username.
- `DOCKER_PASSWORD`: Docker Hub private token with write permissions to the repository `orirothschild/openweb-app`.

### Kubernetes Deployment

The application and MySQL database are deployed using Kubernetes manifests:

1. **Application Deployment**:
   - **Deployment**: Manages the `openweb-app` application with high availability and resilience to voluntary disruptions. The application is exposed via a LoadBalancer service.
   - **HorizontalPodAutoscaler (HPA)**: Scales the number of replicas based on CPU utilization.
   - **PodDisruptionBudget (PDB)**: Ensures a minimum number of pods are available during voluntary disruptions.

2. **MySQL Deployment**:
   - **Secret**: Stores the root password for MySQL.
   - **Service**: Exposes the MySQL database internally on port 3306.
   - **StatefulSet**: Manages the MySQL instance with persistent storage.
   - **PersistentVolumeClaim**: Requests storage for MySQL data.
   - **StorageClass**: Defines the storage class for provisioning volumes.

## Application Setup

1. **Environment Variables**: The `.env` file configures the application with the port (`4040`), MySQL host (`mysql`), user (`root`), and password (`ori-root-pass`).
2. **Database Setup**: The application initializes the MySQL database by creating a new database (`gotodo`) and setting up the necessary tables upon startup.

## Summary

This solution ensures that:
- The application is highly available, with automatic scaling and resilience to voluntary disruptions.
- The MySQL database is durable, with persistent storage and reliable access within the Kubernetes cluster.
- The CI/CD pipeline automates the build, test, and deployment processes, integrating seamlessly with Docker Hub and Kubernetes.

All Kubernetes manifests are provided in the `k8s` folder and are ready to be applied using `kubectl`.
