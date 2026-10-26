class UserAccount {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String tableNumber;
  final bool isGuest;
  final int stampsCount;

  const UserAccount({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.tableNumber = 'Mesa 14',
    this.isGuest = false,
    this.stampsCount = 7,
  });

  UserAccount copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? tableNumber,
    bool? isGuest,
    int? stampsCount,
  }) {
    return UserAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      tableNumber: tableNumber ?? this.tableNumber,
      isGuest: isGuest ?? this.isGuest,
      stampsCount: stampsCount ?? this.stampsCount,
    );
  }
}
