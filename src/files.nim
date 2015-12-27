import os
import strutils

proc getRelative(path, basePath: string): string = 
  result = replace(path, basePath, ".")

proc moveFiles*(fromPath, toPath: string, isTest: bool = false): int =
  #echo(fromPath, " -> ", toPath)
  for file in walkDirRec(fromPath):
    var (path, name, ext) = splitFile(file)
    #echo(path, " ", name,  " ", ext)
    let relative = if(isAbsolute(path)): getRelative(path, fromPath) else: path
    let destPath = toPath / relative
    let dest = destPath / join([name, ext])
    if not existsDir(destPath):
      #echo destPath
      createDir(destPath)    
    echo dest
    copyFile(file, dest)
    inc(result)
  if not isTest: removeDir(fromPath)