{{- define "helm-library-chart.horizontalpodautoscaler" -}}
{{- if .Values.app.autoscaling.enabled }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
  annotations:
    deploy_date: {{ now }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .Release.Name }}
  minReplicas: {{ .Values.app.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.app.autoscaling.maxReplicas }}
  behavior:
    scaleDown:
      stabilizationWindowSeconds: {{ .Values.app.autoscaling.stabilization_window.scale_down }}
    scaleUp:
      stabilizationWindowSeconds: {{ .Values.app.autoscaling.stabilization_window.scale_up }}
  metrics:
    {{- if .Values.app.autoscaling.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.app.autoscaling.targetCPUUtilizationPercentage }}
    {{- end }}
    {{- if .Values.app.autoscaling.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ .Values.app.autoscaling.targetMemoryUtilizationPercentage }}
    {{- end }}
{{- end }}
{{- end }}
