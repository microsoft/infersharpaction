## Procedure-local Bugs of Resource Leaks

A simple example of **procedure-local bug of resource leak** is a resource leak in the context of incomplete code (e.g. without main) with inter-procedural reasoning. In this case, the usual notion that all resource allocated must be eventually freed does not apply in the context of incomplete code. **CSharpCodeAnalyzer** is designed to detect this kind of resource leaks by applying the following principle: **When a new object is allocated during the execution of a procedure, it is the procedure’s responsibility to either deallocate the object or make it available to its callers; there is no such obligation for objects received from the caller.** 

Based on the nature of procedure-local bugs of resource leaks, **CSharpCodeAnalyzer** is capable of detecting resource leaks in the following scenarios that are unrelated to multi-threading:

### 1. Standard idioms: 

Some objects in C#, the resources, are supposed to be disposed when you stop using them, and failure to dispose is a resource leak. Resources include input streams, output streams, readers, writers, sockets, http connections, cursors, json parsers, etc.
							
### 2. Nested allocations: 
When a resource allocation is included as an argument to a constructor, if the constructor fails it can leave an an unreachable resource that no one can dispose.
	
For example *gzipStream = new GZipStream(new FileStream(out, FileMode.Create), CompressionMode.Compress);* is bad in case the outer constructor, *GZipStream*, throws an exception. In that case, no one will have a hold of the *FileStream* and so no one will be able to dispose it.
	
### 3. Allocation of Cursor resources:
Some resources are created insider libraries instead of by "new". For instance, in the functions from *SQLiteDatabase.Query(…)* and *RawQuery(…)* allocate a Cursor resource. For *SQLiteQueryBuilder.Query(…)*, *ContentProviderClient.Query(…)*, and *ContentResolver.Query(…)*, the Cursor objects cursor created by these functions need to be disposed (i.e., cursor.Dispose()).
	
### 4. Escaping resources and exceptions:
Sometimes you want to return a resource to the outside, in which case you should not dispose it, but you still need to be careful of exceptions in case control skips past the return leaving no one to dispose. Here is a simple example of a positive use of escaping resources. Such as an example shown in the following code snippet.
	
```c#
public GZipStream allocateGzipStream() {
    FileStream compressedFileStream = File.Create("whatever.gz");
    return new GZipStream(compressedFileStream, CompressionMode.Compress);
}
```
	
