def CMD

/**
 * Dev server Configuration
 */
def DEV_EMAIL = "balakumaran.g@infinitisoftware.net"
def DEV_DEST  = "/var/www/html/circleci"
def DEV_CMD 

def generateCMDForServer(){
    CMD = ""
    def changeLogSets = currentBuild.changeSets
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            def files = new ArrayList(entry.affectedFiles)
            for (int k = 0; k < files.size(); k++) {
                def file = files[k]
                def dest_dir = "";
                println "$file.path"
                if(CMD != ""){
                    CMD = "$CMD && scp  -o StrictHostKeyChecking=no $WORKSPACE/$file.path ubuntu@ec2-13-232-76-112.ap-south-1.compute.amazonaws.com:$dest_dir/$file.path"
                }else{
                    CMD = "scp  -o StrictHostKeyChecking=no $WORKSPACE/$file.path ubuntu@ec2-13-232-76-112.ap-south-1.compute.amazonaws.com:$dest_dir/$file.path"
                }
            }
        }
    }

    return CMD
}

node {
    stage("checkout") {
        println "Checking out...."
        git url: 'https://github.com/balapkm/interface.git'

        println "Get last commit changes.."
        CMD = generateCMDForServer()

    }

    stage("last-changes") {
         println "$CMD"
    }

    stage("Move to server") {
        println "$CMD"
        /*if(CMD != ""){
            sshagent(credentials : ['Balakumaran']) {
                sh "$CMD"
            }
        }*/
    }
}