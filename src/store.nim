import os
import strtabs
import streams
import marshal
import oids
import tables

const dbFileName = "dbfile"
let dbFileFullPath = getAppDir() / dbFileName

type DirStash = object
  stack: seq[string]

proc initDirStash(): DirStash = 
  result = DirStash(stack: @[])

proc saveStore*(data: TableRef[string, DirStash]) =
  let dbFile = newFileStream(dbFileFullPath, fmWrite)
  defer: dbFile.close()
  store(dbFile, data)


proc loadStore*(): TableRef[string, DirStash] =
  if not existsFile(dbFileFullPath):
    result = newTable[string, DirStash]()
  else:
    let dbFile = newFileStream(dbFileFullPath, fmRead)
    defer: dbFile.close()
    load(dbFile, result);    

proc remove(data: TableRef[string, DirStash], key: string) = 
  data.del(key)

proc createStoreId*(): string = 
  let storeId = oids.genOid();
  result = $storeId

proc push*(data: TableRef[string, DirStash], key, value: string) = 
  if not data.contains(key): 
    data[key] = initDirStash()
  data[key].stack.add(value)

proc pop*(data: TableRef[string, DirStash], key: string): string = 
  result = data[key].stack.pop()
  if data[key].stack.len()==0: data.remove(key)

proc contains*(data: TableRef[string, DirStash], key: string): bool = 
  result = data.hasKey(key)

proc list*(data: TableRef[string, DirStash], key: string): seq[string] = 
  if data.contains(key): 
    result = data[key].stack
  else:
    result = @["not stashed"]
