{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cluster-autoscaler.name" -}}
{{- default (printf "%s-%s" .Values.cloudProvider .Chart.Name) .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "cluster-autoscaler.fullname" -}}
{{- default (printf "%s" .Values.rbac.serviceAccount.name) -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cluster-autoscaler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return instance and name labels.
*/}}
{{- define "cluster-autoscaler.instance-name" -}}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/name: {{ include "cluster-autoscaler.fullname" . | quote }}
{{- end -}}


{{/*
Return labels, including instance and name.
*/}}
{{- define "cluster-autoscaler.labels" -}}
{{ include "cluster-autoscaler.instance-name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "cluster-autoscaler.chart" . | quote }}
{{- if .Values.additionalLabels }}
{{ toYaml .Values.additionalLabels }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for deployment.
*/}}
{{- define "deployment.apiVersion" -}}
{{- $kubeTargetVersion := default .Capabilities.KubeVersion.GitVersion .Values.kubeTargetVersionOverride }}
{{- if semverCompare "<1.9-0" $kubeTargetVersion -}}
{{- print "apps/v1beta2" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for podsecuritypolicy.
*/}}
{{- define "podsecuritypolicy.apiVersion" -}}
{{- $kubeTargetVersion := default .Capabilities.KubeVersion.GitVersion .Values.kubeTargetVersionOverride }}
{{- if semverCompare "<1.10-0" $kubeTargetVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else -}}
{{- print "policy/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Return the service account name used by the pod.
*/}}
{{- define "cluster-autoscaler.serviceAccountName" -}}
{{- if .Values.rbac.serviceAccount.create -}}
    {{ default .Values.rbac.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.rbac.serviceAccount.name }}
{{- end -}}
{{- end -}}
