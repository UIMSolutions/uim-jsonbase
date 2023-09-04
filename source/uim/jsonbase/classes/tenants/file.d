module uim.jsonbase.classes.tenants.file;

@safe:
import uim.jsonbase;

/// FileJsonTenant manages FileCollections
class DFileJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("FileJsonTenant"));
}
mixin(JsonTenantCalls!("FileJsonTenant"));

unittest {
  assert(testJsonTenant(FileJsonTenant));
}