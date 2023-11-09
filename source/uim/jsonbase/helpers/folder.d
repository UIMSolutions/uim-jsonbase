module uim.jsonbase.helpers.folder;

import uim.jsonbase;

@safe:
bool folderExists(IFolder aFolder) {
  return (aFolder !is null && aFolder.exists);
}

bool subfolderExists(IFolder aFolder, string aName) {
<<<<<<< HEAD
  return folderExists(aFolder)
    ? aFolder.folder(aName) !is null
    : false;
}
=======
  return folderExists
    ? aFolder.hasFolder(aName) : false;
}
>>>>>>> ca5f58dc7f635b04388aff8bf32397e11e9cfb0a
