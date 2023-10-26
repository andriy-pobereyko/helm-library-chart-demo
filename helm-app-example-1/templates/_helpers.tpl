{{/* Expand the name of the chart. */}}
{{- define "helm-app-example-1.name" -}}
{{- .Chart.Name | trunc 63 }}
{{- end }}

{{/* Join chart name and version as used by the chart label. */}}
{{- define "helm-app-example-1.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Define common labels */}}
{{- define "helm-app-example-1.commonLabels" -}}
helm.sh/chart: {{ include "helm-app-example-1.chart" . }}
{{ include "helm-app-example-1.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Define selector labels */}}
{{- define "helm-app-example-1.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-app-example-1.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
