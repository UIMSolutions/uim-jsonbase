module uim.jsonbase.collections.null_;

@safe:
import uim.jsonbase;

class DJSBNullCollection : DJSBCollection {
  this() { super();  }
  
  // #region FindMany
  alias findMany = DJSBCollection.findMany;
  /// Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
  override Json[] findMany(bool allVersions = false) { return null; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;    
      // Results always null / []
      assert(!col.findMany); 
      assert(!col.findMany(true)); }}

  /// Find all (many) items in a collection with id. allVersions:false = find last version, allVersion:true = find all versions
  override Json[] findMany(UUID id, bool allVersions = false) { return null; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(!col.findMany(randomUUID)); 
      assert(!col.findMany(randomUUID, true)); 
      // TODO 
      }}

  override Json[] findMany(STRINGAA select, bool allVersions = false) { return null; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(!col.findMany(["name":"aName"])); 
      assert(!col.findMany(["name":"aName"], true)); 
      // TODO 
      }}

  override Json[] findMany(Json select, bool allVersions = false) { return null; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(!col.findMany(toJson(["name":"aName"]))); 
      assert(!col.findMany(toJson(["name":"aName"]), true)); 
      // TODO 
      }}
  // #endregion findMany

  // #region findOne
  alias findOne = DJSBCollection.findOne;
  override Json findOne(UUID id, bool allVersions = false) { return Json(null); }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.findOne(randomUUID) == Json(null));
      assert(col.findOne(randomUUID, true) == Json(null)); 
      // TODO 
      }}

  override Json findOne(UUID id, size_t versionNumber) { return Json(null); }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.findOne(randomUUID, 1) == Json(null));
      // TODO 
      }}

  override Json findOne(STRINGAA select, bool allVersions = false) { return Json(null); }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.findOne(["name":"aName"]) == Json(null));
      assert(col.findOne(["name":"aName"], true) == Json(null));
      // TODO 
      }}

  override Json findOne(Json select, bool allVersions = false) { return Json(null); }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.findOne(toJson(["name":"aName"])) == Json(null));
      assert(col.findOne(toJson(["name":"aName"]), true) == Json(null));
      // TODO 
      }}
  // #endregion findOne

  // #region insertOne
  override Json insertOne(Json newData) { return findOne(newData); }  
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.insertOne(toJson(["name":"aName"])) == Json(null));
      // TODO 
      }}
  // #endregion insertOne

  // #region updateMany
  override size_t updateMany(Json select, Json updateData) { return 0; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.updateMany(toJson(["id":randomUUID.toString]), toJson(["name":"aName"])) == 0); 
      // TODO
      }}
  // #endregion updateMany

  // #region updateOne
  override bool updateOne(Json select, Json updateData) { return false; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.updateOne(toJson(["id":randomUUID.toString]), toJson(["name":"aName"])) == 0); 
      // TODO
      }}
  // #endregion updateOne

  // #region removeMany
  /// Remove items from collections
  alias removeMany = DJSBCollection.removeMany;
  /// Remove items from collectionsby it. allVersions:false - remove lastVersion, allVersion:true / allVersions (complete)
  override size_t removeMany(UUID id, bool allVersions = false) { return 0; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.removeMany(randomUUID) == 0);
      assert(col.removeMany(randomUUID, true) == 0);
      // TODO
      }}

  override size_t removeMany(STRINGAA select, bool allVersions = false) { return 0; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.removeMany(["name":"aName"]) == 0);
      assert(col.removeMany(["name":"aName"], true) == 0);
      // TODO
      }}

  override size_t removeMany(Json select, bool allVersions = false) { return 0; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(col.removeMany(toJson(["name":"aName"])) == 0);
      assert(col.removeMany(toJson(["name":"aName"]), true) == 0);
      // TODO
      }}
  // #endregion removeMany

  /// Remove one item or one version from collection
  alias removeOne = DJSBCollection.removeOne;
  /// Remove based on id - allVersions:true - remove all, remove lastVersion 
  override bool removeOne(UUID id, bool allVersions = false) { return false; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(!col.removeOne(randomUUID));
      assert(!col.removeOne(randomUUID, true));
      // TODO
      }}

  override bool removeOne(UUID id, size_t versionNumber) { return false; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(!col.removeOne(randomUUID, 1));
      // TODO
      }}

  override bool removeOne(STRINGAA select, bool allVersions = false) { return false; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(!col.removeOne(["name": "aName"]));
      assert(!col.removeOne(["name": "aName"], true));
      // TODO
      }}

  override bool removeOne(Json select, bool allVersions = false) { return false; }
  version(test_uim_jsonbase) { unittest {
    
      auto col = JSBNullCollection;
      assert(!col.removeOne(toJson(["name": "aName"])));
      assert(!col.removeOne(toJson(["name": "aName"]), true));
      // TODO
      }}
}
auto JSBNullCollection() { return new DJSBNullCollection;  }