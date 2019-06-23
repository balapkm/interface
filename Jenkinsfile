def generateCMDForServer(serverName){
    /**
     * Dev server Configuration
     */
    def DEV_EMAIL = "balakumaran.g@infinitisoftware.net"
    def DEV_DEST  = "/var/www/html/circleci"
    def DEV_CMD   = ""

    def COMMAND  = ""
    def DEST_DIR = ""
    if(serverName == "DEV") {
        DEST_DIR = "$DEV_DEST";
        println "$DEST_DIR";
    }
    println "$DEST_DIR";
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

node {
    stage("checkout") {
        println "Checking out...."
        git url: 'https://github.com/balapkm/interface.git'

        println "Get last commit changes.."
        DEV_CMD = generateCMDForServer("DEV")
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
