## Procedure-local Bugs of Resource Leaks

**CSharpCodeAnalyzer** is able to detect resource leaks which include the C# scenarios outlined below. For further detail on its capabilities, see [here](http://www.eecs.qmul.ac.uk/~ddino/papers/nasa-infer.pdf). 

## Supported scenarios

### 1. Deallocation of IDisposable Local Variables: 

Instances of classes deriving from IDisposable (such as input streams, output streams, http connections, and cursors) create resource leaks if they are not closed or disposed of.

```c#
public void ResourceLeakBad(){
    StreamReader sr = new StreamReader("whatever.txt");  
    string data = sr.ReadToEnd();
    Console.WriteLine(data);
    // FIXME: should close the stream by calling sr.Close().
}
```
							
### 2. Resource Allocation in Method Invocation: 
When a resource allocation is included as an argument to a constructor/method invocation, if this constructor/method invocation fails it can leave an an unreachable resource that no one can dispose.
	
The following example 
```c#
var gzipStream = new GZipStream(new FileStream(out, FileMode.Create), CompressionMode.Compress);
```
is bad in case the outer constructor, `GZipStream`, throws an exception. In that case, no one will have a hold of the `FileStream` and so no one will be able to dispose it.
	
### 3. Resource Allocation inside libraries:
Some resources are created inside libraries instead of by "new". For instance,
```c#
ICursor cursor = SQLiteDatabase.Query(…)
```
allocates a `ICursor` resource. The `ICursor` object *cursor* created needs to be disposed (i.e., `cursor.Dispose()`).
	
### 4. Escaping Resources and Exceptions:
Sometimes you want to return a resource to the outside, in which case you should not dispose it, but you still need to be careful of exceptions in case control skips past the return leaving no one to dispose. In the following example
```c#
 public StreamWriter allocateStreamWriter() {
    FileStream fs = File.Create("everwhat.txt");
    byte[] info = new UTF8Encoding(true).GetBytes("This is some text in the file.");
    fs.Write(info, 0, info.Length);
    return new StreamWriter(fs);
}
```
if `fs.Write(info, 0, info.Length);` throws an exception, then no one will have a hold of `FileStream` *fs*, and no one will be able to close it.
