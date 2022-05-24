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

The command removes the Kubernetes resources associated with the chart and deletes the release. Exceptions are the persistent volumes of MySQL deployed with this chart.

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

### Aggregator parameters

Parameter | Description | Default
-|-|-
`aggregator.enabled` | Enable aggregator | `true`
`aggregator.config.platform.host` | External Aparavi Platform host in `"HOSTNAME:PORT"` format | `""`
`aggregator.config.platform.nodeId` | External Aparavi Platform nodeId to bind to | `""`
`aggregator.config.nodeName` | Node name of this instance. If empty, will default to .Release.Name-aggregator | `""`
`aggregator.config.mysql.username` | MySQL username | `"aggregator"`
`aggregator.config.mysql.password` | MySQL password | `"aggregator"`
`aggregator.extraVolumes` | Extra volumes | `[]`
`aggregator.extraVolumeMounts` | Extra volume mounts | `[]`
`aggregator.initContainers` | Init containers | `[]`
`aggregator.service.type` | Type of the Service | `"CluserIP"`
`aggregator.service.netPort` | `"net"` port | `9545`
`aggregator.service.httpPort` | `"http"` port | `9552`
`aggregator.podAnnotations` | Deployment pod annotations | `{}`
`aggregator.podSecurityContext` | Deployment pod `securityContext` | `{}`
`aggregator.securityContext` | `aparavi` container `securityContext` | `{}`
`aggregator.resources` | Pod resource requests and limits | `{}`
`aggregator.nodeSelector` | Node labels for pod assignment | `{}`
`aggregator.affinity` | Node/Pod affinities | <pre>podAntiAffinity:<br>&emsp;&emsp;preferredDuringSchedulingIgnoredDuringExecution:<br>&emsp;&emsp;&emsp;&emsp;- weight: 100<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;podAffinityTerm<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;labelSelector:<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;matchExpressions:<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;- key: app.kubernetes.io/component<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;operator: In<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;values:<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;- collector<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;topologyKey: kubernetes.io/hostname</pre>
`aggregator.tolerations` | List of Node taints to tolerate | `[]`

### Collector parameters

Parameter | Description | Default
-|-|-
`collector.enabled` | Enable aggregator | `true`
`collector.config.aggregatorHost` | External Aparavi Aggregator host in `"HOSTNAME:PORT"` format | `""`
`collector.config.nodeName` | Node name of this instance. If empty, will default to .Release.Name-collector | `""`
`collector.extraVolumes` | Extra volumes | `[]`
`collector.extraVolumeMounts` | Extra volume mounts | `[]`
`collector.initContainers` | Init containers | `[]`
`collector.service.type` | Type of the Service | `"CluserIP"`
`collector.service.netPort` | `"net"` port | `9645`
`collector.service.httpPort` | `"http"` port | `9652`
`collector.podAnnotations` | Deployment pod annotations | `{}`
`collector.podSecurityContext` | Deployment pod `securityContext` | `{}`
`collector.securityContext` | `aparavi` container `securityContext` | `{}`
`collector.resources` | Pod resource requests and limits | `{}`
`collector.nodeSelector` | Node labels for pod assignment | `{}`
`collector.affinity` | Node/Pod affinities | <pre>podAntiAffinity:<br>&emsp;&emsp;preferredDuringSchedulingIgnoredDuringExecution:<br>&emsp;&emsp;&emsp;&emsp;- weight: 100<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;podAffinityTerm<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;labelSelector:<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;matchExpressions:<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;- key: app.kubernetes.io/component<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;operator: In<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;values:<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;- aggregator<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;topologyKey: kubernetes.io/hostname</pre>
`collector.tolerations` | List of Node taints to tolerate | `[]`

### MySQL parameters

`mysql` and `externalMysql` blocks are mutually exclusive. That is, if `mysql.enabled` is set to `true`, `externalMysql` values are ignored. In other words, `externalMysql` values are used only if `mysql.enabled` is set to `false`.
Parameter | Description | Default
-|-|-
`mysql.enabled` | Deploy a MySQL server to satisfy applications's database requirements | `true`
`mysql.architecture` | MySQL architecture. Allowed values are `standalone` and `replication` | `"standalone"`
`mysql.auth.database` | Name for a custom database to create | `""`
`mysql.initdbScripts` | Dictionary of initdb scripts | <pre>initdb.sql: \|<br>&emsp; create user 'aggregator'@'%' identified by 'aggregator';<br>&emsp; grant all privileges on *.* to 'aggregator'@'%';</pre>
`mysql.primary.service.port` | MySQL Primary service port | `3306`
`externalMysql.hostname` | External MySQL server hostname | `"redis-master"`
`externalMysql.port` | External MySQL server port | `3306`

See https://artifacthub.io/packages/helm/bitnami/mysql/8.9.2 for further configuration of the in-chart MySQL and for how to obtain the MySQL root password.
