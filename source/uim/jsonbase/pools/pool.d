module uim.jsonbase.pools.pool;

@safe:
import uim.jsonbase;

class DJBPool {
  this() {}

  protected DJDBCollection[string] _collections;
  @property auto collections() { return _collections; }

  DJDBCollection opIndex(string name) {
    return _collections.get(name, null);
  }

  void opIndexAssign(string name, DJDBCollection newCollection) {
    _collections[name] = newCollection;
  }
}