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
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "aparavi.platform.labels" -}}
{{ include "aparavi.labels" . }}
{{ include "aparavi.platform.selectorLabels" . }}
{{- end }}

{{- define "aparavi.aggregator.labels" -}}
{{ include "aparavi.labels" . }}
{{ include "aparavi.aggregator.selectorLabels" . }}
{{- end }}

{{- define "aparavi.collector.labels" -}}
{{ include "aparavi.labels" . }}
{{ include "aparavi.collector.selectorLabels" . }}
{{- end }}

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
