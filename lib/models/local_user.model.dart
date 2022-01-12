class LocalUser {
  final String email;
  final String password;

  LocalUser({
    required this.email,
    required this.password
  });

  static LocalUser Parse(String emailAndPass) {
    return new LocalUser(
        email: emailAndPass.split(':')[0],
        password: emailAndPass.split(':')[1]
    );
  }
}