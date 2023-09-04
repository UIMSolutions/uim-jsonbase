module uim.jsonbase.helpers.filecollection;

import uim.jsonbase;

@safe:
IFolder idFolder(IFolder aFolder, UUID anId) {
  return idFolder(aFolder, anId.toString);
}

IFolder idFolder(IFolder aFolder, string anId) {
  if (aFolder is null || !aFolder.exists) { return null; }
  if (!anId.isUUID) { return null; }

  return aFolder.folder(anId);
}

IFile[] versionFiles(IFolder aFolder, string anId) {
  auto idFolder = idFolder(aFolder, anId);
  if (idFolder is null) { return null; }

  return idFolder.files();
}

IFile versionFile(IFolder aFolder, string anId, string aVersionNumber = null) {
  auto idFolder = idFolder(aFolder, anId);
  if (idFolder is null) { return null; }

  auto versionFile = idFolder.file(aVersionNumber); // TODO not working
  return (versionFile? versionFile : null);
}
