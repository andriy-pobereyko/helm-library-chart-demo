{{- define "helm-library-chart.test-connection" -}}
---
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "helm-library-chart.name" . }}-test-connection"
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test
    deploy_date: {{ now }}
spec:
  containers:
    - name: wget
      image: busybox
      command: [ "wget" ]
      args: [ "{{ include "helm-library-chart.name" . }}:{{ .Values.app.service_port }}" ]
  restartPolicy: Never
{{- end }}
