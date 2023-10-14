module uim.jsonbase.classes.tenants.tenant;

@safe:
import uim.jsonbase;

class DJsonTenant : IJsonTenant, IJsonCollectionManager {
  this() { initialize; this.className("JsonTenant"); }
  this(IJsonBase aBase) { this(); this.base(aBase); }
  this(string aName) { this(); this.name(aName); }
  this(IJsonBase aBase, string aName) { this(aBase); this.name(aName); }

  void initialize(Json configSettings = Json(null)) { // Hook
  }

  // #region Properties 
    mixin(TProperty!("string", "className"));
    mixin(TProperty!("string", "name"));
    mixin(TProperty!("IJsonBase", "base"));
  // #endregion Properties

  // #region Collection manager 
    protected DJsonCollection[string] _collections;
    // Collections
    bool hasCollections(string[] someNames...) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return hasCollection(someNames.dup);
    }
    bool hasCollections(string[] someNames = null) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return (countCollection(someNames) > 0);
    } 

    size_t countCollections(string[] someNames...) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return countCollections(someNames.dup);
    } 
    size_t countCollections(string[] someNames = null) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return (someNames 
        ? someNames.map!(n => (hasCollection(n) ? 1 : 0)).sum
        : _collections.length);
    } 

    string[] existingCollections(string[] someNames...) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      
      return existingCollections(someNames.dup);
    } 
    string[] existingCollections(string[] someNames = null) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      if (someNames) {
        return someNames.filter!(n => hasCollection(n)).array;
      }
      return collectionNames();
    }

    string[] collectionNames() {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return _collections.keys;
    }
    IJsonCollection[] collections() {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return _collections.values;
    }
    // Collection
    bool hasCollection(string aName) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return (aName in _collections);
    }
    IJsonCollection collection(string aName) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return _collections.get(aName, null);
    } 

    // Add collections
    bool addCollections(IJsonCollection[] someCollections...) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return addCollections(someCollections.dup);
    }
    bool addCollections(IJsonCollection[] someCollections) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      foreach(myCollection; someCollections) {
        if (!addCollection(myCollection)) { return false; }
      }
    } 
    bool addCollections(IJsonCollection[string] someCollections); 

    // Add collection
    bool addCollection(IJsonCollection aCollection) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return (aCollection ? addCollection(aCollection.name, aCollection) : false);
    }

    bool addCollection(string aName, IJsonCollection aCollection) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      if (aName.length == 0) { return false; }
      if (aCollection is null) { return false; }

      _collections[aName] = aCollection;
      return true;
    }

    // Create Collections
    IJsonCollection[] createCollections(string[] someNames...); 
    IJsonCollection[] createCollections(string[] someNames); 

    IJsonCollection createCollection(string aName); 

    // Delete
    bool deleteCollections(string[] someNames...); 
    bool deleteCollections(string[] someNames);

    bool deleteCollection(string aName); 
  // #endregion Collection manager 
}
mixin(JsonTenantCalls!("JsonTenant"));

unittest {
}