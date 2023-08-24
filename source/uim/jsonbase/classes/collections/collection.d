module uim.jsonbase.classes.collections.collection;

import uim.jsonbase;

@safe:
abstract class DJsonCollection {
  this() { }

  bool has(Json entity, UUID id) {
    return "id" in entity ? entity["id"].get!string == id.toString : false; }

  bool has(Json entity, string name) {
    return "name" in entity ? entity["name"].get!string == name : false; }

  bool has(Json jsonData, size_t versionNumber = 0) {
    return (versionNumber != 0) && (jsonData["versionNumber"].get!size_t == versionNumber);
  }

/*   Json lastVersion(string colName, UUID id) { return Json(null); }
  size_t lastVersionNumber(string colName, UUID id) { return 0; }
  
  Json[] versions(string colName, UUID id) {
    return null;
  }
 */
/*   Json[] versions(Json[size_t][UUID] col, UUID id) {
    if (id !in col) return null;
    return col[id].byValue.array; }

  Json[] versions(Json[size_t] entity) { 
    return entity.byValue.array; } */

  /// Count all items in the collection with ids and versions.
  /// allVersion = true include versions; = false results in existing ids 
  size_t count(UUID[] ids, bool allVersions = false) {
    return ids.map!(a => count(a, allVersions)).sum; }

  // #region Count 
  /// Count items in the collection with id and versions.
  /// allVersion = true include versions; = false results in existing id (1 if exists, 0 if none) 
  size_t count(bool allVersions = false) {
    return findMany(allVersions).length; }

  size_t count(UUID id, bool allVersions = false) {
    return findMany(id, allVersions).length; }

  /// Count all items in the collection with ids and versionNumber.
  /// allVersion = true include versions; = false results in existing ids 
  size_t count(UUID[] ids, size_t versionNumber) {
    return ids.map!(a => count(a, versionNumber)).sum; }

  // Searching for existing id
  size_t count(UUID id, size_t versionNumber) {
    return findOne(id, versionNumber) != Json(null) ? 1 : 0; }

  // Searching for existing selects
  size_t count(STRINGAA[] selects, bool allVersions = false) {
    return selects.map!(a => count(a, allVersions)).sum; }

  // Searching based on parameter "select":string[string]
  size_t count(STRINGAA select, bool allVersions = false) {
    return findMany(select, allVersions).length; }

  // Searching for existing selects:json[]
  size_t count(Json[] selects, bool allVersions = false) {
    return selects.map!(a => count(a, allVersions)).sum; }

  // Searching based on parameter "select":Json[]
  size_t count(Json select, bool allVersions = false) {
    return findMany(select, allVersions).length; }
  // #endregion count

  // #region findMany
  // Searching in store
  abstract Json[] findMany(bool allVersions = false);

  // Searching for existing ids
  Json[] findMany(UUID[] ids, bool allVersions = false) {
    return ids.map!(a => findMany(a, allVersions)).join; }

  // Searching for existing id
  abstract Json[] findMany(UUID id, bool allVersions = false);

  // Searching for existing ids & versionNumber
  Json[] findMany(UUID[] ids, size_t versionNumber) {
    return ids.map!(a => findOne(a, versionNumber)).array; }

  // Searching for existing selects
  Json[] findMany(STRINGAA[] selects, bool allVersions = false) {
    return selects.map!(a => findMany(a, allVersions)).join; }

  /// Find all (many) items in a collection with select. allVersions:false = find last version, allVersion:true = find all versions
  Json[] findMany(STRINGAA select, bool allVersions = false) {
    Json[] results;
    foreach(json; findMany(allVersions)) if (checkVersion(json, select)) results ~= json;
    return results; }
    
  // Searching for existing selects:json[]
  Json[] findMany(Json[] selects, bool allVersions = false) {
    return selects.map!(a => findMany(a, allVersions)).join; }

  /// Find all (many) items in a collection with select. allVersions:false = find last version, allVersion:true = find all versions
  Json[] findMany(Json select, bool allVersions = false) {
    Json[] results = findMany(allVersions);
    return results.filter!(a => checkVersion(a, select)).array; }

// #region findOne
  // Searching in store
  // Searching for existing ids
  Json findOne(UUID[] ids, bool allVersions = false) {
    auto jsons = ids.map!(a => findOne(a, allVersions)).array; 
    return jsons.length > 0 ? jsons[0] : Json(null); }

