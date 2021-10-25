module uim.jsonbase.collections.null_;

@safe:
import uim.jsonbase;

class DJSBNullCollection : DJSBCollection {
  this() { super();  }
  
  protected Json[size_t][UUID] _items;
  
  alias findMany = DJSBCollection.findMany;
  /// Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
  override Json[] findMany(bool allVersions = false) { return null; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;    
      // Results always null / []
      assert(!col.findMany); 
      assert(!col.findMany(true)); }}

  /// Find all (many) items in a collection with id. allVersions:false = find last version, allVersion:true = find all versions
  override Json[] findMany(UUID id, bool allVersions = false) { return null; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(!col.findMany(randomUUID)); 
      assert(!col.findMany(randomUUID, true)); 
      // TODO 
      }}

  override Json[] findMany(STRINGAA select, bool allVersions = false) { return null; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(!col.findMany(["name":"aName"])); 
      assert(!col.findMany(["name":"aName"], true)); 
      // TODO 
      }}

  override Json[] findMany(Json select, bool allVersions = false) { return null; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(!col.findMany(Json(["name":"aName"]))); 
      assert(!col.findMany(Json(["name":"aName"]), true)); 
      // TODO 
      }}

  alias findOne = DJSBCollection.findOne;
  override Json findOne(UUID id, bool allVersions = false) { return Json(null); }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(col.findOne(randomUUID) == Json(null));
      assert(col.findOne(randomUUID, true) == Json(null)); 
      // TODO 
      }}

  override Json findOne(UUID id, size_t versionNumber) { return Json(null); }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(col.findOne(randomUUID, 1) == Json(null));
      // TODO 
      }}

  override Json findOne(STRINGAA select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {    
      foreach(oneItem; allItems) if (oneItem.checkVersion) return oneItem; }

    return Json(null); }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_findMany_select(col));
      assert(test_findMany_select_allVersions(col)); }}

  override Json findOne(Json select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {    
      foreach(oneItem; allItems) 
        if (oneItem.checkVersion) return oneItem; }

    return Json(null); }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_findMany_jselect(col));
      assert(test_findMany_jselect_allVersions(col)); }}

  override Json insertOne(Json newData) {
    if (newData == Json(null)) return Json(null);
    auto id = "id" in newData ? UUID(newData["id"].get!string) : randomUUID;
    auto versionNumber = "versionNumber" in newData ? newData["versionNumber"].get!size_t : 1UL;

    if (id !in _items) _items[id] = null; 
    _items[id][versionNumber] = newData; 

    return findOne(newData); }  
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_insertOne_data(col)); }}

  override size_t updateMany(Json select, Json updateData) {
    size_t updates;
    foreach(id; _items.byKey) {
      foreach(vNumber; _items[id].byKey) {
        if (!checkVersion(_items[id][vNumber], select)) continue;

        updates++;
        auto itemVersion = _items[id][vNumber];
        foreach(kv; updateData.byKeyValue) {
          if (kv.key == "id") continue;
          if (kv.key == "versionNumber") continue;

          itemVersion[kv.key] = kv.value; }
        _items[id][vNumber] = itemVersion; }}
    return updates; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_updateMany_select_data(col)); }}

  override bool updateOne(Json select, Json updateData) {
    foreach(id; _items.byKey) {
      foreach(vNumber; _items[id].byKey) {
        if (!checkVersion(_items[id][vNumber], select)) continue;

        auto json = _items[id][vNumber]; 
        foreach(kv; updateData.byKeyValue) {
          if (kv.key == "id") continue;
          if (kv.key == "versionNumber") continue;

          json[kv.key] = kv.value; }
        _items[id][vNumber] = json; 
        return true; }}
    return false; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_updateOne_select_data(col)); }}

  /// Remove items from collections
  alias removeMany = DJSBCollection.removeMany;
  /// Remove items from collectionsby it. allVersions:false - remove lastVersion, allVersion:true / allVersions (complete)
  override size_t removeMany(UUID id, bool allVersions = false) {
    size_t result = 0;
    if (id in _items) {
      auto itemsId = _items[id];
      if (allVersions) {
        result = itemsId.length;
        _items.remove(id); }
      else {
        auto lastVers = lastVersion(itemsId);
        itemsId.remove(lastVers["versionNumber"].get!size_t);
      }
    }
    return result; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_removeMany_id(col));
      assert(test_removeMany_id_allVersions(col)); }}

  override size_t removeMany(STRINGAA select, bool allVersions = false) {
    size_t counter;

    foreach(id, itemId; _items) {
      if (allVersions) {
        foreach(vNumber, item; itemId) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(vNumber); }}}
      else {
        if (auto item = lastVersion(itemId)) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(item["versionNumber"].get!size_t); }}}
        if (_items[id].empty) _items.remove(id); }
          
    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_removeMany_select(col));
      assert(test_removeMany_select_allVersions(col)); }}

  override size_t removeMany(Json select, bool allVersions = false) {
    size_t counter;

    foreach(id, itemId; _items) {
      if (allVersions) {
        foreach(vNumber, item; itemId) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(vNumber); }}}
      else {
        if (auto item = lastVersion(itemId)) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(item["versionNumber"].get!size_t); }}}
        if (_items[id].empty) _items.remove(id); }
          
    return counter; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_removeMany_jselect(col));
      assert(test_removeMany_jselect_allVersions(col)); }}

  /// Remove one item or one version from collection
  alias removeOne = DJSBCollection.removeOne;
  /// Remove based on id - allVersions:true - remove all, remove lastVersion 
  override bool removeOne(UUID id, bool allVersions = false) {
    if (id in _items) {
      if (allVersions) {
        _items.remove(id); 
        return true; }
      else {
        foreach(vNumber; _items[id].byKey) {
          _items[id].remove(vNumber);
          return true; }}
    }
    return false; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_removeOne_id(col));
      assert(test_removeOne_id_allVersions(col)); }}

  override bool removeOne(UUID id, size_t versionNumber) {
    if (auto itemsId = _items.get(id, null)) {
      if (versionNumber in itemsId) {
        _items[id].remove(versionNumber);
        return true;
        }}
    return false; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_removeOne_id_versionNumber(col)); }}

  override bool removeOne(STRINGAA select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {
      foreach(oneItem; allItems) {
        if ("id" !in oneItem) continue;
        if ("versionNumber" !in oneItem) continue;

        if (checkVersion(oneItem, select)) {
          auto id = UUID(oneItem["id"].get!string);
          auto vNumber = oneItem["versionNUmber"].get!size_t;
          auto itemsId = _items[id];
          itemsId.remove(vNumber); }
      }}
    return false; }
  unittest { 
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_removeOne_select(col));
      assert(test_removeOne_select_allVersions(col)); }}

  override bool removeOne(Json select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {
      foreach(oneItem; allItems) if (checkVersion(oneItem, select)) {
        if ("id" !in oneItem) continue;
        if ("versionNumber" !in oneItem) continue;

        if (checkVersion(oneItem, select)) {
          auto id = UUID(oneItem["id"].get!string);
          auto vNumber = oneItem["versionNUmber"].get!size_t;
          auto itemsId = _items[id];
          itemsId.remove(vNumber);
        }        
      }}
    return false; }
  unittest {
    version(uim_jsonbase) {
      auto col = JSBNullCollection;
      assert(test_removeOne_jselect(col));
      assert(test_removeOne_jselect_allVersions(col)); }}
}
auto JSBNullCollection() { return new DJSBNullCollection;  }