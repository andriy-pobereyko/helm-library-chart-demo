{{- define "helm-library-chart.configmap" -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
  annotations:
    deploy_date: {{ now }}
data:
  app.conf: |
    {}
{{- end }}
