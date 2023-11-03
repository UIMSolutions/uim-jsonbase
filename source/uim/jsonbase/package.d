module uim.jsonbase;

mixin(ImportPhobos!());

// Dub
public {
  import vibe.d;
}

public import uim.core;
public import uim.oop;
public import uim.filesystems;
public import uim.logging;

public  {
  import uim.jsonbase.classes;
  import uim.jsonbase.helpers;
  import uim.jsonbase.interfaces;
  import uim.jsonbase.mixins;
  import uim.jsonbase.tests;
}

@safe:
string filePath(Json json, string sep = "/", string extension = ".json") {
  if (json == Json(null))
    return "";

  if ("id" in json && "versionNumber" in json)
    return json["id"].get!string ~ sep ~ "1" ~ extension;

  return ("id" in json) ?
    json["id"].get!string ~ sep ~ to!string(json["versionNumber"].get!size_t) ~ ".json" : "";
}

/* string jsonFilePath(Json json, string sep = "/") {
  if (json == Json(null)) return "";
 
  if ("id" in json && "versionNumber" in json) return json["id"].get!string~sep~"1.json";

  return ("id" in json) ? 
    json["id"].get!string~sep~to!string(json["versionNumber"].get!size_t)~".json" : "";
} */

/* string jsonFilePath(string startPath, Json json, string sep = "/") {
  if (json == Json(null)) return "";
  return startPath~sep~jsonFilePath(json, sep);
} */

string dirPath(string path, UUID id, string separator = "/") {
  return path ~ dirPath(id, separator);
}

string dirPath(UUID id, string separator = "/") {
  return separator ~ id.toString;
}

string dirPath(string path, Json json, string separator = "/") {
  if (json == Json(null))
    return "";
  if ("id" !in json)
    return "";

  return path ~ dirPath(json, separator);
}

string dirPath(Json json, string separator = "/") {
  if (json == Json(null))
    return "";
  if ("id" !in json)
    return "";

  return separator ~ json["id"].get!string;
}

string filePath(string path, UUID id, size_t versionNumber, string separator = "/") {
  return path ~ filePath(id, versionNumber, separator);
}

string filePath(UUID id, size_t versionNumber, string separator = "/") {
  return dirPath(id, separator) ~ separator ~ toString(versionNumber > 0 ? versionNumber : 1) ~ ".json";
}

string filePath(string path, Json json, string separator = "/") {
  if (json == Json(null))
    return "";
  if ("id" !in json)
    return "";

  return path ~ filePath(json, separator);
}

string filePath(Json json, string separator = "/") {
  if (json == Json(null))
    return "";
  if ("id" !in json)
    return "";

  return dirPath(json, separator) ~ separator ~ ("versionNumber" in json ?
      to!string(json["versionNumber"].get!long > 0 ? json["versionNumber"].get!long : 1) : "1") ~ ".json";
}

Json lastVersion(Json[] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach (json; jsons)
      if (result == Json(null) && "versionNumber" in json)
        result = json;
    if (result != Json(null))
      foreach (json; jsons)
        if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"]
          .get!size_t)
          result = json;
  }

  return result;
}

Json lastVersion(Json[size_t] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach (k, json; jsons)
      if (result == Json(null) && "versionNumber" in json)
        result = json;
    if (result != Json(null))
      foreach (k, json; jsons)
        if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"]
          .get!size_t)
          result = json;
  }

  return result;
}

Json oneVersion(Json[] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach (json; jsons)
      if (result == Json(null) && "versionNumber" in json)
        result = json;
    if (result != Json(null))
      foreach (json; jsons)
        if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"]
          .get!size_t)
          result = json;
  }

  return result;
}

Json oneVersion(Json[size_t] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach (k, json; jsons)
      if (result == Json(null) && "versionNumber" in json)
        result = json;
    if (result != Json(null))
      foreach (k, json; jsons)
        if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"]
          .get!size_t)
          result = json;
  }

  return result;
}
