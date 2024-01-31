@Library('Jenkins-Shared-Library')_
pipeline {
    agent any
    
    environment {
        dockerHubCredentialsID	    = 'DockerHub'  		    			// DockerHub credentials ID.
        imageName   		    = 'ibrahimadel10/ivolve-app'     			// DockerHub repo/image name.
	openshiftCredentialsID	    = 'OpenShift'		    			// service account token credentials ID or KubeConfig credentials ID.
	openshiftClusterURL	    = 'https://api.ocpuat.devopsconsulting.org:6443'   	// OpenShift Cluser URL.
        openshifProject 	    = 'ibrahim'			     			// OpenShift project name.
	    
    }
    
    stages {
        
        stage('Repo Checkout') {
            steps {
            	script {
                	checkoutRepo
                }
            }
        }

        stage('Run Unit Test') {
            steps {
                script {
                	// Navigate to the directory contains the Application
                	dir('App') {
                		runUnitTests
            		}
        	}
    	    }
	}
	
        stage('Run SonarQube Analysis') {
            steps {
                script {
                    	// Navigate to the directory contains the Application
                    	dir('App') {
                    		runSonarQubeAnalysis()
                    	}
                }
            }
        }
       
        stage('Build and Push Docker Image') {
            steps {
                script {
                	// Navigate to the directory contains Dockerfile
                 	dir('App') {
                 		buildandPushDockerImage("${dockerHubCredentialsID}", "${imageName}")
                        
                    	}
                }
            }
        }

        stage('Deploy on OpenShift Cluster') {
            steps {
                script { 
                        // Navigate to the directory contains OpenShift YAML files
                	dir('OpenShift') {
				deployOnOpenShift("${openshiftCredentialsID}", "${openshiftCluster}", "${openshifProject}", "${imageName}")
                    	}
                }
            }
        }
    }

    post {
        success {
            echo "${JOB_NAME}-${BUILD_NUMBER} pipeline succeeded"
        }
        failure {
            echo "${JOB_NAME}-${BUILD_NUMBER} pipeline failed"
        }
    }
}
