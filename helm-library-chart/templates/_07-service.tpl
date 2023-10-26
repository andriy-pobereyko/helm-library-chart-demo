{{- define "helm-library-chart.service" -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
    {{- with .Values.app.service.customLabels }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    deploy_date: {{ now }}
    {{- with .Values.app.service.customAnnotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  type: {{ .Values.app.service.type }}
  ports:
    {{- toYaml .Values.app.service.ports | nindent 4 }}
  selector:
    {{- include "helm-library-chart.selectorLabels" . | nindent 4 }}
{{- end }}
