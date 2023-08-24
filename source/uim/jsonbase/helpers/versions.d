module uim.jsonbase.helpers.versions;

import uim.jsonbase;

@safe:
// #region check
  bool checkVersion(Json value, string[] keys = null) {
    if (value == Json(null)) return false;

    foreach (key; keys) if (key !in value) return false;
    return true;
  }

  bool checkVersion(Json value, UUID id, size_t vNumber = 0) {
    if (!checkVersion(value, ["id", "versionNumber"])) return false; // Testing against null results in false

    if (vNumber == 0) return (value["id"].get!string == id.toString);
    return (value["id"].get!string == id.toString) && (value["versionNumber"].get!size_t == vNumber);
  }

  bool checkVersion(Json value, STRINGAA selector) {
    //  (!checkVersion(value)) return false; // Testing against null results in false
    if (selector.empty) return false; // Testing against null results in false

    foreach (key; selector.byKey) {      
      // debug writeln("-> "~key~"/"~selector[key]);
      if (key !in value) return false;
      // debug writeln("-> %s : %s".format(value[key].type, value[key]));
      switch (value[key].type) {
        case Json.Type.string:
          if (value[key].get!string != selector[key]) return false;
          break;
        default:
          if (value[key].toString != selector[key]) return false;
          break;
      }
    }
    return true;
  }
  unittest {
    auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}], "i":1}`);
/*     assert(checkVersion(json, ["a":"b"]), 
      "Wrong CheckVersion result. Should be true -> %s for %s using %s".format(checkVersion(json, ["a":"b"]), json, ["a":"b"])); */

    assert(checkVersion(json, ["a":"b", "i":"1"]));
    assert(!checkVersion(json, ["a":"y"]));
    assert(!checkVersion(json, ["x":"y"]));
  }

  bool checkVersion(Json ver, Json selector) {
    if (ver == Json(null)) return false; // Testing against null results in false
    if (selector == Json(null)) return false; // Testing against null results in false

    foreach (kv; selector.byKeyValue) 
      if (kv.key !in ver || ver[kv.key] != selector[kv.key]) return false;
    return true;
  }
  unittest {
    auto json = parseJsonString(`{"a":"b", "c":{"d":1}, "e":["f", {"g":"h"}], "i":1}`);
    assert(checkVersion(json, parseJsonString(`{"a":"b"}`)));
    assert(checkVersion(json, parseJsonString(`{"a":"b", "c":{"d":1}}`)));
    assert(!checkVersion(json, parseJsonString(`{"a":"y"}`)));
    assert(!checkVersion(json, parseJsonString(`{"x":"y"}`)));
  }

  bool checkVersion(T)(Json entity, string key, T value) {
    return (key in entity) && (entity[key].get!T == value);
  }
// #endregion check