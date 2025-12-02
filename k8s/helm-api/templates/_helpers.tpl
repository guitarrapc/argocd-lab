{{/*
Expand the name of the chart.
*/}}
{{- define "helm-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified app name for C#.
*/}}
{{- define "helm-api.name.csharp" -}}
{{- printf "%s-csharp" (include "helm-api.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified app name for Go.
*/}}
{{- define "helm-api.name.go" -}}
{{- printf "%s-go" (include "helm-api.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
