import os
import strutils
import store
import config
import files

let currDir = getCurrentDir()

let cfg = loadConfig()
if cfg == nil:
  quit "config not found"
  
let dataStore = loadStore()

let params = commandLineParams()

var isTest = false

if params.len()>0:
  case params[0] 
    of "-list":
      echo dataStore.list(currDir)
      quit()
    of "-test":
      isTest = true
    else: discard

if dataStore.contains(currDir):
  quit "folder stashed already"

let storeId = createStoreId()
let storeDir = cfg.storePath / storeId
createDir(storeDir)

let filesCount = moveFiles(".", storeDir, isTest)

dataStore.push(currDir, storeDir)
dataStore.saveStore()

echo "stashed $1 files" % [$filesCount]
