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

  // Add tenants
  bool addTenants(IJsonTenant[] someTenants); 
  bool addTenants(IJsonTenant[] someTenants); 
  bool addTenants(IJsonTenant[] someTenants); 

  bool addTenant(IJsonTenant aTenant); 

  // Create
  IJsonTenant createTenant(string aName); 

  // Delete
  bool deleteTenant(string aName); 
}