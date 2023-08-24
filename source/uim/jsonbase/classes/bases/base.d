module uim.jsonbase.classes.bases.base;

import uim.jsonbase;

@safe:
class DJsonBase : IJsonBase, IJsonTenantManager {
  this() { initialize; }

  void initialize(Json configSettings = Json(null)) { // Hook
  }

  mixin(OProperty!("string", "className"));
  mixin(OProperty!("string", "name"));
  
  // #region TenantManager
    // Tenants
    protected IJsonTenant[string] _tenants;

    bool hasTenants(string[] someNames...) {
      return hasTenants(someNames.dup);
    }
    bool hasTenants(string[] someNames = null) { 
      return (countTenants(someNames) > 0);
    }
    
    size_t countTenants(string[] someNames...) {
      return countTenants(someNames.dup);
    } 
    size_t countTenants(string[] someNames = null){ 
      if (someNames.length == 0) { return _tenants.length; }

      return someNames.map!(n => (tenant(n) ? 1 : 0)).sum();
    }

    string[] existingTenants(string[] someNames...) {
      return countTenants(someNames.dup);
    }  
    string[] existingTenants(string[] someNames = null) {
      return someNames.filter!(n => (tenant(n) ? true : false)).array;
    } 

    string[] tenantNames() {
      return _tenants.keys;
    } 
    IJsonTenant[] tenants() {
      return _tenants.values;
    }

    size_t countTenants() {
      return tenants.length;
    } 
    IJsonTenant[] tenants() {
      return _tenants;
    } 

    // Tenant
    bool hasTenant(string aName) {
      return (tenant(aName) !is null);
    } 
    IJsonTenant tenant(string aName) {
      return _tenants.get(aName, null);
    } 

    // Add tenants
    bool addTenants(IJsonTenant[] someTenants...) {
      return addTenants(someTenants.dup);
    }

    bool addTenants(IJsonTenant[] someTenants) {
      foreach(myTenant; someTenants) {
        if (!addTenant(myTenant)) { return false; }
      }
      return true;
    }

    bool addTenants(IJsonTenant[string] someTenants) {
      foreach(myName, myTenant; someTenants) {
        if (!addTenant(myName, myTenant)) { return false; }
      }
      return true;
    }

    // Add tenant
    bool addTenant(IJsonTenant aTenant) {
      return (aTenant ? addTenant(aTenant.name, aTenant) : false);
    }
    bool addTenant(string aName, IJsonTenant aTenant) {
      if (aName.length = 0) return false;
      if (aTenant is null) return null;
      
      _tenants[aName] = aTenant;
      return true;
    } 

    // Create
    IJsonTenant createTenant(string aName) {
      return null;
    }

    // Delete
    bool deleteTenant(string aName) {
      return false;
    }
  // #endregion TenantManager
}
auto JsonBase() { return new DJsonBase; }
