# k8s-airflow

## Prerequsits 
1. helm, helmfiles, kubectl

## Description
This is helm chart to install airflow, and other related projects on kubernetes cluster in AWS


## Deployment Procedures

```
K8S_RELEASE_ENV=dev helmfile apply --suppress-secrets
```
Where:

- `K8S_RELEASE_NAME` - is the name of release, for production its `airflow`
- `K8S_RELEASE_ENV` - is the name of environment, for production its `prod`


add this line to the /etc/hosts file
```
127.0.0.1 prometheus.airflow.test.io dev.web.airflow.test.io dev.flower.airflow.test.io
```

Now you can visit airflow web UI and flwoer web UI dev.web.airflow.test.io dev.flower.airflow.test.io
Also if needed you can checn prometheus prometheus.airflow.test.io


git repo for dags is git@github.com:dmitriy-lukyanchikov/airflow_dags.git


## Values

Values for additional charts are located in `/values/`
Values for airflow chart are located in `/airflow/values/[ENVIRONMENT]/values.yaml`



```

## Variables

Using this variables you customize Airflow deployment

| Parameter | Type | Description | Default |
| --------- | ---- | ----------- | ------- |
| `monitoring.namespace` | string | Namespace where prometheus will be located to create servicemonitor in this namespace for airflow | `monitoring` |
| `additionalResources.secret2File` | map | Create additional resource as secret to mount to all airflow pods except celery flower | `{}` |
| `additionalResources.secret2File.name` | string | The name of secret to create for additional resource | `` |
| `additionalResources.secret2File.mountPath` | string | Path where to mount the data from secret | `` |
| `additionalResources.secret2File.mountAsDir` | string | If false will mount as file not as directory with files inside, simulate `subPath` on `volumeMounts` section in deployment tempalate | `` |
| `additionalResources.secret2File.data` | map | The data section for secret | `{}` |
| `additionalResources.configMap2File` | map | Create additional resource as configmap to mount to all airflow pods except celery flower | `{}` |
| `additionalResources.configMap2File.name` | string | The name of configmap to create for additional resource | `` |
| `additionalResources.configMap2File.mountPath` | string | Path where to mount the data from configmap | `` |
| `additionalResources.configMap2File.mountAsDir` | string | If false will mount as file not as directory with files inside, simulate `subPath` on `volumeMounts` section in deployment tempalate | `` |
| `additionalResources.configMap2File.data` | map | The data section for configmap | `{}` |
| `airflow.connections` | map | Map of Airflow connection that will be created automatically on airflow pod creation, this conenction will be added to secret `[airflow full chart name]-connections` | `{}` |
| `airflow.connections.[any].id` | string | Define id of Airflow connection | `` |
| `airflow.connections.[any].type` | string | Define type of Airflow connection | `` |
| `airflow.connections.[any].host` | string | Define host of Airflow connection | `` |
| `airflow.connections.[any].uri` | string |  Define uri of Airflow connection | `` |
| `airflow.connections.[any].login` | string |  Define uri of Airflow connection | `` |
| `airflow.connections.[any].password` | string |  Define uri of Airflow connection | `` |
| `airflow.connections.[any].schema` | string |  Define uri of Airflow connection | `` |
| `airflow.connections.[any].port` | string |  Define uri of Airflow connection | `` |
| `airflow.connections.[any].extra` | string |  Define uri of Airflow connection | `` |
| `airflow.metrics` | string | If true will add prometheus plugin to airflow to get airflow metrics and export them, the script is added from `[airflow full chart name]-metrics-script` configmap | `true` |
| `airflow.serviceMonitor` | string | If true will create service monitor for all `metrics` endpoints in namespace where airflow is deployed | `true` |
| `airflow.rbac.enable` | string | If true will enable RBAC for airflow Web Access | `true` |
| `airflow.oauth` | map | Configuration section to define Oauth provider for airflow, curently support only google | `` |
| `airflow.oauth.enable` | string | If true will enable oauth in airflow web | `true` |
| `airflow.oauth.provider` | string | Define oauth provider for Airflow Web | `google` |
| `airflow.exporter` | map | Section to set Airflow exporter values which will get airflow metrics by quering database directly,should be deprecated soon | `` |
| `airflow.service.type` | string | type of service for airflow pods | `ClusterIP` |
| `airflow.dagsPath` | string | Airflow dag path, which will be used to laod dags to airflow | `/usr/local/airflow/dags` |
| `airflow.pluginsPath` | string | Airflow plugin , which will be used to laod plugin to airflow | `/usr/local/airflow/plugins` |
| `airflow.dagsGitPath` | string | We use gitsync to sync github repo with dags for airflow, this variable is set the location of dags inside github repo | `/data/airflow/dags/aws` |
| `airflow.pluginsGitPath` | string | We use gitsync to sync github repo with plugins for airflow, this variable is set the location of plugins inside github repo | `/data/airflow/plugins` |
| `airflow.image` | map | Map that will set Airflow docker image details | `` |
| `airflow.image.tag` | string | Airflow docker image tag | `v0.5.1` |
| `airflow.image.pullPolicy` | string | Kubernetes pull policy for airflow docker image | `Always` |
| `airflow.scheduler` | map | Section to define valus for airflow sheduler deployment pod | `` |
| `airflow.scheduler.replicas` | string | Defines airflow sheduler deployment replicas to start on first deploy | `3` |
| `airflow.scheduler.num_runs` | string | Number of runs sycles for Airflow sheduler, `-1` means infinite | `-1` |
| `airflow.scheduler.nodeSelector` | map | Section to define pod `nodeSelector` for airflow sheduler deployment, see values file for default values | `` |
| `airflow.scheduler.resources` | map | Section to define pod `resources` for airflow sheduler deployment, see values file for default values | `` |
| `airflow.scheduler.env` | map | Section to define env variables for airflow sheduler pod | `` |
| `airflow.scheduler.updateStategy` | string | Section to define pod `updateStategy` for airflow sheduler deployment, see values file for default values | `` |
| `airflow.scheduler.pythonModules` | list | List of Python modules in pip format `- awscli==1.13.1` that will be installed on first init of airflow sheduler | `` |
| `airflow.web` | map | Section to define valus for airflow web deployment | `` |
| `airflow.web.replicas` | string | Defines airflow wen deployment replicas to start on first deploy | `2` |
| `airflow.web.nodeport` | string | Port on which to listen for airflow web connections if service type is `NodePort` | `30080` |
| `airflow.web.nodeSelector` | map | Section to define pod `nodeSelector` for airflow web deployment, see values file for default values | `` |
| `airflow.web.resources` | map | Section to define pod `resources` for airflow web deployment, see values file for default values | `` |
| `airflow.web.env` | map | Section to define env variables for airflow web pod | `` |
| `airflow.web.updateStategy` | string | Section to define pod `updateStategy` for airflow web deployment, see values file for default values | `` |
| `airflow.web.pythonModules` | list | List of Python modules in pip format `- awscli==1.13.1` that will be installed on first init of airflow web | `` |
| `airflow.flower` | map | Section to define valus for airflow flower deployment | `` |
| `airflow.flower.replicas` | string | Defines airflow wen deployment replicas to start on first deploy | `2` |
| `airflow.flower.nodeport` | string | Port on which to listen for airflow flower connections if service type is `NodePort` | `30080` |
| `airflow.flower.nodeSelector` | map | Section to define pod `nodeSelector` for airflow flower deployment, see values file for default values | `` |
| `airflow.flower.resources` | map | Section to define pod `resources` for airflow flower deployment, see values file for default values | `` |
| `airflow.flower.env` | map | Section to define env variables for airflow flower pod | `` |
| `airflow.flower.updateStategy` | string | Section to define pod `updateStategy` for airflow flower deployment, see values file for default values | `` |
| `airflow.flower.pythonModules` | list | List of Python modules in pip format `- awscli==1.13.1` that will be installed on first init of airflow flower | `` |
| `airflow.workersUnified` | list | List with possible values for airflow workers statefullset | `` |
| `airflow.workersUnified[].name` | string | Prefix name of Airflow worker that will be added to the name of statefull set | `` |
| `airflow.workersUnified[].enable` | string | If true workere will be created | `true` |
| `airflow.workersUnified[].queueName` | string | Queue name for airflow tasks that will be configured on this worker group | `` |
| `airflow.workersUnified[].hostLogs` | string | If `true` the host path `/var/log/airflow/[worker name]` will be mounted to container like log folder for airflow worker task logs | `false` |
| `airflow.workersUnified[].S3Configs` | list | List of configuration for s3sync airflow worker sidecar that will sync data to local path inside airflow worker container | `` |
| `airflow.workersUnified[].S3Configs[].s3Bucket` | string | Name of s3 bucket form which need to sync | `` |
| `airflow.workersUnified[].S3Configs[].mountPath` | string | Mount path inside Airflow worker container to which synced data will be mounted | `` |
| `airflow.workersUnified[].S3Configs[].s3Path` | string | Path inside s3 bucket taht will be synced | `` |
| `airflow.workersUnified[].configs` | list | List of configs that will be loaded to configmap from local folders and mounted to airflow worker cotainers | `` |
| `airflow.workersUnified[].configs[].name` | string | The anme of prefix for configmap for stoing local files directory content | `` |
| `airflow.workersUnified[].configs[].path` | string | Local Directory path from which configmap will be created by reading content of all files in this direcotry. This only happens once per deploy | `` |
| `airflow.workersUnified[].configs[].mountPath` | string | Path for content of files from created configmaps | `` |
| `airflow.workersUnified[].nodeSelector` | map |  Section to define pod `nodeSelector` for airflow worker statefulset | `` |
| `airflow.workersUnified[].resources` | map | Section to define pod `resources` for airflow worker statefulset, see values file for default values | `` |
| `airflow.workersUnified[].hostNetwork` | string | If true will use host networking for airflow worker statefulset | `false` |
| `airflow.workersUnified[].dnsPolicy` | string | Settings for airflow worker statefulset pod to choose what DNS policy to use | `` |
| `airflow.workersUnified[].env` | map | Section to define env variables for airflow worker statefulset, useally for setting `HADOOP_USER_NAME` and `AIRFLOW__CELERY__WORKER_CONCURRENCY` | `` |
| `airflow.workersUnified[].pythonModules` | list | List of Python modules in pip format `- awscli==1.13.1` that will be installed on first init of airflow worker statefulset | `` |
| `airflow.env` | map | Environment variables for all airflow deployments | `` |
| `airflow.gitsync` | map | This settings is design to configure sidecar pod taht will sync dags from GitHub repo to mounted volume. the Settings is selfexplaining. below is example of settings | `` |
| `ingress` | map | Map of settings for kubernetes airflow ingress | `` |
| `ingress.enabled` | string | If true will create ingress rules | `true` |
| `ingress.https` | string | If true will use https and create redirect rules from http to https, by default will use secret named like ingress domain as certificate source | `true` |
| `ingress.web` | map | Settings for airflow web UI ingress | `` |
| `ingress.web.path` | string | Ingress path for airflow web UI | `/` |
| `ingress.web.host` | string | Ingress domain for airflow web UI | `` |
| `ingress.web.annotations` | map | Annotation for airflow web UI kubernetes ingress | `{}` |
| `ingress.flower` | map | Settings for airflow celery flower UI ingress, the same as for `ingress.web` | `` |
| `awsInitDB` | map | Init script that will run on airflow sheduler deployment as init container to initialize AWS RDS | `` |
| `awsInitDB.enable` | string | If true will add init container to initialize AWS RDS | `false` |
| `awsInitDB.initScript` | map | Content of script taht will run as init container to initialize AWS RDS | `{}` |


#### Additional resouce
To create additional resources for using in airflow add values like this. This will create configmap named rclone-config, that will be mounted to `/usr/local/airflow` in airflow all pods except `flower`. This volume will be mounted like single file not like directory. File will be named `.rclone.conf` and data of the file will start from `[gs]`

```
additionalResources:
  configMap2File:
    rcloneConfig:
      name: rclone-config
      mountPath: /usr/local/airflow
      mountAsDir: false
      data:
        .rclone.conf: |-
          [gs]
          type = google cloud storage
          service_account_file = /usr/local/airflow/.partners_gcp.json

          [s3]
          type = s3
          provider = AWS
          env_auth = true
          region = us-west-2
