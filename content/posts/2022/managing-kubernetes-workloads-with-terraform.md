---
title: Managing Kubernetes Workloads with Terraform
date: 2022-10-17T21:37:24+13:00

categories: DevOps
tags:
  - kubernetes
  - terraform
  - sre
---

Terraform is an awesome way of managing infrastructure as code. It builds a graph of your definition, compares it to what exists already, and makes only the required changes. It handles dependencies automatically, allowing you to configure cloud resources based on the outputs of others.

One of the so-called "providers" in Terraform is Kubernetes, which allows you to make changes to a running Kubernetes instance in the same way you would with infrastructure. This lets you create a managed Kubernetes instance with a cloud provider, and then deploy to it using the same language.

If you are at all familiar with Terraform, you might try something like this, all in one file:

```tf
# THIS IS WRONG
# > don't do this (read on)

terraform {
  required_version = ">= 0.14.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.22.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
  }
}


resource "digitalocean_kubernetes_cluster" "cluster" {
  name   = "my-sample-cluster"
  # ... snip ...
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.cluster.endpoint
  token = digitalocean_kubernetes_cluster.cluster.kube_config.0.token

  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}
```

The above will work, but likely only once. Upon update, you might come across an error indicating that the host was incorrect, appearing to be localhost on port 80 - the defaults. This would be because of the way in which the Terraform dependency model graph works - the providers are always evaluated before actual resources.

To get around this limitation, and avoid difficult to diagnose issues, it is important to split your definitions into two completely separate Terraform projects. This will mean you will need to run the `terraform apply` command two times, one for each project. The configuration of the Kubernetes provider in your 'workload' Terraform project would be configured wither by [sharing state](https://www.terraform.io/language/state/remote-state-data) through Terraform Cloud, or by using a data source of the cluster you created (if supported by your cloud provider).

Here is an example of this in action:

```tf
# resources/main.tf

terraform {
  required_version = ">= 0.14.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.22.3"
    }
  }
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name   = "my-sample-cluster"
  # ... snip ...
}
```

```tf
# workload/main.tf

terraform {
  required_version = ">= 0.14.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.22.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
  }
}

data "digitalocean_kubernetes_cluster" "cluster" {
  name = "my-sample-cluster"
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.cluster.endpoint
  token = data.digitalocean_kubernetes_cluster.cluster.kube_config.0.token
  
  cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}
```