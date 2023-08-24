module uim.jsonbase.classes.bases.file;

@safe:
import uim.jsonbase;

class DJSBFileBase : DJSBBase {
  this() {}
  this(string newRootPath) {
    this(); this.rootPath(newRootPath); 
  }

  mixin(TProperty!("string", "rootPath"));

  void load() {
    IFilesystem myFilesystem;
    version(Windows) {
      myFilesystem = WindowsFilesystem;
    }
    version(linux) {
      myFilesystem = LinuxFilesystem;
    }

    if (auto rootFolder = myFilesystem.folder(rootPath)) {
      auto folders = rootFolder.folders;
      folders.each!(f => writeln(f.name));
/*       auto dirs = dirNames(rootPath);  
      debug writeln(__MODULE__~" - found dirs ", dirs);

      foreach(myDir; dirs) {
        debug writeln(__MODULE__~" - Read "~myDir);
        _tenants[myDir] = JBFileTenant(rootPath~"/"~myDir);
      }      
 */    
    }
  }
}
auto JSBFileBase() { return new DJSBFileBase; }
auto JSBFileBase(string newRootPath) { return JSBFileBase.rootPath(newRootPath); }

unittest {
   IFilesystem myFilesystem;
    version(Windows) {
      myFilesystem = WindowsFilesystem;
    }
    version(linux) {
      myFilesystem = LinuxFilesystem;
    }

    if (auto rootFolder = myFilesystem.folder(".")) {
      auto folders = rootFolder.folders;
      folders.each!(f => writeln(f.name));
    }
}