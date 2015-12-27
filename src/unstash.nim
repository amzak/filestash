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

if not dataStore.contains(currDir):
  quit "folder not stashed"

let storeDir = dataStore.pop(currDir)

let filesCount = moveFiles(storeDir, ".")

dataStore.saveStore()

echo "unstashed $1 files" % [$filesCount]