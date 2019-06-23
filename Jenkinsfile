def DEV_CMD    = ""
def TEST_CMD   = ""
def UAT_CMD    = ""
def LIVE_CMD   = ""

/**
 * generte command server
 * @method      generateCMDForServer
 * @Author_name G.Balakumaran
 * @datetime    2019-06-23T19:26:30+0530
 * @param       serverName [description]
 * @return      [description]
 */

def generateCMDForServer(serverName){
    /**
     * Dev server Configuration
     */
    def DEV_DEST  = "/var/www/html/interface_dev"
    def TEST_DEST = "/var/www/html/interface_test"
    def UAT_DEST = "/var/www/html/interface_uat"
    def LIVE_DEST = "/var/www/html/interface_live"

    def COMMAND  = ""
    def DEST_DIR = ""
    if(serverName == "DEV") {
        DEST_DIR = "$DEV_DEST";
    }

    if(serverName == "TEST") {
        DEST_DIR = "$TEST_DEST";
    }

    if(serverName == "UAT") {
        DEST_DIR = "$UAT_DEST";
    }

    if(serverName == "LIVE") {
        DEST_DIR = "$LIVE_DEST";
    }

    def changeLogSets = currentBuild.changeSets
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            def files = new ArrayList(entry.affectedFiles)
            for (int k = 0; k < files.size(); k++) {
                def file = files[k]
                println "Files List -> $file.path"
                if(COMMAND != ""){
                    COMMAND = "$COMMAND && scp  -o StrictHostKeyChecking=no $WORKSPACE/$file.path ubuntu@ec2-13-232-76-112.ap-south-1.compute.amazonaws.com:$DEST_DIR/$file.path"
                }else{
                    COMMAND = "scp  -o StrictHostKeyChecking=no $WORKSPACE/$file.path ubuntu@ec2-13-232-76-112.ap-south-1.compute.amazonaws.com:$DEST_DIR/$file.path"
                }
            }
        }
    }

    return COMMAND
}

/**
 * send email
 * @method      sendEmailNotification
 * @Author_name G.Balakumaran
 * @datetime    2019-06-23T19:28:36+0530
 * @param       subject subject
 * @param       body bosy
 * @param       to to
 * @return      void
 */

def sendEmailNotification(subject,body,serverName){

    /**
     * Dev server Configuration
     */
    def DEV_EMAIL = "balakumaran.g@infinitisoftware.net"

    def TO_EMAIL  = ""
    if(serverName == "DEV") {
        TO_EMAIL = "$DEV_EMAIL";
    }


    // emailext (
    //         subject: subject,
    //         body: body,
    //         to: "$TO_EMAIL",
    //         from: "balakumaran.raji@gmail.com"
    //     )
}
/**
 * create stages
 */

