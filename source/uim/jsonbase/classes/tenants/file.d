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

version(test_uim_jsonbase) { unittest {
  auto tenant = FileJsonTenant("/home/oz/Documents/PROJECTS/DATABASES/uim/uim");
  tenant.rootPath("/home/oz/Documents/PROJECTS/DATABASES/uim/central");
   
  foreach(colName, col; tenant.collections) {
    writeln(colName, "\t->\t", (cast(DFileJsonCollection)col).path, "\t->\t", col.findMany.length);
  }
}}