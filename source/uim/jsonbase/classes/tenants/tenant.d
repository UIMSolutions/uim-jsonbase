module uim.jsonbase.classes.tenants.tenant;

@safe:
import uim.jsonbase;

class DJsonTenant : IJsonTenant, IJsonCollectionManager {
  this() { initialize; this.className("JsonTenant"); }
  this(IJsonBase aBase) { this(); this.base(aBase); }
  this(string aName) { this(); this.name(aName); }
  this(IJsonBase aBase, string aName) { this(aBase); this.name(aName); }

  void initialize(Json configSettings = Json(null)) { // Hook
  }

  // #region Properties 
    mixin(TProperty!("string", "className"));
    mixin(TProperty!("string", "name"));
    mixin(TProperty!("IJsonBase", "base"));
  // #endregion Properties

  mixin JsonCollectionManagerTemplate!();
}
mixin(JsonTenantCalls!("JsonTenant"));
