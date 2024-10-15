# trivy

Idea from https://gitlab.com/rahome/trivy-cache/-/tree/main?ref_type=heads 

See related informations at

* https://aquasecurity.github.io/trivy/v0.56/docs/configuration/cache/
* https://docs.gitlab.com/ee/ci/yaml/index.html#cache
* Trivy issue 675

Create Dockerfile with something like

```sh
trivy clean --all
trivy image --download-db-only --no-progress
trivy image --download-java-db-only --no-progress
```

push it, create schedule. Use a job similar to

```sh
Job:
.trivy:
  image: MYREGISTRY/trivy-cache:latest
  before_script:
    - trivy --version
    - trivy clean --scan-cache
  script: |
    trivy image --skip-db-update --skip-java-db-update -severity CRITICAL MYIMAGE
```
