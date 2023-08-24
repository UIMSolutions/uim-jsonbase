module uim.jsonbase.tenants.tenant;

@safe:
import uim.jsonbase;

class DJBTenant {
  this() {}

  protected DJSBCollection[string] _collections;
  @property auto collections() { return _collections; }
  
  /// Get names of existing collections
  auto collectionNames() { return _collections.byKey.array; }

  DJSBCollection opIndex(string name) {
    return _collections.get(name, null);
  }

  void opIndexAssign(string name, DJSBCollection newCollection) {
    _collections[name] = newCollection;
  }

  void clearCollections() {
    _collections = null;
  }
}

version(test_uim_jsonbase) { unittest {
  //
}}  