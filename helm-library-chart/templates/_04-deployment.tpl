{{- define "helm-library-chart.deployment" -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
  labels:
    {{- include "helm-library-chart.commonLabels" . | nindent 4 }}
    {{- with .Values.app.deployment.customLabels }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    deploy_date: {{ now }}
    {{- with .Values.app.deployment.customAnnotations }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  {{- if not .Values.app.autoscaling.enabled }}
  replicas: {{ .Values.app.replicas }}
  revisionHistoryLimit: {{ .Values.app.deployment.revisionHistoryLimit }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "helm-library-chart.selectorLabels" . | nindent 6 }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        {{- include "helm-library-chart.commonLabels" . | nindent 8 }}
        {{- include "helm-library-chart.selectorLabels" . | nindent 8 }}
        {{- with .Values.app.deployment.customLabels }}
          {{- toYaml . | nindent 8 }}
        {{- end }}
      annotations:
        deploy_date: {{ now }}
        checksum/config: {{ include (print $.Template.BasePath "/01-configmap.yaml") . | sha256sum }}
        checksum/secret: {{ include (print $.Template.BasePath "/02-secret.yaml") . | sha256sum }}
        checksum/svcacct: {{ include (print $.Template.BasePath "/03-serviceaccount.yaml") . | sha256sum }}
      {{- with .Values.app.podAnnotations }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.app.deployment.customAnnotations }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
    spec:
      {{- with .Values.app.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .Values.app.serviceAccount.create }}
      serviceAccountName: {{ .Release.Name }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.app.podSecurityContext | nindent 8 }}
      nodeSelector:
        {{- with .Values.app.nodeSelector }}
          {{- toYaml . | nindent 8 }}
        {{- end }}
      affinity:
        {{- if eq .Values.global.environment "production" }}
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - {{ .Release.Name | quote }}
        {{- end }}
      tolerations:
        {{- with .Values.app.tolerations }}
          {{- toYaml . | nindent 8 }}
        {{- end }}
      {{- if .Values.app.initContainer.enabled }}
      initContainers:
      - name: "{{ .Release.Name }}-init"
        image: "{{ .Values.app.initContainer.imageUrl }}:{{ .Values.app.initContainer.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.app.initContainer.pullPolicy }}
        workingDir: {{ .Values.app.initContainer.workingDir }}
        command: [ {{ .Values.app.initContainer.command }} ]
        args:
          {{- toYaml .Values.app.initContainer.args | nindent 8 }}
        env:
          {{- include "helm-library-chart.common_env" . | indent 8 }}
      {{- end }}
      containers:
      - name: {{ .Release.Name }}
        securityContext:
          {{- toYaml .Values.app.securityContext | nindent 12 }}
        image: "{{ .Values.app.mainContainer.imageUrl }}:{{ .Values.app.mainContainer.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.app.mainContainer.pullPolicy }}
        workingDir: {{ .Values.app.mainContainer.workingDir }}
        command: [ {{ .Values.app.mainContainer.command }} ]
        args:
          {{- toYaml .Values.app.mainContainer.args | nindent 8 }}
        resources:
          {{- toYaml .Values.app.resources | nindent 10 }}
        ports:
          {{- toYaml .Values.app.mainContainer.ports | nindent 10 }}
        livenessProbe:
          {{- toYaml .Values.app.mainContainer.livenessProbe | nindent 10 }}
        readinessProbe:
          {{- toYaml .Values.app.mainContainer.readinessProbe | nindent 10 }}
        env:
          {{- include "helm-library-chart.common_env" . | indent 8 }}
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        {{- if .Values.app.addVolumeMounts }}
        volumeMounts:
          {{- toYaml .Values.app.volumeMounts | nindent 8 }}
        {{- end }}
      {{- if .Values.app.addVolumes }}
      volumes:
        {{- toYaml .Values.app.volumes | nindent 6 }}
      {{- end }}
{{- end }}
