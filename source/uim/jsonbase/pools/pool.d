module uim.jsonbase.tenants.tenant;

@safe:
import uim.jsonbase;

class DJBTenant {
  this() {}

  protected DJSBCollection[string] _collections;
  @property auto collections() { return _collections; }
  unittest {
    version(uim_jsonbase) {
      /// TODO
    } 
  }
  
  /// Get names of existing collections
  auto collectionNames() { return _collections.byKey.array; }
  unittest {
    version(uim_jsonbase) {
      /// TODO
    } 
  }

  DJSBCollection opIndex(string name) {
    return _collections.get(name, null);
  }
  unittest {
    version(uim_jsonbase) {
      /// TODO
    } 
  }

  void opIndexAssign(string name, DJSBCollection newCollection) {
    _collections[name] = newCollection;
  }
  unittest {
    version(uim_jsonbase) {
      /// TODO
    } 
  }

  void clearCollections() {
    _collections = null;
  }
  unittest {
    version(uim_jsonbase) {
      /// TODO
    } 
  }  
}