module uim.jsonbase.classes.tenants.tenant;

@safe:
import uim.jsonbase;

class DJBTenant {
  this() {}

  protected DJsonCollection[string] _collections;
  @property auto collections() { return _collections; }
  
  /// Get names of existing collections
  auto collectionNames() { return _collections.byKey.array; }

  DJsonCollection opIndex(string name) {
    return _collections.get(name, null);
  }

  void opIndexAssign(string name, DJsonCollection newCollection) {
    _collections[name] = newCollection;
  }

  void clearCollections() {
    _collections = null;
  }
}

version(test_uim_jsonbase) { unittest {
  //
}}  