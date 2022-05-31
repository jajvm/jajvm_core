enum JajvmExceptionCode {
  createDirectoryFailed('create-folder-failed'),
  copyDirectoryFailed('copy-directory-failed'),
  deleteDirectoryFailed('delete-directory-failed'),
  readDirectoryFailed('read-directory-failed'),
  listReleasesFailed('list-releases-failed'),

  createLinkFailed('create-link-failed'),
  updateLinkFailed('update-link-failed'),
  readLinkFailed('read-link-failed'),

  updateEnvironmentFailed('update-environment-failed'),
  readEnvironmentFailed('read-environment-failed'),

  administratorRequired('administrator-required'),
  checkAdministratorFailed('check-administrator-failed'),

  readFileFailed('read-file-failed'),

  cannotRemoveDefaultRelease('cannot-remove-default-release');

  final String text;

  const JajvmExceptionCode(this.text);

  @override
  String toString() => text;
}
