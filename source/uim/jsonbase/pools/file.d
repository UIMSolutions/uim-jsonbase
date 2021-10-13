module uim.jsonbase.pools.file;

@safe:
import uim.jsonbase;

class DJBFilePool : DJBPool {
  this() { super(); }
  this(string newRootPath) {
    this();
    rootPath = newRootPath;
  }

  protected string _rootPath;
  @property string rootPath() { return _rootPath; }
  @property void rootPath(string newRootPath) { 
    _rootPath = newRootPath; 
    
    auto dirs = dirNames(rootPath);  
    foreach(dir; dirs) {
      _collections[dir] = JDBFileCollection(rootPath~"/"~dir); 
    }
  }
}
auto JBFilePool() { return new DJBFilePool; }
auto JBFilePool(string newRootPath) { return new DJBFilePool(newRootPath); }

unittest {
  auto pool = JBFilePool("/home/oz/Documents/PROJECTS/DATABASES/uim/uim");
  pool.rootPath("/home/oz/Documents/PROJECTS/DATABASES/uim/central");
   
  foreach(colName, col; pool.collections) {
    writeln(colName, "\t->\t", (cast(DJDBFileCollection)col).path, "\t->\t", col.findMany.length);
  }
}