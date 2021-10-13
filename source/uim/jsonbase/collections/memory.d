module uim.jsonbase.collections.memory;

@safe:
import uim.jsonbase;

class DJDBMemCollection : DJDBCollection {
  this() { super();  }
  
  protected Json[size_t][UUID] _colItems;
  
  protected string _pathSeparator = "/";
  @property auto pathSeparator() { return _pathSeparator; } 

  protected bool _pathExists;
  @property auto pathExists() { return _pathExists; } 

  protected string _path;
  @property auto path() { return _path; } 
  @property void path(string newPath) {
    _pathExists = newPath.exists && newPath.isDir;
    _path = pathExists ? newPath : ""; } 


  alias findMany = DJDBCollection.findMany;
  /// Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
  override Json[] findMany(bool allVersions = false) {
    Json[] results;
    if (!pathExists) return results;

    auto Ids = dirNames(path, false);    
    foreach(id; Ids) {
      if (id.isUUID) results ~= findMany(UUID(id), allVersions);
    }
    return results; }
  unittest {
    version(uim_jsonbase) {
      auto col = JDBMemCollection;
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
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  override Json[] findMany(STRINGAA select, bool allVersions = false) {
    return super.findMany(select, allVersions); }
  unittest {
    version(uim_jsonbase) {
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  override Json[] findMany(Json select, bool allVersions = false) {
    return super.findMany(select, allVersions); }
  unittest {
    version(uim_jsonbase) {
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  alias findOne = DJDBCollection.findOne;
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
      auto col = JDBMemCollection;
      /// TODO
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
      auto col = JDBMemCollection;
      /// TODO
    }
  }

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
      auto col = JDBMemCollection;
      /// TODO
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
      auto col = JDBMemCollection;
      /// TODO
    }
  }

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
      auto col = JDBMemCollection;
      /// TODO
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
      auto col = JDBMemCollection;
      /// TODO
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
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  alias removeMany = DJDBCollection.removeMany;
  override size_t removeMany(UUID id, bool allVersions = false) {
    if (!pathExists) return 0;

    size_t counter;
    foreach(json; findMany(id, allVersions)) counter += removeOne(json, allVersions);
    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  override size_t removeMany(UUID id, size_t versionNumber) {
    if (!pathExists) return 0;

    auto pathToId = dirPath(path, id, pathSeparator);
    if (!pathToId.exists) return 0;

    auto pathToVersion = filePath(path, toJson(id, versionNumber), pathSeparator);
    if (!pathToVersion.exists) return 0;

    pathToVersion.remove;
    if (fileNames(pathToId, true).empty) pathToId.remove;
    return (!pathToVersion.exists ? 1 : 0); } 
  unittest {
    version(uim_jsonbase) {
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  override size_t removeMany(STRINGAA select, bool allVersions = false) {
    if (!pathExists) return 0;

    size_t counter;
    foreach(json; findMany(select, allVersions)) counter += removeOne(json, allVersions);
    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  override size_t removeMany(Json select, bool allVersions = false) {
    if (!pathExists) return 0;

    size_t counter;
    foreach(json; findMany(select, allVersions)) counter += removeOne(json, allVersions);
    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JDBMemCollection;
      /// TODO
    }
  }

  alias removeOne = DJDBCollection.removeOne;
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
      auto col = JDBMemCollection;
      /// TODO
    }
  }

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
      auto col = JDBMemCollection;
      /// TODO
    }
  }

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
      auto col = JDBMemCollection;
      auto data = ["id": randomUUID.toString, "versionNumber":"10"];
/*       auto json = col.insertOne(data);
      assert(col.removeOne(data));
 */    }
  }

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
      auto col = JDBMemCollection;
      auto json = col.insertOne(toJson(randomUUID, 10));
      assert(col.removeOne(json));

      json = col.insertOne(toJson(randomUUID));
      assert(col.removeOne(UUID(json["id"].get!string)));
    }
  }
}
auto JDBMemCollection() { return new DJDBMemCollection;  }