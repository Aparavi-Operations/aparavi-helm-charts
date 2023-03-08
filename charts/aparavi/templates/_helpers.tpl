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

{{- define "aparavi.aggregator.fullname" -}}
{{- include "aparavi.fullname" . -}}-aggregator
{{- end }}

{{- define "aparavi.collector.fullname" -}}
{{- include "aparavi.fullname" . -}}-collector
{{- end }}

{{- define "aparavi.appagent.fullname" -}}
{{- include "aparavi.fullname" . -}}-appagent
{{- end }}

{{- define "aparavi.worker.fullname" -}}
{{- include "aparavi.fullname" . -}}-worker
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aparavi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "aparavi.aggregator.uniqueLabels" -}}
app.kubernetes.io/component: aggregator
{{- end }}

{{- define "aparavi.collector.uniqueLabels" -}}
app.kubernetes.io/component: collector
{{- end }}

{{- define "aparavi.appagent.uniqueLabels" -}}
app.kubernetes.io/component: appagent
{{- end }}

{{- define "aparavi.worker.uniqueLabels" -}}
app.kubernetes.io/component: worker
{{- end }}

{{/*
Selector labels
*/}}
{{- define "aparavi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aparavi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "aparavi.aggregator.selectorLabels" -}}
{{ include "aparavi.selectorLabels" . }}
{{ include "aparavi.aggregator.uniqueLabels" . }}
{{- end }}

{{- define "aparavi.collector.selectorLabels" -}}
{{ include "aparavi.selectorLabels" . }}
{{ include "aparavi.collector.uniqueLabels" . }}
{{- end }}

{{- define "aparavi.appagent.selectorLabels" -}}
{{ include "aparavi.selectorLabels" . }}
{{ include "aparavi.appagent.uniqueLabels" . }}
{{- end }}

{{- define "aparavi.worker.selectorLabels" -}}
{{ include "aparavi.selectorLabels" . }}
{{ include "aparavi.worker.uniqueLabels" . }}
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

{{- define "aparavi.appagent.labels" -}}
{{- $aparaviLabels := fromYaml (include "aparavi.labels" .) -}}
{{- $selectorLabels := fromYaml (include "aparavi.appagent.selectorLabels" .) -}}
{{- $labels := merge $selectorLabels $aparaviLabels -}}
{{ toYaml $labels }}
{{- end -}}

{{- define "aparavi.worker.labels" -}}
{{- $aparaviLabels := fromYaml (include "aparavi.labels" .) -}}
{{- $selectorLabels := fromYaml (include "aparavi.worker.selectorLabels" .) -}}
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
Return the MySQL Hostname
*/}}
{{- define "mysql.hostname" -}}
{{- if .Values.mysql.enabled }}
    {{- if eq .Values.mysql.architecture "replication" }}
        {{ .Release.Name }}-mysql-primary
    {{- else -}}
        {{ .Release.Name }}-mysql
    {{- end -}}
{{- else -}}
    {{- .Values.externalMysql.hostname -}}
{{- end -}}
{{- end -}}

{{/*
Return the MySQL Port
*/}}
{{- define "mysql.port" -}}
{{- if .Values.mysql.enabled }}
    {{- default "3306" .Values.mysql.primary.service.port -}}
{{- else -}}
    {{- .Values.externalMysql.port -}}
{{- end -}}
{{- end -}}
