module uim.jsonbase.classes.bases.base;

import uim.jsonbase;

@safe:
class DJsonBase : IJsonBase, IJsonTenantManager {
  this() { initialize; }

  void initialize(Json configSettings = Json(null)) { // Hook
    pathSeparator("/");
  }

  mixin(OProperty!("string", "className"));
  mixin(OProperty!("string", "name"));
  mixin(OProperty!("DJBTenant[string]", "tenants"));

  bool tenantExist(string tenantName) {
    return tenantName in _tenants ? true : false; }
  version(test_uim_jsonbase) { unittest {
    
      auto base = JsonBase; }}

  DJBTenant opIndex(string tenantName) {
    return _tenants.get(tenantName, null); }
  version(test_uim_jsonbase) { unittest {
    
      auto base = JsonBase; }}

  auto tenantNames() { return _tenants.byKey.array; }
  version(test_uim_jsonbase) { unittest {
    
      auto base = JsonBase; }}
}
auto JsonBase() { return new DJsonBase; }
