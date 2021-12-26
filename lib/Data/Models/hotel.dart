class HotelRoom {
  String title;
  String titleImage;
  String description;
  List<String> images;
  int price;
  double rating;

  HotelRoom(
      {required this.description,
      required this.price,
      required this.titleImage,
      required this.rating,
      required this.images,
      required this.title});
}

List<HotelRoom> hotelRoomList = [
  HotelRoom(
      description: "",
      price: 150,
      titleImage: "assets/images/hotel1.jpg",
      rating: 4.5,
      images: ["assets/images/hotel1.jpg", "assets/images/hotel2.jpg"],
      title: "غرفة مفردة"),
  HotelRoom(
      description: "",
      price: 150,
      titleImage: "assets/images/hotel2.jpg",
      rating: 4.5,
      images: ["assets/images/hotel1.jpg", "assets/images/hotel2.jpg"],
      title: "جناح ديلوكس"),
  HotelRoom(
      description: "",
      price: 150,
      titleImage: "assets/images/hotel3.jpg",
      rating: 4.5,
      images: ["assets/images/hotel1.jpg", "assets/images/hotel4.jpg"],
      title: "غرفة ديلوكس مزدوجة مع شرفة")
];
