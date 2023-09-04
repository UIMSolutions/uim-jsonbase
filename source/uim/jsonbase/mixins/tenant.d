module uim.jsonbase.mixins.tenant;

import uim.jsonbase;

@safe:
string jsonTenantThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }
this(string aName) { this(); this.name(aName); }
  `;
}

template JsonTenantThis(string aName) {
  const char[] JsonTenantThis = jsonTenantThis(aName);
}

string jsonTenantCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;
  
  return `
auto `~shortName~`() { return new `~clName~`; }
auto `~shortName~`(string aName) { return new `~clName~`(aName); }
  `;
}

template JsonTenantCalls(string shortName, string className = null) {
  const char[] JsonTenantCalls = jsonTenantCalls(shortName, className);
}