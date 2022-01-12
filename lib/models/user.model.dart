const ID = 'Ma';
const ROLES = 'CoVaiTro';
const CUSTOMER = 'NguoiDung';
const ADMIN = 'QuanTri';
const EMAIL = 'Email';

class User {
  late String id;
  late String email;
  late Map roles = {
    CUSTOMER: bool,
    ADMIN: bool
  };

  User() {
    roles[CUSTOMER] = true;
  }

  Map<String, dynamic> toMap() => {
    ID: id,
    ROLES: roles,
    EMAIL: email
  };

  User.fromMap(Map<String, dynamic> map):
        assert(map[ID] != null),
        id = map[ID],
        email = map[EMAIL],
        roles = map[ROLES];
}