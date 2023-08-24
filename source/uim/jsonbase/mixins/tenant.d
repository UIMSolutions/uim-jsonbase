module uim.jsonbase.mixins.tenant;

import uim.jsonbase;

@safe:
string jsonTenantThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }
  `;
}

template JsonTenantThis(string aName) {
  const char[] JsonTenantThis = jsonTenantThis(aName);
}

string jsonTenantCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;
  
  return `
auto `~shortName~`() { return new `~clName~`; }
  `;
}

template JsonTenantCalls(string shortName, string className = null) {
  const char[] JsonTenantCalls = jsonTenantCalls(shortName, className);
}