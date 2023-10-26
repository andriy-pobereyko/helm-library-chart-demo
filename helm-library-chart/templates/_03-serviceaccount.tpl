{{- define "helm-library-chart.serviceaccount" -}}
{{- if .Values.app.serviceAccount.create -}}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
  annotations:
    deploy_date: {{ now }}
    {{- with .Values.app.serviceAccount.annotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
{{- end }}
