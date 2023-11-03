module uim.jsonbase.tests.base;

import uim.jsonbase;

@safe:

bool testJsonBase(IJsonBase aBase) {
  if (aBase is null)
    return false;

  return true;
}
