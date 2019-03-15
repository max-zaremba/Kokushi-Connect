library my_prj.globals;

enum AuthStatus {
  notSignedIn,
  signedIn,
}

AuthStatus authStatus = AuthStatus.notSignedIn;