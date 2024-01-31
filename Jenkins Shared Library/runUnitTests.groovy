#!/usr/bin/env groovy
def call() {
	echo "Running Unit Test..."
	sh './gradlew clean test'	
}

