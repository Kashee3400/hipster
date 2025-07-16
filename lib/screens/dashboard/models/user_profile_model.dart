class UserProfile {
  final int? id;
  final String? name;
  final String? company;
  final String? username;
  final String? email;
  final String? address;
  final String? zip;
  final String? state;
  final String? country;
  final String? phone;
  final String? photo;

  const UserProfile({
    this.id,
    this.name,
    this.company,
    this.username,
    this.email,
    this.address,
    this.zip,
    this.state,
    this.country,
    this.phone,
    this.photo,
  });

  /// Factory constructor to safely parse JSON
  factory UserProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const UserProfile();

    return UserProfile(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      company: json['company']?.toString(),
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      zip: json['zip']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
      phone: json['phone']?.toString(),
      photo: json['photo']?.toString(),
    );
  }

  /// Convert model to JSON, skipping nulls if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'username': username,
      'email': email,
      'address': address,
      'zip': zip,
      'state': state,
      'country': country,
      'phone': phone,
      'photo': photo,
    };
  }

  /// Immutable copy with updated values
  UserProfile copyWith({
    int? id,
    String? name,
    String? company,
    String? username,
    String? email,
    String? address,
    String? zip,
    String? state,
    String? country,
    String? phone,
    String? photo,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      company: company ?? this.company,
      username: username ?? this.username,
      email: email ?? this.email,
      address: address ?? this.address,
      zip: zip ?? this.zip,
      state: state ?? this.state,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email)';
  }
}
