module uim.jsonbase.classes.bases.file;

@safe:
import uim.jsonbase;

class DFileJsonBase : DJsonBase {
  mixin(JsonBaseThis!("FileJsonBase"));

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
        _tenants[myDir] = FileJsonTenant(rootPath~"/"~myDir);
      }      
 */    
    }
  }

  // Create
  IJsonTenant createTenant(string aName) {
    return FileJsonTenant(aName);
  }
}
mixin(JsonBaseThis!("FileJsonBase"));
auto FileJsonBase(string newRootPath) { return FileJsonBase.rootPath(newRootPath); }

unittest {
  assert(testJsonBase(FileJsonBase));
}