module uim.jsonbase.classes.tenants.file;

@safe:
import uim.jsonbase;

/// FileTenant manages FileCollections
class DJBFileTenant : DJBTenant {
  this() { super(); }
  this(string newRootPath) {
    this();
    this.rootPath(newRootPath); }

  /// Collection of existing paths
  protected string _rootPath;
  @property string rootPath() { return _rootPath; }
  @property O rootPath(this O)(string newRootPath) { 
    if (newRootPath.exists) {
      _rootPath = newRootPath; 

      auto dirs = dirNames(_rootPath);  
      foreach(dir; dirs) {
        _collections[dir] = JSBFileCollection(_rootPath~"/"~dir);
    }}

    return cast(O)this; }
}
auto JBFileTenant() { return new DJBFileTenant; }
auto JBFileTenant(string newRootPath) { return new DJBFileTenant(newRootPath); }

version(test_uim_jsonbase) { unittest {
  auto tenant = JBFileTenant("/home/oz/Documents/PROJECTS/DATABASES/uim/uim");
  tenant.rootPath("/home/oz/Documents/PROJECTS/DATABASES/uim/central");
   
  foreach(colName, col; tenant.collections) {
    writeln(colName, "\t->\t", (cast(DJSBFileCollection)col).path, "\t->\t", col.findMany.length);
  }
}}