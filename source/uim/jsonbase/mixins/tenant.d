module uim.jsonbase.mixins.tenant;

import uim.jsonbase;

@safe:
string jsonTenantThis(string aName) {
  return `
<<<<<<< HEAD
this() { super(); this.className("`~aName~`"); }
this(IJsonBase aBase) { this(); this.base(aBase); }
=======
this() { super(); this.className("`
    ~ aName ~ `"); }
>>>>>>> ca5f58dc7f635b04388aff8bf32397e11e9cfb0a
this(string aName) { this(); this.name(aName); }

this(IJsonBase aBase, string aName) { this(aBase); this.name(aName); }
  `;
}

template JsonTenantThis(string aName) {
  const char[] JsonTenantThis = jsonTenantThis(aName);
}

string jsonTenantCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D" ~ shortName;

  return `
<<<<<<< HEAD
auto `~shortName~`() { return new `~clName~`; }
auto `~shortName~`(IJsonBase aBase) { return new `~clName~`(aBase); }
auto `~shortName~`(string aName) { return new `~clName~`(aName); }
auto `~shortName~`(IJsonBase aBase, string aName) { return new `~clName~`(aBase, aName); }
=======
auto `
    ~ shortName ~ `() { return new ` ~ clName ~ `; }
auto `
    ~ shortName ~ `(string aName) { return new ` ~ clName ~ `(aName); }
>>>>>>> ca5f58dc7f635b04388aff8bf32397e11e9cfb0a
  `;
}

template JsonTenantCalls(string shortName, string className = null) {
  const char[] JsonTenantCalls = jsonTenantCalls(shortName, className);
}
