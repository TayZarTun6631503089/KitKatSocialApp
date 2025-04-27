class AppUser {
  String uid, email, name;

  AppUser({required this.uid, required this.email, required this.name});

  //Convert App User Into Json

  Map<String, dynamic> toJson() {
    return {"uid": uid, "email": email, "name": name};
  }

  // Json -> App User
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser["uid"],
      email: jsonUser["email"],
      name: jsonUser["name"],
    );
  }
}
