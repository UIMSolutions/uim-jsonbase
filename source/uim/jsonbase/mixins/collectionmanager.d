module uim.jsonbase.mixins.collectionmanager;

import uim.jsonbase;

@safe:
template JsonCollectionManagerTemplate() {
  // #region READ
    // #region hasCollections()
      bool hasCollections(string[] someNames...) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        // Body & Final      
        return hasCollections(someNames.dup);
      }

      bool hasCollections(string[] someNames = null) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        // Preconditions
        if (someNames.isEmpty) { return false; }

        // Body & Final      
        return (countCollections(someNames) > 0);
      } 
    // #endregion hasCollections()

    // #region hasCollection()
      bool hasCollection(string aName) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        // Body & Final      
        return false;
      }
    // #endregion hasCollection()
  // #endregion READ

      protected IJsonCollection[string] _collections;
    // Collections
    

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

      // Preconditions
      if (someNames.isEmpty) { return collectionNames(); }
      
      // Final
      return someNames.filter!(n => hasCollection(n)).array;

    }

    string[] collectionNames() {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return _collections.keys;
    }
    IJsonCollection[] collections() {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return _collections.values;
    }

    // #region hasCollection() 
    bool hasCollection(string aName) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return (aName in _collections ? true : false);
    }
    // #endregion hasCollection() 

    // #region collection() 
      IJsonCollection collection(string aName) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        return _collections.get(aName, null);
      } 
    // #endregion collection() 

    // Add collections
    bool addCollections(IJsonCollection[] someCollections...) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return addCollections(someCollections.dup);
    }
    bool addCollections(IJsonCollection[] someCollections) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return someCollections
        .filter!(c => addCollection(c))
        .array
        .length == someCollections.length;
    } 
    bool addCollections(IJsonCollection[string] someCollections); 

    // Add collection
    bool addCollection(IJsonCollection aCollection) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return aCollection 
        ? addCollection(aCollection.name, aCollection) 
        : false;
    }

    bool addCollection(string aName, IJsonCollection aCollection) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      // Preconditions
      if (aName.length == 0) { return false; }
      if (aCollection is null) { return false; }

      // Body
      _collections[aName] = aCollection;
      
      // Final
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