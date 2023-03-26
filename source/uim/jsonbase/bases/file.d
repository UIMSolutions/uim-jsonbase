module uim.jsonbase.bases.file;

@safe:
import uim.jsonbase;

class DJSBFileBase : DJSBBase {
  this() {}
  this(string newRootPath) {
    this(); this.rootPath(newRootPath); }

  protected string _rootPath;
  @property O rootPath(this O)(string newRootPath) {
    _rootPath = newRootPath;

    if (_rootPath.exists) { 
      auto dirs = dirNames(newRootPath);  
      foreach(dir; dirs) {
        _tenants[dir] = JBFileTenant(newRootPath~"/"~dir);
      }}
    return cast(O)this; }
  version(test_uim_jsonbase) { unittest {
    
      auto base = JSBFileBase; }}

}
auto JSBFileBase() { return new DJSBFileBase; }
auto JSBFileBase(string newRootPath) { return JSBFileBase.rootPath(newRootPath); }