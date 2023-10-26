{{- define "helm-library-chart.poddisruptionbudget" -}}
{{- if eq .Values.global.environment "production" }}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
  annotations:
    deploy_date: {{ now }}
spec:
  maxUnavailable: 1
  selector:
    matchLabels:
      {{- include "helm-library-chart.selectorLabels" . | nindent 6 }}
{{- end }}
{{- end }}
