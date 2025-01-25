{{- define "reverse-ip-chart.name" -}}
reverse-ip
{{- end -}}

{{- define "reverse-ip-chart.fullname" -}}
{{- .Release.Name }}-reverse-ip
{{- end -}}
