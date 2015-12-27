import os
import streams
import marshal

const 
  fileName = "config.json"

let fileNameFull = getAppDir() / fileName

type
  Config* = object
    storePath*: string

proc loadConfig*(): ref Config = 
  if existsFile(fileNameFull):
    let configFile = newFileStream(fileNameFull, fmRead)
    defer: configFile.close()
    var config: Config
    load(configFile, config);
    new(result)
    result[] = config
