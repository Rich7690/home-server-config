<div align="center">

<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="center" width="144px" height="144px"/>

## My home server configuration
</div>

<br/>

## 📖 Overview

This repository contains the configuration I use to manage a lot of the software I run on my home server. The primary orchestrator I use to run applications in my home server environment is [Kubernetes](https://kubernetes.io) due to its many various features for running software. I'm a big user of the [k8s-at-home](https://github.com/k8s-at-home/) project configs for simple deployments of commonly used applications in the cluster.

At the moment, I primarly use a ArgoCD to deploy applications into the cluster while I use [Terraform](https://www.terraform.io) based workflow to apply certain things that I have had trouble moving over (external systems, domain secrets and other secret templates, but soon to move over)
