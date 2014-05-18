import os
import datetime
import subprocess
import string
def updateBundle():
    home = os.path.expanduser("~")
    path = os.path.join(home, ".vim", "bundle")
    dirs = os.listdir( path )
    cmd  = ["git", "pull"]

    for f in dirs:
        if os.path.isdir(os.path.join(path, f )):
            if os.path.isdir(os.path.join(path, f, '.git')):
                os.chdir(os.path.join(path, f ))
                print os.path.join(path, f )
                print '\n'.join(subprocess.check_output(cmd).splitlines())




print str(datetime.datetime.today())
updateBundle()
