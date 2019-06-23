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
    def DEV_EMAIL = "balakumaran.g@infinitisoftware.net"
    def DEV_DEST  = "/var/www/html/interface_dev"
    def DEV_CMD   = ""

    def COMMAND  = ""
    def DEST_DIR = ""
    if(serverName == "DEV") {
        DEST_DIR = "$DEV_DEST";
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
                    COMMAND = "$CMD && scp  -o StrictHostKeyChecking=no $WORKSPACE/$file.path ubuntu@ec2-13-232-76-112.ap-south-1.compute.amazonaws.com:$DEST_DIR/$file.path"
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


    emailext (
            subject: subject,
            body: body,
            to: "$TO_EMAIL",
            from: "balakumaran.raji@gmail.com"
        )
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
        DEV_CMD = generateCMDForServer("DEV")

        /**
         * send start job emails
         */
        
        println "Send Email Notification for start Job"
        def body = """Hi team,
           '${env.JOB_NAME} ${env.BUILD_NUMBER}' is started successfully and refer below console output
           ${env.BUILD_URL}
        """
        sendEmailNotification("Start Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'",body,"DEV")
    }

    stage("last-changes") {
         println "$DEV_CMD"
    }

    stage("Move to server") {
        println "$DEV_CMD"
        /*if(CMD != ""){
            sshagent(credentials : ['Balakumaran']) {
                sh "$CMD"
            }
        }*/
    }
}
