#!usr/bin/env groovy
def call(){ 
	withSonarQubeEnv() { 
        	echo "Running SonarQube Analysis..."
		sh 'chmod +x gradlew'
        	sh "./gradlew sonar" 
	}
}
