module uim.jsonbase.classes.tenants.tenant;

@safe:
import uim.jsonbase;

class DJsonTenant : IJsonTenant, IJsonCollectionManager {
  this() {}
  this(string aName) { this(); this.name(aName); }

  // #region Properties 
    mixin(OProperty!("string", "name"));
  // #endregion Properties

  // #region Collection manager 
    protected DJsonCollection[string] _collections;
    // Collections
    bool hasCollections(string[] someNames...) {
      return hasCollection(someNames.dup);
    }
    bool hasCollections(string[] someNames = null) {
      return (countCollection(someNames) > 0);
    } 

    size_t countCollections(string[] someNames...) {
      return countCollections(someNames.dup);
    } 
    size_t countCollections(string[] someNames = null) {
      return (someNames 
        ? someNames.map!(n => (hasCollection(n) ? 1 : 0)).sum
        : _collections.length);
    } 

    string[] existingCollections(string[] someNames...) {
      return existingCollections(someNames.dup);
    } 
    string[] existingCollections(string[] someNames = null) {
      if (someNames) {
        return someNames.filter!(n => hasCollection(n)).array;
      }
      return collectionNames();
    }

    string[] collectionNames() {
      return _collections.keys;
    }
    IJsonCollection[] collections() {
      return _collections.values;
    }
    // Collection
    bool hasCollection(string aName) {
      return (aName in _collections);
    }
    IJsonCollection collection(string aName) {
      return _collections.get(aName, null);
    } 

    // Add collections
    bool addCollections(IJsonCollection[] someCollections...) {
      return addCollections(someCollections.dup);
    }
    bool addCollections(IJsonCollection[] someCollections) {
      foreach(myCollection; someCollections) {
        if (!addCollection(myCollection)) { return false; }
      }
    } 
    bool addCollections(IJsonCollection[string] someCollections); 

    // Add collection
    bool addCollection(IJsonCollection aCollection) {
      return (aCollection ? addCollection(aCollection.name, aCollection) : false);
    }
    bool addCollection(string aName, IJsonCollection aCollection) {
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