class UserModel {
  UserModel({
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
  });

  final String email;
  final String username;
  final String password;
  final String phone;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
        email: json["email"],
        username: json["username"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "password": password,
        "phone": phone,
      };
}

class Address {
  Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  final String city;
  final String street;
  final int number;
  final String zipcode;
  final Geolocation geolocation;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        city: json["city"],
        street: json["street"],
        number: json["number"],
        zipcode: json["zipcode"],
        geolocation: Geolocation.fromJson(json["geolocation"]),
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "street": street,
        "number": number,
        "zipcode": zipcode,
        "geolocation": geolocation.toJson(),
      };
}

class Geolocation {
  Geolocation({
    required this.lat,
    required this.long,
  });

  final String lat;
  final String long;

  factory Geolocation.fromJson(Map<String, dynamic> json) => Geolocation(
        lat: json["lat"],
        long: json["long"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
      };
}

class Name {
  Name({
    required this.firstname,
    required this.lastname,
  });

  final String firstname;
  final String lastname;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        firstname: json["firstname"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
      };
}
