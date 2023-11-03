module uim.jsonbase.helpers.folder;

import uim.jsonbase;

@safe:
bool folderExists(IFolder aFolder) {
  return (aFolder !is null && aFolder.exists);
}

bool subfolderExists(IFolder aFolder, string aName) {
  return folderExists
    ? aFolder.hasFolder(aName) : false;
}
