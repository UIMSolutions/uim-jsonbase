module uim.jsonbase.helpers.path;

import uim.jsonbase;

@safe:
// #region dirPath()
  string dirPath(string path, Json json, string separator = "/") {
    if (json.isEmpty) return null;
    if ("id" !in json) return null;

    return dirPath(path, UUID(json["id"].get!string), separator);
  }

  string dirPath(string path, UUID id, string separator = "/") {
    return dirPath(path, id.toString, separator);
  }

  string dirPath(string path, string id, string separator = "/") {
    return path~separator~id.toString;
  }

  string dirPath(Json json, string separator = "/") {
    if (json.isEmpty) return "";
    if ("id" !in json) return "";

    return separator~json["id"].get!string;
  }
// #endregion dirPath()

// #region filePath()
  string filePath(string path, UUID id, size_t versionNumber, string separator = "/") {
    return path~filePath(id, versionNumber, separator);
  }
  string filePath(UUID id, size_t versionNumber, string separator = "/") {
    return dirPath(id, separator)~separator~toString(versionNumber > 0 ? versionNumber : 1)~".json";
  }
  string filePath(string path, Json json, string separator = "/") {
    if (json.isEmpty) return "";
    if ("id" !in json) return "";

    return path~filePath(json, separator);
  }
  string filePath(Json json, string separator = "/") {
    if (json.isEmpty) return "";
    if ("id" !in json) return "";

    return dirPath(json, separator)~separator~("versionNumber" in json ? 
      to!string(json["versionNumber"].get!long > 0 ? json["versionNumber"].get!long : 1) : "1")~".json";
  }
// #endregion filePath()

