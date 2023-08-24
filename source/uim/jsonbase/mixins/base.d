module uim.jsonbase.mixins.base;

import uim.jsonbase;

@safe:
string jsonBaseThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }
  `;
}

template JsonBaseThis(string aName) {
  const char[] JsonBaseThis = jsonBaseThis(aName);
}

string jsonBaseCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;
  
  return `
auto `~shortName~`() { return new `~clName~`; }
  `;
}

template JsonBaseCalls(string shortName, string className = null) {
  const char[] JsonBaseCalls = jsonBaseCalls(shortName, className);
}