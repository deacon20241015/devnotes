# Renovate

Example for local usage and experiments

Dockerfile:
```sh
FROM amazoncorretto:17.0.12-alpine

# renovate: datasource=repology depName=alpine_3_12/gcc versioning=loose
ENV GCC_VERSION="9.3.0-r2"
# renovate: datasource=repology depName=alpine_3_12/musl-dev versioning=loose
ENV MUSL_DEV_VERSION="1.1.24-r8"
```

config.js
```js
module.exports = {
  "extends": [
    "config:recommended",
    "docker:pinDigests"
  ],
  "enabledManagers": [
    "dockerfile",
    "custom.regex"
  ],
  // https://docs.renovatebot.com/modules/datasource/repology/
  "customManagers": [
    {
      "customType": "regex",
      "fileMatch": ["^Dockerfile$"],
      "matchStrings": [
        "#\\s*renovate:\\s*datasource=(?<datasource>.*?) depName=(?<depName>.*?)( versioning=(?<versioning>.*?))?\\sENV .*?_VERSION=\"(?<currentValue>.*)\"\\s"
      ],
      "versioningTemplate": "{{#if versioning}}{{{versioning}}}{{else}}semver{{/if}}"
    }
  ]
};
```

run.sh
```sh
#!/bin/bash

docker run --rm \
  -v "$(pwd)/config.js:/usr/src/app/config.js" \
  -v "$(pwd):/usr/src/app" \
  renovate/renovate:latest bash -c \
     "LOG_LEVEL=debug renovate --platform=local --require-config=ignored --onboarding=false"
```

Output (excerpt):
```sh
...
 INFO: Dependency extraction complete (repository=local)
       "stats": {
         "managers": {
           "dockerfile": {"fileCount": 1, "depCount": 1},
           "regex": {"fileCount": 1, "depCount": 2}
         },
         "total": {"fileCount": 2, "depCount": 3}
       }
...
DEBUG: packageFiles with updates (repository=local)
       "config": {
         "dockerfile": [
           {
             "deps": [
               {
                 "depName": "amazoncorretto",
                 "currentValue": "17.0.12-alpine",
                 "replaceString": "amazoncorretto:17.0.12-alpine",
                 "autoReplaceStringTemplate": "{{depName}}{{#if newValue}}:{{newValue}}{{/if}}{{#if newDigest}}@{{newDigest}}{{/if}}",
                 "datasource": "docker",
                 "depType": "final",
                 "updates": [
                   {
                     "bucket": "non-major",
                     "newVersion": "17.0.13-alpine",
                     "newValue": "17.0.13-alpine",
                     "newDigest": "sha256:3736ade17329f114e5c0bf47af708d140797f2bc9d61717bf97da2eaa21c0ea0",
                     "releaseTimestamp": "2024-11-12T13:48:38.509Z",
                     "newVersionAgeInDays": 38,
                     "newMajor": 17,
                     "newMinor": 0,
                     "newPatch": 13,
                     "updateType": "patch",
                     "branchName": "renovate/amazoncorretto-17.x"
                   },
                   {
                     "bucket": "major",
                     "newVersion": "21.0.5-alpine",
                     "newValue": "21.0.5-alpine",
                     "newDigest": "sha256:8b16834e7fabfc62d4c8faa22de5df97f99627f148058d52718054aaa4ea3674",
                     "releaseTimestamp": "2024-11-12T13:49:18.180Z",
                     "newVersionAgeInDays": 38,
                     "newMajor": 21,
                     "newMinor": 0,
                     "newPatch": 5,
                     "updateType": "major",
                     "branchName": "renovate/amazoncorretto-21.x"
                   },
                   {
                     "isPinDigest": true,
                     "updateType": "pinDigest",
                     "newValue": "17.0.12-alpine",
                     "newDigest": "sha256:1b1d0653d890ff313a1f7afadd1fd81f5ea742c9c48670d483b1bbccef98bb8b",
                     "branchName": "renovate/pin-dependencies"
                   }
                 ],
                 "packageName": "amazoncorretto",
                 "versioning": "regex:^(?<major>\\d+)?(\\.(?<minor>\\d+))?(\\.(?<patch>\\d+))?([\\._+](?<build>(\\d\\.?)+)(LTS)?)?(-(?<compatibility>.*))?$",
                 "warnings": [],
                 "registryUrl": "https://index.docker.io",
                 "lookupName": "library/amazoncorretto",
                 "currentVersion": "17.0.12-alpine",
                 "currentVersionTimestamp": "2024-10-08T06:48:24.414Z",
                 "currentVersionAgeInDays": 73,
                 "isSingleVersion": true,
                 "fixedVersion": "17.0.12-alpine"
               }
             ],
             "packageFile": "Dockerfile"
           }
         ],
         "regex": [
           {
             "deps": [
               {
                 "depName": "alpine_3_12/gcc",
                 "currentValue": "9.3.0-r2",
                 "datasource": "repology",
                 "versioning": "loose",
                 "replaceString": "# renovate: datasource=repology depName=alpine_3_12/gcc versioning=loose\nENV GCC_VERSION=\"9.3.0-r2\"\n",
                 "updates": [],
                 "packageName": "alpine_3_12/gcc",
                 "warnings": [],
                 "registryUrl": "https://repology.org",
                 "currentVersion": "9.3.0-r2",
                 "fixedVersion": "9.3.0-r2"
               },
               {
                 "depName": "alpine_3_12/musl-dev",
                 "currentValue": "1.1.24-r8",
                 "datasource": "repology",
                 "versioning": "loose",
                 "replaceString": "# renovate: datasource=repology depName=alpine_3_12/musl-dev versioning=loose\nENV MUSL_DEV_VERSION=\"1.1.24-r8\"\n",
                 "updates": [
                   {
                     "bucket": "non-major",
                     "newVersion": "1.1.24-r10",
                     "newValue": "1.1.24-r10",
                     "newMajor": 1,
                     "newMinor": 1,
                     "newPatch": 24,
                     "updateType": "patch",
                     "branchName": "renovate/alpine_3_12-musl-dev-1.x"
                   }
                 ],
                 "packageName": "alpine_3_12/musl-dev",
                 "warnings": [],
                 "registryUrl": "https://repology.org",
                 "currentVersion": "1.1.24-r8",
                 "isSingleVersion": true,
                 "fixedVersion": "1.1.24-r8"
               }
             ],
             "matchStrings": [
               "#\\s*renovate:\\s*datasource=(?<datasource>.*?) depName=(?<depName>.*?)( versioning=(?<versioning>.*?))?\\sENV .*?_VERSION=\"(?<currentValue>.*)\"\\s"
             ],
             "versioningTemplate": "{{#if versioning}}{{{versioning}}}{{else}}semver{{/if}}",
             "packageFile": "Dockerfile"
           }
         ]
       }
```
