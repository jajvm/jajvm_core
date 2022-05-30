enum JajvmExceptionCode {
  createFolderFailed('create-folder-failed'),
  createLinkFailed('create-link-failed'),
  updateLinkFailed('update-link-failed'),
  updateEnvironmentFailed('update-environment-failed'),
  readEnvironmentFailed('read-environment-failed'),
  administratorRequired('administrator-required'),
  checkAdministratorFailed('check-administrator-failed'),
  readFileFailed('read-file-failed'),
  copyDirectoryFailed('copy-directory-failed'),
  deleteDirectoryFailed('delete-directory-failed');

  final String text;

  const JajvmExceptionCode(this.text);

  @override
  String toString() => text;
}
