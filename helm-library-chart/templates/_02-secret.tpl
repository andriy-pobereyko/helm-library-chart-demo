{{- define "helm-library-chart.secret" -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
  annotations:
    deploy_date: {{ now }}
type: Opaque
data:
{{- end }}