```

#### Airflow worker

This example will create statefullset worker for airflow with the next configs:
- prefix on pod `aws-hadoop`
- queue name for airflow wil be `aws`
- logs will be writen on local volume on host
- number of statefullset replicas is 2
- all data from aws s3 bucket `s3.afdata.io` and path in s3 `data/tools` will be synced to mounted volume, and data will be accessable inside pod on path `/data/tools`
- additional configmaps that will be created from local directories `configs/data-configs/hive` on deploy, and will be mounted to path `/etc/hive/conf` inside pod container

```
  workersUnified:
  - name: "aws-hadoop"
    enable: true
    queueName: "aws"
    hostLogs: true
    num_workers: 2
    S3Configs:
    - s3Bucket: s3.afdata.io
      mountPath: "/data/tools"
      s3Path: data/tools
    configs:
    - name: "hive"
      path: "configs/data-configs/hive"
      mountPath: "/etc/hive/conf"
    - name: "spark"
      path: "configs/data-configs/spark"
      mountPath: "/opt/spark/conf"
    - name: "hadoop"
      path: "configs/data-configs/hadoop"
      mountPath: "/etc/hadoop/conf"
    nodeSelector:
      project: airflow
      environment: prod
      component: airflow-workers
    resources:
      requests:
        memory: 1G
        cpu: 0.5
      limits:
        memory: 7G
        cpu: 2
    hostNetwork: false
    dnsPolicy: ClusterFirst
    env:
      HADOOP_USER_NAME: 'hadoop'
      AIRFLOW__CELERY__WORKER_CONCURRENCY: '20'
    pythonModules: []
```

#### Git sync to get dags for Airflow

This settings is design to configure sidecar pod taht will sync dags from GitHub repo to mounted volume. the Settings is selfexplaining.


```
  gitsync:
    image:
      repository: googlecontainer/git-sync
      tag: v2.0.6
      pullPolicy: Always
    resources:
      limits:
         memory: "200M"
         cpu: 0.2
      requests:
        memory: "40M"
        cpu: 0.1
    env:
      GIT_KNOWN_HOSTS: false
      GIT_SYNC_SSH: true
      GIT_SYNC_BRANCH: master
      GIT_SYNC_REV: HEAD
      GIT_SYNC_REPO: git@github.com:test.git
      GIT_SYNC_WAIT: 10
      GIT_SYNC_PERMISSIONS: 755
      GIT_SYNC_DEST: data
      GIT_SYNC_MAX_SYNC_FAILURES: 3
```

