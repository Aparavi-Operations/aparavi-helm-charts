{{/*
Expand the name of the chart.
*/}}
{{- define "aparavi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aparavi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "aparavi.platform.fullname" -}}
{{- include "aparavi.fullname" . -}}-platform
{{- end }}

{{- define "aparavi.aggregator.fullname" -}}
{{- include "aparavi.fullname" . -}}-aggregator
{{- end }}

{{- define "aparavi.collector.fullname" -}}
{{- include "aparavi.fullname" . -}}-collector
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aparavi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aparavi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aparavi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "aparavi.platform.selectorLabels" -}}
{{ include "aparavi.selectorLabels" . }}
app.kubernetes.io/component: platform
{{- end }}

{{- define "aparavi.aggregator.selectorLabels" -}}
{{ include "aparavi.selectorLabels" . }}
app.kubernetes.io/component: aggregator
{{- end }}

{{- define "aparavi.collector.selectorLabels" -}}
{{ include "aparavi.selectorLabels" . }}
app.kubernetes.io/component: collector
{{- end }}

{{/*
Common labels
*/}}
{{- define "aparavi.labels" -}}
helm.sh/chart: {{ include "aparavi.chart" . }}
{{ include "aparavi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "aparavi.platform.labels" -}}
{{- $aparaviLabels := fromYaml (include "aparavi.labels" .) -}}
{{- $selectorLabels := fromYaml (include "aparavi.platform.selectorLabels" .) -}}
{{- $labels := merge $selectorLabels $aparaviLabels -}}
{{ toYaml $labels }}
{{- end -}}

{{- define "aparavi.aggregator.labels" -}}
{{- $aparaviLabels := fromYaml (include "aparavi.labels" .) -}}
{{- $selectorLabels := fromYaml (include "aparavi.aggregator.selectorLabels" .) -}}
{{- $labels := merge $selectorLabels $aparaviLabels -}}
{{ toYaml $labels }}
{{- end -}}

{{- define "aparavi.collector.labels" -}}
{{- $aparaviLabels := fromYaml (include "aparavi.labels" .) -}}
{{- $selectorLabels := fromYaml (include "aparavi.collector.selectorLabels" .) -}}
{{- $labels := merge $selectorLabels $aparaviLabels -}}
{{ toYaml $labels }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "aparavi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "aparavi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the Redis hostname
*/}}
{{- define "redis.hostname" -}}
{{- if .Values.redis.enabled -}}
  {{ .Release.Name }}-redis-master
{{- else -}}
  {{ .Values.externalRedis.hostname }}
{{- end -}}
{{- end -}}

{{/*
Return the Redis port
*/}}
{{- define "redis.port" -}}
{{- if .Values.redis.enabled }}
  {{- default "6379" .Values.redis.master.service.ports.redis }}
{{- else -}}
  {{ .Values.externalRedis.port }}
{{- end -}}
{{- end -}}

{{- define "redis.passwordEnvName" -}}
REDIS_PASSWORD
{{- end -}}

{{- define "redis.secretName" -}}
{{ .Release.Name }}-redis
{{- end -}}

{{- define "redis.passwordSecretKey" -}}
redis-password
{{- end -}}

{{- define "redis.passwordEnvValue" -}}
{{- if or (not .Values.redis.enabled) (and .Values.redis.enabled .Values.redis.auth.enabled) -}}
valueFrom:
  secretKeyRef:
    name: {{ include "redis.secretName" . }}
    key: {{ include "redis.passwordSecretKey" . }}
{{- end -}}
{{- end -}}
