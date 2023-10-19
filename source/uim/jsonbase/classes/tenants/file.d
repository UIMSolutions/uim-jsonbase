module uim.jsonbase.classes.tenants.file;

@safe:
import uim.jsonbase;

/// FileJsonTenant manages FileCollections
class DFileJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("FileJsonTenant"));

  // #region hasCollection() 
  override bool hasCollection(string aName) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

    return (aName in _collections ? true : false);
  }
  // #endregion hasCollection() 
}
mixin(JsonTenantCalls!("FileJsonTenant"));

unittest {
  assert(testJsonTenant(FileJsonTenant));
}