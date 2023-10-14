module uim.jsonbase.classes.collections.file;

@safe:
import uim.jsonbase;

class DFileJsonCollection : DJsonCollection {
  mixin(JsonCollectionThis!("FileJsonCollection"));
  this(IFolder aFolder) { this(); folder(aFolder); }
  
  mixin(TProperty!("IFolder", "folder"));

  // find many items 
  alias findMany = DJsonCollection.findMany;

  // Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
  override Json[] findMany(bool allVersions = false) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
        
    if (!folder || !folder.exists) { return null; }    
    debug writeln(moduleName!DJsonCollection~" - DJsonCollection::findMany(bool allVersions) - Path exists");

    auto ids = folder.folders.map!(f => folder.name).filter!(id => id.isUUID).array; // get all valid ids
    debug writeln(moduleName!DJsonCollection~" - DJsonCollection::findMany(1) - Found ids = ", ids.length);

    return ids.map!(id => findMany(UUID(id), allVersions)).join();
  }

  /// Find all (many) items in a collection with id. allVersions:false = find last version, allVersion:true = find all versions
  override Json[] findMany(UUID anId, bool allVersions = false) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    if (!folder || !folder.exists) { return null; }  

    auto idFolder = folder.folder(anId);
    if (idFolder is null) { return null; }  

    auto versionJsons = loadJsonsFromDirectory(idFolder.absolutePath);
    if (versionJsons.isEmpty)  { return null; }

    return allVersions ? versionJsons : [lastVersion(versionJsons)]; 
  }

  override Json[] findMany(STRINGAA select, bool allVersions = false) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    return super.findMany(select, allVersions); 
  }

  /// find items by select - allVersions:false - last versions; allVersions:true - all versions
  override Json[] findMany(Json select, bool allVersions = false) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    return super.findMany(select, allVersions); 
  }

  /// find one item 
  alias findOne = DJsonCollection.findOne;

  /// Find one item in a collection. allVersions:false = last version, allVersion:true = one version
  override Json findOne(UUID id, bool allVersions = false) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    if (!folder || !folder.exists) { return Json(null); }  

    auto myIdFolder = idFolder(folder, id);
    if (myIdFolder is null) { return Json(null); }  

    auto versionJsons = loadJsonsFromDirectory(myIdFolder.absolutePath);
    if (versionJsons.isEmpty)  { return null; }

    return allVersions ? versionJsons[0] : lastVersion(versionJsons); 
  }

  override Json findOne(UUID anId, size_t versionNumber) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    if (!folder || !folder.exists) { return Json(null); } 

    auto myIdFolder = idFolder(folder, anId);
    if (myIdFolder is null) { return Json(null); }  

    auto versionFile = myIdFolder.file(to!string(versionNumber));
    if (versionFile is null) { return Json(null); }  

    return loadJson(versionFile.absolutePath); 
  }

  override Json findOne(STRINGAA select, bool allVersions = false) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    if (!folder || !folder.exists) { return Json(null); }

    if (allVersions) {
      auto jsons = findMany(select, allVersions);
      return jsons ? jsons[0] : Json(null); 
    } 

    if ("id" !in select) { return Json(null); } 
    auto myId = UUID(select["id"]);

    auto myIdFolder = idFolder(folder, myId);
    if (myIdFolder is null) { return Json(null); }  

    auto result = Json(null); 
    if (!folder || !folder.exists) { return Json(null); } 

    return ("versionNumber" !in select 
      ? findOne(UUID(select["id"]), allVersions)
      : findOne(UUID(select["id"]), to!size_t(select["versionNumber"]))); 
  }

  override Json findOne(Json select, bool allVersions = false) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    if (!folder || !folder.exists) { return Json(null); }

    if (allVersions) {
      auto jsons = findMany(select, allVersions);
      return jsons ? jsons[0] : Json(null); 
    }
    if ("id" !in select) { return Json(null); }

    auto idFolder = folder.folder(id);
    if (idFolder is null) { return Json(null); }  

    if ("versionNumber" !in select) { return Json(null); }

    auto versionFile = folder.file(to!string(versionNumber));
    if (versionFile is null) { return Json(null); }  

    return versionFile.content;
  }

  /// insert one item 
  alias insertOne = DJsonCollection.insertOne;

  override Json insertOne(Json newData) {
    if (!folder || !folder.exists) { return Json(null); }

    if (newData == Json(null)) return Json(null);
    if ("id" !in newData) newData["id"] = randomUUID.toString;
    if ("versionNumber" !in newData) newData["versionNumber"] = 1;

    folder.createFolder(newData["id"].get!string);
    if (idFolder is null) { return Json(null); }  
    
    auto result = Json(null); 


    auto pathToId = dirPath(path, newData);
    if (!pathToId.exists) pathToId.mkdir;

    auto pathToVersion = filePath(path, newData);
    std.file.write(pathToVersion, newData.toString);
    return findOne(newData); }  
  version(test_uim_jsonbase) { unittest {
    
      auto col = FileJsonCollection("./tests");
      assert(test_insertOne_data(col));
    }
  }

  override size_t updateMany(STRINGAA select, STRINGAA updateData) {
    if (!folder || !folder.exists) { return 0; }  

    auto jsons = findMany(select); 
    foreach(json; jsons) {
      foreach(kv; updateData.byKeyValue) {
        if (kv.key == "id") continue;
        if (kv.key == "versionNumber") continue;

        json[kv.key] = kv.value; }
      std.file.write(filePath(path, json, pathSeparator), json.toString);
    }
    return jsons.length; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = FileJsonCollection("./tests");
      assert(test_updateMany_select_data(col));
    }
  }

  override size_t updateMany(Json select, Json updateData) {
    if (!folder || !folder.exists) { return 0; }  

    auto jsons = findMany(select); 
    foreach(json; jsons) {
      foreach(kv; updateData.byKeyValue) {
        if (kv.key == "id") continue;
        if (kv.key == "versionNumber") continue;

        json[kv.key] = kv.value; }
      std.file.write(filePath(path, json, pathSeparator), json.toString);
    }
    return jsons.length; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = FileJsonCollection("./tests");
      assert(test_updateMany_select_data(col));
    }
  }

  override bool updateOne(Json select, Json updateData) {
    if (!folder || !folder.exists) { return false; }  

    auto json = findOne(select);
    if (json == Json(null)) return false;

    updateData.byKeyValue.each!(kv => json[kv.key] = kv.value);
    std.file.write(filePath(path, json, pathSeparator), json.toString);

    return true; 
  }

  /// Remove items from collections
  alias removeMany = DJsonCollection.removeMany;
  /// Remove items from collectionsby it. allVersions:false - remove lastVersion, allVersion:true / allVersions (complete)
  override size_t removeMany(UUID id, bool allVersions = false) {
    if (!folder || !folder.exists) { return 0; }  

    size_t counter;
    foreach(item; findMany(id, allVersions)) {
      counter++; 
      removeOne(item, allVersions); }

    return counter; 
  }

  override size_t removeMany(STRINGAA select, bool allVersions = false) {
    if (select.isEmpty) { return 0; }

    size_t counter;
    findMany(select, allVersions).each!(json => counter += removeOne(json, allVersions));
    
    return counter; 
  }

  override size_t removeMany(Json select, bool allVersions = false) {
    if (!folder || !folder.exists) { return 0; }  

    size_t counter;
    findMany(select, allVersions).each!(json => counter += removeOne(json, allVersions));

    return counter;
  }

  /// Remove one item or one version from collection
  alias removeOne = DJsonCollection.removeOne;
  /// Remove one item from collection
  override bool removeOne(UUID id, bool allVersions = false) {
    if (!folder || !folder.exists) { return false; }  

    auto json = findOne(id, allVersions); 
    if (json == Json(null)) { return false; }

    auto jPath = filePath(path, json, pathSeparator);
    jPath.remove;

    return !jPath.exists; 
  }

  override bool removeOne(UUID anId, size_t versionNumber = 0) {
    // Get folder with version files
    auto myIdFolder = idFolder(folder, anId);
    if (myIdFolder is null) { return false; }

    // Get a file with selected version or the current version (versionNumber is empty or "*")  
    auto myVersionFile = versionFile(folder, myId, myVersionNumber);
    if (myVersionFile is null) { return false; }

    versionFile.delete_;
    if (myIdFolder.empty) idFolder.delete_;
        
    return (!versionFile.exists); 
  } 

  override bool removeOne(STRINGAA select, bool allVersions = false) {
    if (select.isEmpty) { return Json(null); }

    if (allVersions) { 
      auto myJson = findOne(select, allVersions); 
      if (myJson == Json(null)) { return false; } 
      
      return removeOne(myJson, false);
    }

    if ("id" !in select) { return false; }
    auto myId = UUID(select["id"]);

    auto myIdFolder = idFolder(folder, myId);
    if (myIdFolder is null) { return false; }

    // Has select a version number?
    auto myVersionNumber = select.get("versionNumber", null);
    
    // Get a file with selected version or the current version (versionNumber is empty or "*")  
    auto myVersionFile = versionFile(folder, myId, myVersionNumber);
    if (myVersionFile is null) { return false; }

    myVersionFile.delete_; 
    if (myIdFolder.empty) { myIdFolder.delete_; }

    return (!myVersionFile.exists);
  }

  override bool removeOne(Json select, bool allVersions = false) {
    if (select.isEmpty) { return Json(null); }

    if (allVersions) { 
      auto json = findOne(select, allVersions); 
      if (json == Json(null)) { return false; } 
      
      return removeOne(json, false);
    }

    if ("id" !in select) { return false; }
    auto myId = UUID(select["id"].get!string);

    IFolder idFolder = folder.folder(myId);
    if (idFolder is null) { return false; }

    if ("versionNumber" !in select) { return false; }
    auto versionNumber = select["versionNumber"].get!size_t;
    
    auto versionFile = idFolder(versionNumber);
    if (versionFile is null) { return false; }

    versionFile.delete_; 
    if (idFolder.empty) { idFolder.delete_; }

    return (!versionFile.exists);
  }
}
mixin(JsonCollectionCalls!("FileJsonCollection"));

unittest {
  assert(testJsonCollection(FileJsonCollection));
}