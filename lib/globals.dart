library my_prj.globals;

bool hasDojo = false;

enum AuthStatus {
  notSignedIn,
  signedIn,
}

AuthStatus authStatus = AuthStatus.notSignedIn;

