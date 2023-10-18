module uim.jsonbase.helpers;

public {
  import uim.jsonbase.helpers.filecollection;
  import uim.jsonbase.helpers.folder;
  import uim.jsonbase.helpers.path;
  import uim.jsonbase.helpers.versions;
}

import uim.jsonbase;

@safe:
// #endregion lastVersion()
Json lastVersion(Json[] jsons) {
  // Preconditions
  if (jsons.isEmpty) { return Json(null); }

  // Body
  Json result = Json(null);
  foreach(json; jsons) {
    if (result.isEmpty && "versionNumber" in json) 
      result = json; 
  }

  if (!result.isEmpty) {
    foreach(json; jsons) {
      if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"].get!size_t) 
        result = json;
    }
  } 

  return result;
}

Json lastVersion(Json[size_t] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach(k, json; jsons) 
      if (result.isEmpty && "versionNumber" in json) 
        result = json; 
    if (result != Json(null)) foreach(k, json; jsons) 
      if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"].get!size_t) 
        result = json; 
  }
  
  return result;
}

Json oneVersion(Json[] jsons) {
  // Preconditions
  if (jsons.isEmpty) { return Json(null); }

  // Body
  Json result = Json(null);
  jsons.each!(j => result = result.isEmpty && "versionNumber" in j ? j : result );

  if (result != Json(null)) foreach(json; jsons) 
    if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"].get!size_t) 
      result = json; 

  // Final
  return result;
}

Json oneVersion(Json[size_t] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach(k, json; jsons) 
      if (result.isEmpty && "versionNumber" in json) 
        result = json; 
    if (result != Json(null)) foreach(k, json; jsons) 
      if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"].get!size_t) 
        result = json; 
  }
  
  return result;
}



string filePath(Json json, string sep = "/", string extension = ".json") {
  if (json.isEmpty) return "";
 
  if ("id" in json && "versionNumber" in json) return json["id"].get!string~sep~"1"~extension;

  return ("id" in json) ? 
    json["id"].get!string~sep~to!string(json["versionNumber"].get!size_t)~".json" : "";
}

/* string jsonFilePath(Json json, string sep = "/") {
  if (json.isEmpty) return "";
 
  if ("id" in json && "versionNumber" in json) return json["id"].get!string~sep~"1.json";

  return ("id" in json) ? 
    json["id"].get!string~sep~to!string(json["versionNumber"].get!size_t)~".json" : "";
} */

/* string jsonFilePath(string startPath, Json json, string sep = "/") {
  if (json.isEmpty) return "";
  return startPath~sep~jsonFilePath(json, sep);
} */