  // Searching for existing id
  Json findOne(UUID id, bool allVersions = false) {
    return Json(null); }

  /// Searching for existing ids & versionNumber
  Json findOne(UUID[] ids, size_t versionNumber) {
    auto jsons = ids.map!(a => findOne(a, versionNumber)).array; 
    return jsons.length > 0 ? jsons[0] : Json(null); }

  /// Searching for existing id & number
  Json findOne(UUID id, size_t versionNumber) {
    return Json(null); }

  // Searching for existing selects
  Json findOne(STRINGAA[] selects, bool allVersions = false) {
    auto jsons = selects.map!(a => findOne(a, allVersions)).array; 
    return jsons.length > 0 ? jsons[0] : Json(null); }

  // Searching based on parameter "select":string[string]
  Json findOne(STRINGAA select, bool allVersions = false) {
    return Json(null); }

  // Searching for existing selects:json[]
  Json findOne(Json[] selects, bool allVersions = false) {
    auto jsons = selects.map!(a => findOne(a, allVersions)).array; 
    return jsons.length > 0 ? jsons[0] : Json(null); }

  /// Searching for one item with has parameters 
  Json findOne(Json select, bool allVersions = false) {
    return Json(null); }

  Json insertOne(Json newData) {
    return Json(null); }

  size_t updateMany(STRINGAA select, STRINGAA updateData) {
    return updateMany(select.toJson, updateData.toJson); }

  size_t updateMany(STRINGAA select, Json updateData) {
    return updateMany(select.toJson, updateData); }

  size_t updateMany(Json select, STRINGAA updateData) {
    return updateMany(select, updateData.toJson); }

  abstract size_t updateMany(Json select, Json updateData);

  bool updateOne(STRINGAA select, STRINGAA updateData) {
    return updateOne(select.toJson, updateData.toJson); }

  bool updateOne(STRINGAA select, Json updateData) {
    return updateOne(select.serializeToJson, updateData); }

  bool updateOne(Json select, STRINGAA updateData) {
    return updateOne(select, updateData.toJson); }

  abstract bool updateOne(Json select, Json updateData);

  size_t removeMany(UUID[] ids, bool allVersions = false) {
    return ids.map!(a => removeMany(a, allVersions)).sum; }

  size_t removeMany(UUID id, bool allVersions = false) {
    return 0; }

  size_t removeMany(UUID[] ids, size_t versionNumber) {
    return ids.map!(a => removeMany(a, versionNumber)).sum; }

  size_t removeMany(UUID id, size_t versionNumber) {
    return 0; }

  size_t removeMany(STRINGAA[] selects, bool allVersions = false) {
    return selects.map!(a => removeMany(a, allVersions)).sum; }

  size_t removeMany(STRINGAA select, bool allVersions = false) {
    auto jsons = findMany(select, allVersions);
    return jsons.map!(a => removeOne(a) ? 1 : 0).sum; }

  size_t removeMany(Json[] selects, bool allVersions = false) {
    return selects.map!(a => removeMany(a, allVersions)).sum; }

  size_t removeMany(Json select, bool allVersions = false) {
    auto jsons = findMany(select, allVersions);
    return jsons.map!(a => removeOne(a) ? 1 : 0).sum; }

  bool removeOne(UUID[] ids, bool allVersions = false) {
    return ids.map!(a => removeOne(a, allVersions)).sum > 0; }

  bool removeOne(UUID id, bool allVersions = false) {
    Json json = Json.emptyObject;
    json["id"] = id.toString;
    return removeOne(json, allVersions); }

  bool removeOne(UUID id, size_t versionNumber) {
    Json json = Json.emptyObject;
    json["id"] = id.toString;
    json["versionNumber"] = versionNumber;
    return removeOne(json); }

  /// RemoveMany by select (string[string])
  bool removeOne(STRINGAA[] selects, bool allVersions = false) {
    return selects.map!(a => removeOne(a, allVersions)).sum > 0; }

  /// remove one selected item
  abstract bool removeOne(STRINGAA select, bool allVersions = false);

  /// remove one selected item
  bool removeOne(Json[] selects, bool allVersions = false) {
    foreach (select; selects) if (removeOne(select, allVersions)) return true;
    return false; }

  /// remove one selected item
  abstract bool removeOne(Json select, bool allVersions = false);
}