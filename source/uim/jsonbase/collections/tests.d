module uim.jsonbase.collections.tests;

@safe:
import uim.jsonbase;

bool test_findMany(DJDBCollection col) {
  col.insertOne(toJson(randomUUID, 22));
  return col.findMany.length > 0;
}

bool test_findMany_allVersions(DJDBCollection col) {
  col.insertOne(toJson(randomUUID, 22));
  return col.findMany(true).length > 0;
}

bool test_findMany_id(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  col.insertOne(json);
  return col.findMany(UUID(json["id"].get!string)).length > 0;
}

bool test_findMany_id_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  col.insertOne(json);
  return col.findMany(UUID(json["id"].get!string), true).length > 0;
}

bool test_findMany_select(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findMany(["name":"test"]).length > 0;
}

bool test_findMany_select_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findMany(["name":"test"], true).length > 0;
}

bool test_findMany_jselect(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findMany(json).length > 0;
}

bool test_findMany_jselect_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findMany(json, true).length > 0;
}

bool test_findOne_id(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  col.insertOne(json);
  return col.findOne(UUID(json["id"].get!string)) != Json(null);
}

bool test_findOne_id_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  col.insertOne(json);
  return col.findOne(UUID(json["id"].get!string), true) != Json(null);
}

bool test_findOne_id_versionNumber(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  col.insertOne(json);
  return col.findOne(UUID(json["id"].get!string), 22) != Json(null);
}

bool test_findOne_select(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findOne(["name":"test"]) != Json(null);
}

bool test_findOne_select_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findOne(["name":"test"], true) != Json(null);
}

bool test_findOne_jselect(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findOne(json) != Json(null);
}

bool test_findOne_jselect_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  json["name"] = "test";
  col.insertOne(json);
  return col.findOne(json, true) != Json(null);
}

bool test_insertOne_data(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  col.insertOne(json);
  return col.findOne(json) != Json(null);
}

bool test_updateMany_jselect_data(DJDBCollection col) {
  auto json1 = toJson(randomUUID, 22);
  col.insertOne(json1);
  auto json2 = toJson(randomUUID, 20);
  col.insertOne(json2);
  
  col.updateMany(json);
  return col.findOne(json) != Json(null);
}

bool test_updateOne_jselect_data(DJDBCollection col) {
  auto json = toJson(randomUUID, 22);
  col.insertOne(json);
  return col.findOne(json) != Json(null);
}

bool test_removeOne_id(DJDBCollection col) {
  auto json = toJson(randomUUID, 20);
  col.insertOne(json);
  return col.removeOne(UUID(json["id"].get!string));
}

bool test_removeOne_id_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 20);
  col.insertOne(json);
  return col.removeOne(UUID(json["id"].get!string, true));
}

bool test_removeOne_id_versionNumber(DJDBCollection col) {
  auto json = toJson(randomUUID, 20);
  col.insertOne(json);
  return col.removeOne(UUID(json["id"].get!string, json["versionNumber"].get!size_t));
}

bool test_removeOne_select(DJDBCollection col) {
  auto json = toJson(randomUUID, 20);
  col.insertOne(json);
  auto data = ["id": json["id"].get!string, "versionNumber":json["versionNumber"].toString];
  return col.removeOne(data);
}

bool test_removeOne_select_allVersions(DJDBCollection col) {
  auto json = toJson(randomUUID, 21);
  col.insertOne(json);
  auto data = ["id": json["id"].get!string];
  return col.removeOne(data);
}

bool test_removeOne_jselect(DJDBCollection col) {
  auto json = col.insertOne(toJson(randomUUID, 22));
  return col.removeOne(json);
}

bool test_removeOne_jselect_allVersions(DJDBCollection col) {
  auto json = col.insertOne(toJson(randomUUID, 23));
  return col.removeOne(UUID(json["id"].get!string));
}