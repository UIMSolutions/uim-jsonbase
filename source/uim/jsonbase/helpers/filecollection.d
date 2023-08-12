module uim.jsonbase.helpers.filecollection;

import uim.jsonbase;

IFolder idFolder(IFolder aFolder, string anId) {
  if (aFolder is null) { return null; }
  if (!aFolder.exists) { return null; }
  if (anId.length == 0) { return null; }
  if (!anId.isUUID) { return null; }

  return aFolder.folder(anId);
}

IFile versionFile(IFolder aFolder, string anId, string versionNo = null) {
  auto myFolder =idFolder(IFolder aFolder, string anId)
}

    IFolder idFolder = folder.folder(myId);
    if (idFolder is null) { return false; }

    if ("versionNumber" !in select) { return false; }
    auto versionNumber = select["versionNumber"].get!size_t;
    
    auto versionFile = idFolder(versionNumber);
    if (versionFile is null) { return false; }