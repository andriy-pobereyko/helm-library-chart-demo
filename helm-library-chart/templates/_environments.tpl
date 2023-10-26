{{- define "helm-library-chart.common_env" }}
- name: RELEASE_NAME
  value: "{{ printf "%s" .Release.Name }}"
- name: SERVICE_PORT
  value: "{{ .Values.app.service_port }}"
{{- end }}
