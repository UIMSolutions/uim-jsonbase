module uim.jsonbase.tests.base;

import uim.jsonbase;

@safe:

bool testJsonBase(IJsonBase aBase) {
<<<<<<< HEAD
  if (aBase is null) { return false; }
  
  return true;
}

// #region tenant
  void testBase_CreateTenant() {

  }

  void testBase_ReadTenant() {
    
  }

  void testBase_UpdateTenant() {
    
  }

  void testBase_DeleteTenant() {
    
  }
// #endregion tenant

// #region tenants
  void testBase_CreateTenants() {

  }

  void testBase_ReadTenants() {
    
  }

  void testBase_UpdateTenants() {
    
  }

  void testBase_DeleteTenants() {
    
  }
// #endregion tenants
=======
  if (aBase is null)
    return false;

  return true;
}
>>>>>>> ca5f58dc7f635b04388aff8bf32397e11e9cfb0a
