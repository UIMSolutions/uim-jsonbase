module uim.jsonbase.classes.bases.memory;

@safe:
import uim.jsonbase;

class DMemoryJsonBase : DJsonBase {
  mixin(JsonBaseThis!("MemoryJsonBase"));

  // Create
  IJsonTenant createTenant(string aName) {
    return MemoryJsonTenant(aName);
  }
}
mixin(JsonBaseThis!("MemoryJsonBase"));

unittest {
  assert(testJsonBase(MemoryJsonBase));
}