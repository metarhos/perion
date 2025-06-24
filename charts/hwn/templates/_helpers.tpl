{{- define "hello-world-node.fullname" -}}
{{ printf "%s-%s" .Release.Name (include "hello-world-node.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hello-world-node.name" -}}
{{- printf "%s-%s" .Chart.Name (.Values.msName | default "no-name") | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "hello-world-node.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "hello-world-node.selectorLabels" . | nindent 0 }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: {{ .Values.msName | default "no-name" }}
{{- end -}}

{{- define "hello-world-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-world-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}