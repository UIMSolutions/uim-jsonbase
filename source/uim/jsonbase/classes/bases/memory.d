module uim.jsonbase.classes.bases.memory;

import uim.jsonbase;

@safe:
class DMemoryJsonBase : DJsonBase {
  mixin(JsonBaseThis!("MemoryJsonBase"));

  // Create
  override IJsonTenant createTenant(string aName) {
    addTenant(aName, MemoryJsonTenant(aName));
    return tenant(aName);
  }
}
mixin(JsonBaseThis!("MemoryJsonBase"));

unittest {
  assert(testJsonBase(MemoryJsonBase));
}