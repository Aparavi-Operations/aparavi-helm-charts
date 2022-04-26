# Aparavi

<!-- ## Introduction -->

<!-- ## Prerequisites -->

## Installing the chart

To install the chart with the release name my-release:

```shell
helm install my-release .
```

These commands deploy MySQL on the Kubernetes cluster in the default configuration. The [Parameters](#Parameters) section lists the parameters that can be configured during installation.

## Uninstalling the chart

```shell
helm uninstall my-release
```

The command removes the Kubernetes resources associated with the chart and deletes the release. Exceptions are the persistent volumes of MySQL and Redis deployed with this chart.

## Parameters

### Common Parameters

Parameter | Description | Default
-|-|-
`image.repository` | Docker image repository of Aparavi app | `aparavi.jfrog.io/app-docker-nonprod/app`
`image.tag` | Aparavi app Docker image tag | `2.1.0-6446`
`image.pullPolicy` | The `imagePullPolicy` for containers | `IfNotPresent`
`imagePullSecrets` | Image pull secrets | `[]`
`nameOverride` | Partially override Kubernetes resource names (will maintain the release name) | `""`
`fullnameOverride` | Fully override Kubernetes resource names | `""`
`serviceAccount.create` | Specifies whether a service account should be created | `true`
`serviceAccount.annotations` | Annotations to add to the service account | `{}`
`serviceAccount.name` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`
`ingress.enabled` | Enable Ingress | `false`
`ingress.classname` | IngressClass that will be be used to implement the Ingress | `""`
`ingress.annotations` | Additional Ingress annotations | `{}`
`ingress.hosts` | `hosts` block in Ingress rules | <pre>- host: aparavi.local<br>&emsp; paths:<br>&emsp; - path: /<br>&emsp; &emsp; pathType: ImplementationSpecific</pre>
`ingress.tls` | `tls` block in Ingress | `[]`

### Platform parameters

Parameter | Description | Default
-|-|-
`platform.enabled` | Enable platform | `true`
`platform.config.rootPassword` | Platform `root` password | `"root"`
`platform.config.mysql.username` | MySQL username | `"platform"`
`platform.config.mysql.password` | MySQL password | `"platform"`
`platform.config.mysql.database` | MySQL database | `"platform"`
`platform.service.type` | Type of the Service | `"CluserIP"`
`platform.service.httpPort` | The port of the Service named `"http"` | `80`
`platform.service.netPort` | The port of the Service named `"net"` | `9455`
`platform.autoscaling.enable` | Enable Horizontal Pod Autoscaler (HPA) | `false`
`platform.autoscaling.minReplicas` | `minReplicas` of the HPA | `1`
`platform.autoscaling.maxReplicas` | `maxReplicas` of the HPA | `100`
`platform.autoscaling.targetCPUUtilizationPercentage` | `targetCPUUtilizationPercentage` of the HPA | `80`
`platform.autoscaling.targetMemoryUtilizationPercentage` | `targetMemoryUtilizationPercentage` of the HPA | None:
`platform.replicaCount` | Deployment `replicas` | `1`
`platform.podAnnotations` | Deployment pod annotations | `{}`
`platform.podSecurityContext` | Deployment pod `securityContext` | `{}`
`platform.securityContext` | `aparavi` container `securityContext` | `{}`
`platform.resources` | Pod resource requests and limits | `{}`
`platform.nodeSelector` | Node labels for pod assignment | `{}`
`platform.affinity` | Node/Pod affinities | `{}`
`platform.tolerations` | List of Node taints to tolerate | `[]`

### Aggregator parameters

Parameter | Description | Default
-|-|-
`aggregator.enabled` | Enable aggregator | `true`
`aggregator.config.platformHost` | External Aparavi Platform host in `"HOSTNAME:PORT"` format | `""`
`aggregator.config.mysql.username` | MySQL username | `"aggregator"`
`aggregator.config.mysql.password` | MySQL password | `"aggregator"`
`aggregator.config.mysql.database` | MySQL database | `"aggregator"`
`aggregator.service.type` | Type of the Service | `"CluserIP"`
`aggregator.service.port` | The port of the Service named `"net"` | `9545`
`aggregator.autoscaling.enable` | Enable Horizontal Pod Autoscaler (HPA) | `false`
`aggregator.autoscaling.minReplicas` | `minReplicas` of the HPA | `1`
`aggregator.autoscaling.maxReplicas` | `maxReplicas` of the HPA | `100`
`aggregator.autoscaling.targetCPUUtilizationPercentage` | `targetCPUUtilizationPercentage` of the HPA | `80`
`aggregator.autoscaling.targetMemoryUtilizationPercentage` | `targetMemoryUtilizationPercentage` of the HPA | None:
`aggregator.replicaCount` | Deployment `replicas` | `1`
`aggregator.podAnnotations` | Deployment pod annotations | `{}`
`aggregator.podSecurityContext` | Deployment pod `securityContext` | `{}`
`aggregator.securityContext` | `aparavi` container `securityContext` | `{}`
`aggregator.resources` | Pod resource requests and limits | `{}`
`aggregator.nodeSelector` | Node labels for pod assignment | `{}`
`aggregator.affinity` | Node/Pod affinities | `{}`
`aggregator.tolerations` | List of Node taints to tolerate | `[]`

### Collector parameters

Parameter | Description | Default
-|-|-
`collector.enabled` | Enable aggregator | `true`
`collector.config.aggregatorHost` | External Aparavi Aggregator host in `"HOSTNAME:PORT"` format | `""`
`collector.autoscaling.enable` | Enable Horizontal Pod Autoscaler (HPA) | `false`
`collector.autoscaling.minReplicas` | `minReplicas` of the HPA | `1`
`collector.autoscaling.maxReplicas` | `maxReplicas` of the HPA | `100`
`collector.autoscaling.targetCPUUtilizationPercentage` | `targetCPUUtilizationPercentage` of the HPA | `80`
`collector.autoscaling.targetMemoryUtilizationPercentage` | `targetMemoryUtilizationPercentage` of the HPA | None:
`collector.replicaCount` | Deployment `replicas` | `1`
`collector.podAnnotations` | Deployment pod annotations | `{}`
`collector.podSecurityContext` | Deployment pod `securityContext` | `{}`
`collector.securityContext` | `aparavi` container `securityContext` | `{}`
`collector.resources` | Pod resource requests and limits | `{}`
`collector.nodeSelector` | Node labels for pod assignment | `{}`
`collector.affinity` | Node/Pod affinities | `{}`
`collector.tolerations` | List of Node taints to tolerate | `[]`

### Redis parameters

`redis` and `externalRedis` blocks are mutually exclusive. That is, if `redis.enabled` is set to `true`, `externalRedis` values are ignored. In other words, `externalRedis` values are used only if `redis.enabled` is set to `false`.
Parameter | Description | Default
-|-|-
`redis.enabled` | Deploy a Redis server to satisfy applications's key store requirements | `true`
`redis.architecture` | Redis architecture. Allowed values are `standalone` and `replication` | `"standalone"`
`redis.auth.enabled` | Enable password authentication | `true`
`externalRedis.hostname` | External Redis server hostname | `"redis-master"`
`externalRedis.port` | External Redis server port | `6379`
`externalRedis.password` | External Redis server password | `""`

See https://artifacthub.io/packages/helm/bitnami/redis/16.8.7 for further configuration of the in-chart Redis and for how to obtain the Redis password.

### MySQL parameters

`mysql` and `externalMysql` blocks are mutually exclusive. That is, if `mysql.enabled` is set to `true`, `externalMysql` values are ignored. In other words, `externalMysql` values are used only if `mysql.enabled` is set to `false`.
Parameter | Description | Default
-|-|-
`mysql.enabled` | Deploy a MySQL server to satisfy applications's database requirements | `true`
`mysql.architecture` | MySQL architecture. Allowed values are `standalone` and `replication` | `"standalone"`
`mysql.auth.database` | Name for a custom database to create | `""`
`mysql.initdbScripts` | Dictionary of initdb scripts | <pre>initdb.sql: \|<br>&emsp; create user 'platform'@'%' identified by 'platform';<br>&emsp; create user 'aggregator'@'%' identified by 'aggregator';<br>&emsp; create database platform;<br>&emsp; create database aggregator;<br>&emsp; grant all privileges on platform.* to 'platform'@'%';<br>&emsp; grant all privileges on aggregator.* to 'aggregator'@'%';</pre>
`mysql.primary.service.port` | MySQL Primary service port | `3306`
`externalMysql.hostname` | External MySQL server hostname | `"redis-master"`
`externalMysql.port` | External MySQL server port | `3306`

See https://artifacthub.io/packages/helm/bitnami/mysql/8.9.2 for further configuration of the in-chart MySQL and for how to obtain the MySQL root password.
