# ubi-etherpad
[![Docker Repository on Quay](https://quay.io/repository/davivcgarcia/ubi-etherpad/status "Docker Repository on Quay")](https://quay.io/repository/davivcgarcia/ubi-etherpad)

Unofficial image for Etherpad based on Red Hat Universal Base Image v8

## Why another image?

This image was build using the [Red Hat Universal Base Image (UBI) 8](https://developers.redhat.com/products/rhel/ubi/), which provides a stable foundation to workloads running on mission-critical environments, specially on **Red Hat OpenShift Container Platform**.

## How to use?

If you running standalone containers, you can use `podman` or `docker` with:

```bash
podman run -d -p 9001:9001 quay.io/davivcgarcia/ubi-etherpad
```

If you running containers on OpenShift (or Kubernetes using Ingress instead of Router API), and have dynamic provisioning enabled, you can use `kubectl` or `oc` to deploy it redirectly from this repo:

```bash
oc new-project etherpad
oc apply -f https://github.com/davivcgarcia/ubi-etherpad/releases/latest/download/openshift-resources.yaml
```

If you don't have dynamic provisioning for PersistentVolumes enabled, please create the required `PersistentVolume` resources and map them to the `PersistentVolumeClaim` resources before deployment.

## How to configure?

If you are running it on OpenShift/Kubernetes, you will notice that the resource template is configured to use container volumes at `/opt/etherpad/data` and `/opt/etherpad/node_modules`, mapped to `PersistentVolumes`.

The container can run using any unprivileged user ID, which will be mapped automaticaly to user `etherpad`. The configuration is stored on a `ConfigMap` called `etherpad-config`, which is mapped to `/opt/etherpad/settings.json`. If you need to change it, do not forget to force application reload (`pod` deletion).

## Any support?

This is a community project, not backed nor supported by Red Hat.
