class User {
  String memberId, password, phoneNumber, roomNumber, userName, email, job;
  int userType;
  User(
      {required this.memberId,
      required this.password,
      required this.phoneNumber,
      required this.roomNumber,
      required this.userName,
      required this.email,
      required this.job,
      required this.userType});
}

User user1 = User(
    email: "ahmedmahmoud@gmail.com",
    job: "مهندس",
    memberId: "1234",
    password: "1234",
    phoneNumber: "01112601115",
    roomNumber: "",
    userName: "Ahmed Mahmoud",
    userType: 0);
User user2 = User(
    email: "ahmedmahmoud@gmail.com",
    job: "مهندس",
    memberId: "",
    password: "",
    phoneNumber: "01112601115",
    roomNumber: "1",
    userName: "Khaled Abd El Magid",
    userType: 1);
User user3 = User(
    email: "ahmedmahmoud@gmail.com",
    job: "مهندس",
    memberId: "",
    password: "",
    phoneNumber: "01112601115",
    roomNumber: "123",
    userName: "Mazen Mahmoud",
    userType: 3);
