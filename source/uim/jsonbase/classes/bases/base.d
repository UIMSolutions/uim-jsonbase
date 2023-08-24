module uim.jsonbase.classes.bases.base;

@safe:
import uim.jsonbase;

class DJSBBase {
  this() {}

  mixin(OProperty!("DJBTenant[string]", "tenants"));

  bool tenantExist(string tenantName) {
    return tenantName in _tenants ? true : false; }
  version(test_uim_jsonbase) { unittest {
    
      auto base = JSBBase; }}

  DJBTenant opIndex(string tenantName) {
    return _tenants.get(tenantName, null); }
  version(test_uim_jsonbase) { unittest {
    
      auto base = JSBBase; }}

  auto tenantNames() { return _tenants.byKey.array; }
  version(test_uim_jsonbase) { unittest {
    
      auto base = JSBBase; }}
}
auto JSBBase() { return new DJSBBase; }
