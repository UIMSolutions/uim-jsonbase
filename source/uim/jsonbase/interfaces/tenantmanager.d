module uim.jsonbase.interfaces.tenantmanager;

import uim.jsonbase;

@safe:
interface IJsonTenantManager {  
  // Tenants
  bool hasTenants(); 
  size_t countTenants(); 
  IJsonTenant[] tenants(); 

  // Tenant
  bool hasTenant(string aName); 
  IJsonTenant tenant(string aName); 

  // Add
  bool addTenants(ITenant[] someTenants); 
  bool addTenant(ITenant aTenant); 

  // Create
  ITenant createTenant(string aName); 

  // Delete
  bool deleteTenant(string aName); 
}