module uim.jsonbase.classes.tenants.file;

@safe:
import uim.jsonbase;

/// FileJsonTenant manages FileCollections
class DFileJsonTenant : DJsonTenant {
  mixin(JsonTenantThis!("FileJsonTenant"));

  this(string newRootPath) {
    this().rootPath(newRootPath); 
  }


}
mixin(JsonTenantCalls!("FileJsonTenant"));

auto FileJsonTenant(string newRootPath) { return new DFileJsonTenant(newRootPath); }

unittest {
  assert(testJsonTenant(FileJsonTenant));
}