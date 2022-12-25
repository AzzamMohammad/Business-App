class User{
  late int country;
  late int city;
  late int town;
  late String firstName;
  late String lastName;
  late String userGender;
  late DateTime dateOfBirth;
  late String email;
  late String password;
  late String? countryCodeNumber;
  late String? phoneNumber;
  late String? telephoneNumber;
  late String? locationDescription;

  User({
    required this.country,
    required this.city,
    required this.town,
    required this.firstName,
    required this.lastName,
    required this.userGender,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    this.countryCodeNumber,
    this.phoneNumber,
    this.telephoneNumber,
    this.locationDescription,
});
}