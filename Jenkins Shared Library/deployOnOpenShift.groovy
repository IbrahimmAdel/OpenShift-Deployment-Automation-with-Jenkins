#!/usr/bin/env groovy

//OpenShiftCredentialsID can be credentials of service account token or KubeConfig file 
def call(String OpenShiftCredentialsID, String openshiftClusterurl, String openshiftProject, String imageName) {
    
    // Update deployment.yaml with new Docker Hub image
    sh "sed -i 's|image:.*|image: ${imageName}:${BUILD_NUMBER}|g' deployment.yaml"

    // login to OpenShift Cluster via cluster url & service account token
    withCredentials([string(credentialsId: "${OpenShiftCredentialsID}", variable: 'OpenShift_CREDENTIALS')]) {
            sh "oc login --server=${openshiftClusterurl} --token=${OpenShift_CREDENTIALS} --insecure-skip-tls-verify"
            sh "oc project ${openshiftProject}"
            sh "oc apply -f ."
    }

    // login to OpenShift Cluster via KubeConfig file
    //withCredentials([file(credentialsId: 'OpenShiftCredentialsID', variable: 'KUBECONFIG_FILE')]) {
            //sh "export KUBECONFIG=\$KUBECONFIG_FILE && oc apply -f . -n "${openshiftProject}""
    //}
    
}

