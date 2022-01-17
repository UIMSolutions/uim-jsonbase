module uim.jsonbase.collections.file;

@safe:
import uim.jsonbase;

class DJSBFileCollection : DJSBCollection {
  this() { super();  }
  this(string newPath) { this().path(newPath); }
  
  protected string _pathSeparator = "/";
  @property auto pathSeparator() { return _pathSeparator; } 

  protected bool _pathExists;
  @property auto pathExists() { return _pathExists; } 

  protected string _path;
  @property auto path() { return _path; } 
  @property void path(string newPath) {
    _pathExists = newPath.exists && newPath.isDir;
    _path = pathExists ? newPath : ""; } 


  /// find many items 
  alias findMany = DJSBCollection.findMany;
  /// Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
  override Json[] findMany(bool allVersions = false) {
    // debug writeln(moduleName!DJSBCollection~":DJSBCollection::findMany(1)");
    Json[] results;
    if (!pathExists) return results;
    // debug writeln(moduleName!DJSBCollection~":DJSBCollection::findMany(1) - Path existst");

    auto ids = dirNames(path, false);    
    // debug writeln(moduleName!DJSBCollection~":DJSBCollection::findMany(1) - Found ids = ", ids.length);

    foreach(id; ids) {
      if (id.isUUID) results ~= findMany(UUID(id), allVersions);
    }
    return results; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findMany(col));
      assert(test_findMany_allVersions(col));
    }
  }

  /// Find all (many) items in a collection with id. allVersions:false = find last version, allVersion:true = find all versions
  override Json[] findMany(UUID id, bool allVersions = false) {
    Json[] results;

    if (pathExists) {   
      const pathToId = dirPath(path, id);
      if (!pathToId.exists) return null; 

      auto versions = loadJsonsFromDirectory(pathToId);
      if (versions) results = allVersions ? versions : [lastVersion(versions)]; 
      else results = null; }

    /* foreach(j; results) 
      if (j != Json(null) && "name" in j) 
        debug std.stdio.write(j["name"].get!string, "\t"); */
    return results; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findMany_id(col));
      assert(test_findMany_id_allVersions(col));
    }
  }

  override Json[] findMany(STRINGAA select, bool allVersions = false) {
    return super.findMany(select, allVersions); }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findMany_select(col));
      assert(test_findMany_select_allVersions(col));
    }
  }

  /// find items by select - allVersions:false - last versions; allVersions:true - all versions
  override Json[] findMany(Json select, bool allVersions = false) {
    return super.findMany(select, allVersions); }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findMany_jselect(col));
      assert(test_findMany_jselect_allVersions(col));
    }
  }

  /// find one item 
  alias findOne = DJSBCollection.findOne;
  /// Find one item in a collection. allVersions:false = last version, allVersion:true = one version
  override Json findOne(UUID id, bool allVersions = false) {
    auto result = Json(null); 

    if (pathExists) {
      auto pathToId = dirPath(path, id, pathSeparator);
      if (pathToId.exists) {
        auto allEntityVersions = loadJsonsFromDirectory(pathToId);
        if (allEntityVersions.empty) return Json(null); 
        
        result = allVersions ? allEntityVersions[0] : lastVersion(allEntityVersions); }}

    return result; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findOne_id(col));
      assert(test_findOne_id_allVersions(col));
    }
  }

  override Json findOne(UUID id, size_t versionNumber) {
    auto result = Json(null); 

    if (pathExists) {      
      auto pathToId = dirPath(path, id, pathSeparator);
      if (pathToId.exists) {
        auto pathToVersion = filePath(path, toJson(id, versionNumber), pathSeparator);
        if (!pathToVersion.exists) return Json(null); 
        result = loadJson(pathToVersion); }}

    return result; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findOne_id_versionNumber(col)); }}

  override Json findOne(STRINGAA select, bool allVersions = false) {
    auto result = Json(null); 

    if (pathExists) {    
      if ("id" in select) {
        if ("versionNumber" !in select) return findOne(UUID(select["id"]), allVersions);
        else return findOne(UUID(select["id"]), to!size_t(select["versionNumber"])); }

      auto jsons = findMany(select, allVersions);
      result = jsons ? jsons[0] : Json(null); }

    return result; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findOne_select(col));
      assert(test_findOne_select_allVersions(col));
    }
  }

  override Json findOne(Json select, bool allVersions = false) {
    auto result = Json(null); 

    if (pathExists) {
      if ("id" in select) {
        if ("versionNumber" !in select) return findOne(UUID(select["id"].get!string), allVersions);
        else return findOne(UUID(select["id"].get!string), select["versionNumber"].get!size_t); }

      auto jsons = findMany(select, allVersions);
      result = jsons ? jsons[0] : Json(null); }

    return result; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_findOne_jselect(col));
      assert(test_findOne_jselect_allVersions(col));
    }
  }

  /// find one item 
  alias insertOne = DJSBCollection.insertOne;
  override Json insertOne(Json newData) {
    auto result = Json(null); 

    if (newData == Json(null)) return result;
    if ("id" !in newData) newData["id"] = randomUUID.toString;
    if ("versionNumber" !in newData) newData["versionNumber"] = 1;

    auto pathToId = dirPath(path, newData);
    if (!pathToId.exists) pathToId.mkdir;

    auto pathToVersion = filePath(path, newData);
    std.file.write(pathToVersion, newData.toString);
    return findOne(newData); }  
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_insertOne_data(col));
    }
  }

  override size_t updateMany(STRINGAA select, STRINGAA updateData) {
    if (!pathExists) return 0;

    auto jsons = findMany(select); 
    foreach(json; jsons) {
      foreach(kv; updateData.byKeyValue) {
        if (kv.key == "id") continue;
        if (kv.key == "versionNumber") continue;

        json[kv.key] = kv.value; }
      std.file.write(filePath(path, json, pathSeparator), json.toString);
    }
    return jsons.length; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_updateMany_select_data(col));
    }
  }

  override size_t updateMany(Json select, Json updateData) {
    if (!pathExists) return 0;

    auto jsons = findMany(select); 
    foreach(json; jsons) {
      foreach(kv; updateData.byKeyValue) {
        if (kv.key == "id") continue;
        if (kv.key == "versionNumber") continue;

        json[kv.key] = kv.value; }
      std.file.write(filePath(path, json, pathSeparator), json.toString);
    }
    return jsons.length; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_updateMany_select_data(col));
    }
  }

  override bool updateOne(Json select, Json updateData) {
    if (!pathExists) return false;

    auto json = findOne(select);
    if (json == Json(null)) return false;

    foreach(kv; updateData.byKeyValue) json[kv.key] = kv.value;  
    std.file.write(filePath(path, json, pathSeparator), json.toString);
    return true; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_updateOne_select_data(col));
    }
  }

  /// Remove items from collections
  alias removeMany = DJSBCollection.removeMany;
  /// Remove items from collectionsby it. allVersions:false - remove lastVersion, allVersion:true / allVersions (complete)
  override size_t removeMany(UUID id, bool allVersions = false) {
    if (!pathExists) return 0;

    size_t counter;
    foreach(item; findMany(id, allVersions)) {
      counter++; 
      removeOne(item, allVersions); }

    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_removeMany_id(col));
      assert(test_removeMany_id_allVersions(col)); }}

  override size_t removeMany(STRINGAA select, bool allVersions = false) {
    if (!pathExists) return 0;

    size_t counter;
    foreach(json; findMany(select, allVersions)) counter += removeOne(json, allVersions);
    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_removeMany_select(col));
      assert(test_removeMany_select_allVersions(col));
    }
  }

  override size_t removeMany(Json select, bool allVersions = false) {
    if (!pathExists) return 0;

    size_t counter;
    foreach(json; findMany(select, allVersions)) counter += removeOne(json, allVersions);
    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_removeMany_jselect(col));
      assert(test_removeMany_jselect_allVersions(col));
    }
  }

  /// Remove one item or one version from collection
  alias removeOne = DJSBCollection.removeOne;
  /// Remove one item from collection
  override bool removeOne(UUID id, bool allVersions = false) {
    if (!pathExists) return false;

    auto json = findOne(id, allVersions); 
    if (json != Json(null)) {
      auto jPath = filePath(path, json, pathSeparator);
      jPath.remove;
      return !jPath.exists; }

    return false; } 
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_removeOne_id(col));
      assert(test_removeOne_id_allVersions(col)); }}

  override bool removeOne(UUID id, size_t versionNumber) {
    if (!pathExists) return false;

    auto pathToId = dirPath(path, id, pathSeparator);
    if (!pathToId.exists) return false;

    auto pathToVersion = filePath(path, id, versionNumber, pathSeparator);
    if (!pathToId.exists) return false;

    pathToVersion.remove;
    if (fileNames(pathToId, true).empty) pathToId.remove;
    return (!pathToVersion.exists ? true : false); } 
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_removeOne_id_versionNumber(col)); }}

  override bool removeOne(STRINGAA select, bool allVersions = false) {
    if (!pathExists) return false;

    if ("id" in select) {
      auto id = UUID(select["id"]);
      auto pathToId = dirPath(path, id, pathSeparator);
      if (!pathToId.exists) return false;

      if ("versionNumber" in select) {
        auto versionNumber = to!size_t(select["versionNumber"]);
        auto pathToVersion = filePath(path, id, versionNumber, pathSeparator);
        if (!pathToId.exists) return false;

        pathToVersion.remove;
        if (fileNames(pathToId, true).empty) pathToId.remove;
        return (!pathToVersion.exists ? true : false); 
      }
    }
    auto json = findOne(select, allVersions); 
    if (json != Json(null)) return removeOne(json, false);
    return false; }
  unittest { 
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_removeOne_select(col));
      assert(test_removeOne_select_allVersions(col)); }}

  override bool removeOne(Json select, bool allVersions = false) {
    if (!pathExists) return false;

    if ("id" in select) {
      auto id = UUID(select["id"].get!string);
      auto pathToId = dirPath(path, id, pathSeparator);
      if (!pathToId.exists) return false;

      if ("versionNumber" in select) {
        auto versionNumber = select["versionNumber"].get!size_t;
        auto pathToVersion = filePath(path, id, versionNumber, pathSeparator);
        if (!pathToVersion.exists) return false;

        pathToVersion.remove;
        if (fileNames(pathToId, true).empty) pathToId.remove;
        return (!pathToVersion.exists ? true : false);  
      }
    }
 
    auto json = findOne(select, allVersions); 
    if (json != Json(null)) return removeOne(json, false); 
    return false; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBFileCollection("./tests");
      assert(test_removeOne_jselect(col));
      assert(test_removeOne_jselect_allVersions(col)); }}
}
auto JSBFileCollection() { return new DJSBFileCollection;  }
auto JSBFileCollection(string newPath) { return new DJSBFileCollection(newPath); }