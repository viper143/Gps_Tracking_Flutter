class AuthenticationModel {
  String companyName;
  String email;
  String role;
  String refreshToken;
  String accessToken;
  List<String> projectName;

  AuthenticationModel(this.companyName, this.email, this.role, this.refreshToken,
      this.accessToken, this.projectName);

  AuthenticationModel.fromJson(Map<String, dynamic> json)
      : companyName = json['companyName'],
        email = json['email'],
        role = json['role'],
        accessToken = json['access_token'],
        projectName = List.from(json['projects']),
        refreshToken = json['refresh_token'];
}
