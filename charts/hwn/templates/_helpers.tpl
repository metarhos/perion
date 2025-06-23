{{- define "hello-world-node.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}

#what the release name?