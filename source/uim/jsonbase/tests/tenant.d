module uim.jsonbase.tests.tenant;

import uim.jsonbase;
@safe:

bool testJsonTenant(IJsonTenant aTenant) {
  if (aTenant is null) return false;
  
  return true;
}