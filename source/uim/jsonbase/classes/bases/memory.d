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
mixin(JsonBaseCalls!("MemoryJsonBase"));

unittest {
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}