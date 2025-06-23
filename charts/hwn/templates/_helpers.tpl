{{- define "hello-world-node.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}

{{- define "hello-world-node.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Chart labels */}}
{{- define "hello-world-node.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "hello-world-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels */}}
{{- define "hello-world-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-world-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}