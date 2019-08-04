pipeline {
  	agent any
    options {
        disableConcurrentBuilds()
    }
  	stages {
	    stage('Build') {
	      steps {
	        echo 'test'
	        input message: 'Do you', submitter: 'team_leader'
	      }
	    }
  	}
}