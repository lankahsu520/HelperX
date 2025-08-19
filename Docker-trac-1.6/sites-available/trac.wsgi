import os
import sys

#sys.path.insert(0, '/usr/local/lib/python3.8/dist-packages') 

# for single project
os.environ['TRAC_ENV'] = '/var/trac'

# for multi projects
#os.environ['TRAC_ENV_PARENT_DIR'] = '/var/trac'

os.environ['PYTHON_EGG_CACHE'] = '/tmp'

import trac.web.main
application = trac.web.main.dispatch_request
