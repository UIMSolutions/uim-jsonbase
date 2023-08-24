module uim.jsonbase.mixins.collection;

import uim.jsonbase;

@safe:
string jsonCollectionThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }
  `;
}

template JsonCollectionThis(string aName) {
  const char[] JsonCollectionThis = jsonCollectionThis(aName);
}

string jsonCollectionCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;
  
  return `
auto `~shortName~`() { return new `~clName~`; }
  `;
}

template JsonCollectionCalls(string shortName, string className = null) {
  const char[] JsonCollectionCalls = jsonCollectionCalls(shortName, className);
}