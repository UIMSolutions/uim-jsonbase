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

    // #region countCollections() 
      size_t countCollections(string[] someNames...) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        return countCollections(someNames.dup);
      } 

      size_t countCollections(string[] someNames = null) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        // Preconditions
        if (someNames.isEmpty) { return 0; }

        return someNames.filter!(n => hasCollection(n)).array.length;
      } 
    // #endregion countCollections() 

    // #region existingCollections() 
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
    // #endregion existingCollections() 

    // #region collectionNames()
      string[] collectionNames() {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        return _collections.keys;
      }
    // #endregion collectionNames()

    // #region collections()
      IJsonCollection[] collections() {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

        return _collections.values;
      }
    // #endregion collections()

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
    bool addCollections(IJsonCollection[string] someCollections) {
      return false;
    }

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
      if (aName.isEmpty || aCollection is null) { return false; }

      // Body
      _collections[aName] = aCollection;
      
      // Final
      return true;
    }

    // Create Collections
    IJsonCollection[] createCollections(string[] someNames...) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return createCollections(someNames.dup);
    }

    IJsonCollection[] createCollections(string[] someNames) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return someNames
        .map!(n => createCollection(n))
        .filter!(c => c !is null)
        .array;      
    }

    IJsonCollection createCollection(string aName) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return null; 
    }

  // #region deleteCollections() 
    bool deleteCollections(string[] someNames...) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return deleteCollections(someNames.dup);
    }

    bool deleteCollections(string[] someNames) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return someNames
        .filter!(n => deleteCollection(n))
        .array.length == someNames.length;      
    }

    bool deleteCollection(string aName) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

      return false;
    }
  // #endregion deleteCollections() 
}