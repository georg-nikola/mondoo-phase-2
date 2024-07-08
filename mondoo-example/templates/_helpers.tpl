{{- define "mondoo-example.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mondoo-example.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "mondoo-example.name" . -}}
{{- if eq $name .Chart.Name -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Chart.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "mondoo-example.labels" -}}
helm.sh/chart: {{ include "mondoo-example.chart" . }}
app.kubernetes.io/name: {{ include "mondoo-example.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "mondoo-example.chart" -}}
{{- .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

