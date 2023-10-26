{{- define "helm-library-chart.ingress" -}}
{{- if .Values.app.ingress.enabled -}}
{{- $helmName := .Release.Name -}}
{{- $svcPort := .Values.app.service_port -}}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
    {{- with .Values.app.ingress.customLabels }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    deploy_date: {{ now }}
    {{- with .Values.app.ingress.customAnnotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  ingressClassName: {{ .Values.app.ingress.className }}

  {{- if .Values.app.ingress.tls }}
  tls:
    {{- range .Values.app.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.app.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            pathType: {{ .pathType }}
            backend:
              service:
                name: {{ $helmName }}
                port:
                  number: {{ $svcPort }}
          {{- end }}
    {{- end }}
{{- end }}
{{- end }}
