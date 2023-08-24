module uim.jsonbase.classes.tenants.memory;

@safe:
import uim.jsonbase;

/// MemoryTenant manages MemoryCollections
class DJBMemoryTenant : DJBTenant {
  mixin(JsonTenantThis!("MemoryJsonTenant"));
}
mixin(JsonTenantCall!("MemoryJsonTenant"));

unittest {
}