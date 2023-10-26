{{/* Expand the name of the chart. */}}
{{- define "helm-library-chart.name" -}}
{{- .Chart.Name | trunc 63 }}
{{- end }}

{{/* Join chart name and version as used by the chart label. */}}
{{- define "helm-library-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Define common labels */}}
{{- define "helm-library-chart.commonLabels" -}}
helm.sh/chart: {{ include "helm-library-chart.chart" . }}
{{ include "helm-library-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Define selector labels */}}
{{- define "helm-library-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-library-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
