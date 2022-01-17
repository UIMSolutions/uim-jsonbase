module uim.jsonbase.bases.base;

@safe:
import uim.jsonbase;

class DJSBBase {
  this() {}

  mixin(OProperty!("DJBTenant[string]", "tenants"));

  bool tenantExist(string tenantName) {
    return tenantName in _tenants ? true : false; }
  unittest {
    version(uim_jsonbase) {
      auto base = JSBBase; }}

  DJBTenant opIndex(string tenantName) {
    return _tenants.get(tenantName, null); }
  unittest {
    version(uim_jsonbase) {
      auto base = JSBBase; }}

  auto tenantNames() { return _tenants.byKey.array; }
  unittest {
    version(uim_jsonbase) {
      auto base = JSBBase; }}
}
auto JSBBase() { return new DJSBBase; }
