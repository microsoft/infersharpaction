## Procedure-local Bugs of Resource Leaks

**CSharpCodeAnalyzer** is designed to detect this kind of resource leaks by applying the following principle: **When a new object is allocated during the execution of a procedure, it is the procedure’s responsibility to either deallocate the object or make it available to its callers; there is no such obligation for objects received from the caller.** 

Based on the nature of procedure-local bugs of resource leaks, **CSharpCodeAnalyzer** is capable of detecting resource leaks in the following scenarios that are unrelated to multi-threading:

## Supported scenarios

### 1. Standard idioms: 

Some objects in C#, the resources, are supposed to be disposed when you stop using them, and failure to dispose is a resource leak. Resources include input streams, output streams, readers, writers, sockets, http connections, cursors, json parsers, etc. The following code snippet shows a *ReaderStream* object is created and disposed. 

```c#
public void ResourceLeakIntraproceduralOK(){
    string data;
    StreamReader sr = new StreamReader("whatever.txt");            
    data = sr.ReadToEnd();
    sr.Close();
}
```
							
### 2. Nested allocations: 
When a resource allocation is included as an argument to a constructor, if the constructor fails it can leave an an unreachable resource that no one can dispose.
	
The following example 
```c#
var gzipStream = new GZipStream(new FileStream(out, FileMode.Create), CompressionMode.Compress);
```
is bad in case the outer constructor, *GZipStream*, throws an exception. In that case, no one will have a hold of the *FileStream* and so no one will be able to dispose it.
	
### 3. Allocation of Cursor resources:
Some resources are created insider libraries instead of by "new". For instance, in the functions from 
```c#
ICursor cursor = SQLiteDatabase.Query(…)
```
or 
```c#
ICursor cursor = SQLiteDatabase.RawQuery(…)
```
allocates a ICursor resource. The ICursor object *cursor* created needs to be disposed (i.e., cursor.Dispose()).
	
### 4. Escaping resources and exceptions:
Sometimes you want to return a resource to the outside, in which case you should not dispose it, but you still need to be careful of exceptions in case control skips past the return leaving no one to dispose. This simple example
```c#
public GZipStream allocateGzipStream() {
    FileStream compressedFileStream = File.Create("whatever.gz");
    return new GZipStream(compressedFileStream, CompressionMode.Compress);
}
```
shows a positive use of escaping resources.