node {
    stage("checkout") {
        /**
         * checking out
         */
        
        println "Checking out...."
        git url: 'https://github.com/balapkm/interface.git'

        /**
         * generate last commit changes
         */
        
        println "Get last commit changes.."
        DEV_CMD  = generateCMDForServer("DEV")
        TEST_CMD = generateCMDForServer("TEST")
        UAT_CMD  = generateCMDForServer("UAT")
        LIVE_CMD = generateCMDForServer("LIVE")
        println "$DEV_CMD"
        println "$TEST_CMD"
        println "$UAT_CMD"
        println "$LIVE_CMD"

        /**
         * checking last commit is there
         */
        if(DEV_CMD == "") {
            error("No files are committed");
        }

        /**
         * send start job emails
         */
        
        println "Send Email Notification for start Job"
        def body = """Hi team,
    The Job Name (${env.JOB_NAME} - ${env.BUILD_NUMBER}) is started successfully and refer below link about this job
    
    ${env.BUILD_URL}
        """
        sendEmailNotification("Start Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'",body,"DEV")
    }

    stage("Deploy - Development Server") {
        println "$DEV_CMD"

        /**
         * Send Email Notification for team leader for apporval
         */
        
        println "Send Email Notification team leader for apporval of file movement of development server.."
        def body = """Hi Team Leader,
    Kindly review current version code and approve the file movement of development server?

    Commit Changes - ${env.BUILD_URL}changes
    Approve/Reject - ${env.BUILD_URL}input
        """
        sendEmailNotification("Development Server approval - '${env.JOB_NAME} ${env.BUILD_NUMBER}'",body,"DEV")

        /**
         * approval for move file for development server
         */
        
        timeout(time: 5, unit: 'DAYS') {
            input message: 'Kindly review current version code and approve the file movement of development server?', ok: 'Approve', parameters: [string(defaultValue: '', description: '', name: 'Approve/Reject Reason', trim: false)], submitter: 'balakumaran'
        }

        /**
         * move files into develpment server
         */
        
        sshagent(credentials : ['Balakumaran']) {
            sh "$DEV_CMD"
        }

        /**
         * Migrate Database
         */
        println "Start database Migration"
        flywayrunner commandLineArgs: '', credentialsId: '29094ff4-b5ea-47ad-8491-6fdcd0756608', flywayCommand: 'migrate', installationName: 'Flyway', locations: "filesystem:$WORKSPACE/sql", url: 'jdbc:mysql://localhost:3306/interface_dev'
    }

    stage("Deploy - Testing Server") {
        println "$TEST_CMD"

        /**
         * Send Email Notification for Manager for apporval
         */
        
        println "Send Email Notification Manager for apporval of file movement of testing server.."
        def body = """Dear Manager,
    Kindly approve the file movement of testing server?

    Commit Changes - ${env.BUILD_URL}changes
    Approve/Reject - ${env.BUILD_URL}input
        """
        sendEmailNotification("Testing Server approval - '${env.JOB_NAME} ${env.BUILD_NUMBER}'",body,"DEV")

        /**
         * approval for move file for development server
         */
        
        timeout(time: 5, unit: 'DAYS') {
            input message: 'Kindly approve the file movement of testing server?', ok: 'Approve', parameters: [string(defaultValue: '', description: '', name: 'Approve/Reject Reason', trim: false)], submitter: 'balakumaran'
        }

        /**
         * move files into testing server
         */
        
        sshagent(credentials : ['Balakumaran']) {
            sh "$TEST_CMD"
        }

        /**
         * Migrate Database
         */
        println "Start database Migration"
        flywayrunner commandLineArgs: '', credentialsId: '29094ff4-b5ea-47ad-8491-6fdcd0756608', flywayCommand: 'migrate', installationName: 'Flyway', locations: "filesystem:$WORKSPACE/sql", url: 'jdbc:mysql://localhost:3306/interface_test'
    }

    stage("Deploy - UAT Server") {
        println "$UAT_CMD"

        /**
         * Send Email Notification for Manager for apporval
         */
        
        println "Send Email Notification Testing Team for apporval of file movement of UAT server.."
        def body = """Dear Testing Team,
    Kindly approve the file movement of UAT server?

    Commit Changes - ${env.BUILD_URL}changes
    Approve/Reject - ${env.BUILD_URL}input
        """
        sendEmailNotification("UAT Server approval - '${env.JOB_NAME} ${env.BUILD_NUMBER}'",body,"DEV")

        /**
         * approval for move file for development server
         */
        
        timeout(time: 5, unit: 'DAYS') {
            input message: 'Kindly approve the file movement of UAT server?', ok: 'Approve', parameters: [string(defaultValue: '', description: '', name: 'Approve/Reject Reason', trim: false)], submitter: 'balakumaran'
        }

        /**
         * move files into UAT server
         */
        
        sshagent(credentials : ['Balakumaran']) {
            sh "$UAT_CMD"
        }

        /**
         * Migrate Database
         */
        println "Start database Migration"
        flywayrunner commandLineArgs: '', credentialsId: '29094ff4-b5ea-47ad-8491-6fdcd0756608', flywayCommand: 'migrate', installationName: 'Flyway', locations: "filesystem:$WORKSPACE/sql", url: 'jdbc:mysql://localhost:3306/interface_uat'
    }

    stage("Deploy - LIVE Server") {
        println "$LIVE_CMD"

        /**
         * Send Email Notification for Manager for apporval
         */
        
        println "Send Email Notification Client for apporval of file movement of LIVE server.."
        def body = """Dear Client,
    Kindly approve the file movement of LIVE server?

    Commit Changes - ${env.BUILD_URL}changes
    Approve/Reject - ${env.BUILD_URL}input
        """
        sendEmailNotification("LIVE Server approval - '${env.JOB_NAME} ${env.BUILD_NUMBER}'",body,"DEV")

        /**
         * approval for move file for development server
         */
        
        timeout(time: 5, unit: 'DAYS') {
            input message: 'Kindly approve the file movement of LIVE server?', ok: 'Approve', parameters: [string(defaultValue: '', description: '', name: 'Approve/Reject Reason', trim: false)], submitter: 'balakumaran'
        }

        /**
         * move files into LVIVE server
         */
        
        sshagent(credentials : ['Balakumaran']) {
            sh "$LIVE_CMD"
        }

        /**
         * Migrate Database
         */
        println "Start database Migration"
        flywayrunner commandLineArgs: '', credentialsId: '29094ff4-b5ea-47ad-8491-6fdcd0756608', flywayCommand: 'migrate', installationName: 'Flyway', locations: "filesystem:$WORKSPACE/sql", url: 'jdbc:mysql://localhost:3306/interface_live'
    }
}
