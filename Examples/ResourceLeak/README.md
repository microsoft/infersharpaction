## Procedure-local Bugs of Resource Leaks

**CSharpCodeAnalyzer** is able to detect resource leaks which include the C# scenarios enumerated below. For further detail on its capabilities, see [here](http://www.eecs.qmul.ac.uk/~ddino/papers/nasa-infer.pdf). 

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
Resource leaks may occur when a resource is allocated as an argument of a method invocation (including methods which allocate resources such as constructors); should an exception occur during the method invocation, the resource will leak.	

For example, if the GZipStream constructor invocation below throws an exception, the allocated FileStream resource will leak.
```c#
var gzipStream = new GZipStream(new FileStream(out, FileMode.Create), CompressionMode.Compress);
```
	
### 3. Resource Allocation inside libraries:
Some resources are created within non-constructor methods. For example, the `Icursor` resource in the below example will leak if it is not disposed.
```c#
ICursor cursor = SQLiteDatabase.Query(…)
```
	
### 4. Escaping Resources and Exceptions:
Resources may leak should the control flow short-circuit past a method's return statement. In the below example, if
`fs.Write(info, 0, info.Length);` throws an exception, *fs* will leak.
```c#
 public StreamWriter allocateStreamWriter() {
    FileStream fs = File.Create("everwhat.txt");
    byte[] info = new UTF8Encoding(true).GetBytes("This is some text in the file.");
    fs.Write(info, 0, info.Length);
    return new StreamWriter(fs);
}
```
