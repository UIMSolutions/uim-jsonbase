module uim.jsonbase.classes.tenants.memory;

@safe:
import uim.jsonbase;

/// MemoryTenant manages MemoryCollections
class DMemoryJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("MemoryJsonTenant"));
}
mixin(JsonTenantCalls!("MemoryJsonTenant"));

unittest {
  assert(testJsonTenant(MemoryJsonTenant));
}