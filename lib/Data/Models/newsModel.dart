class NewsModel {
  DateTime newsDate;
  String newsImagePath,
      numberOfViews,
      newsDesc,
      newsTitle,
      totalLikes,
      totalComments,
      totalShares;
  NewsModel(
      {required this.newsDate,
      required this.newsDesc,
      required this.newsImagePath,
      required this.newsTitle,
      required this.numberOfViews,
      required this.totalComments,
      required this.totalLikes,
      required this.totalShares});
}

List<NewsModel> tempNewsList = [
  NewsModel(
      newsDate: DateTime.now(),
      newsDesc:
          "تحتوي الدار على فندقين للاقامة و٧ قاعات بالإضافة لعدة مطاعم ووسائل متعددة للترفيه وممارسة الرياضة بخدمات على أعلى مستوىو",
      newsTitle:
          " تحتوي الدار على فندقين للاقامة و٧ قاعات بالإضافة لعدة مطاعم ووسائل متعددة للترفيه وممارسة الرياضة بخدمات على أعلى مستوى",
      newsImagePath:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEQdWAupQNJ7e62u_nwnl3K8_wgPtrEQOc40FF75exdcj5DI6mUbt-FmTNiIz8YXvB98c&usqp=CAU",
      numberOfViews: "4214",
      totalComments: "1231",
      totalLikes: "14",
      totalShares: "4"),
  NewsModel(
      newsDate: DateTime.now(),
      newsDesc:
          "يقيم الاتحاد المصري للكاراتيه، غدًا الأربعاء، في دار الدفاع الجوي بالتجمع الخامس احتفالية تكريم لاعبى منتخب الناشئين والشباب وتحت 23 عامًا الفائزين بميداليات",
      newsTitle: "«الكاراتيه» يقيم احتفالية لأبطاله في دار الدفاع الجوي",
      newsImagePath: "https://i.ytimg.com/vi/VJoS2qPq8hs/maxresdefault.jpg",
      numberOfViews: "4214",
      totalComments: "121",
      totalLikes: "144",
      totalShares: "24"),
  NewsModel(
      newsDate: DateTime.now(),
      newsTitle: "عايز تخرج فى مكان جديد ومحتار تروح فين🤔",
      newsDesc:
          "عشان يوم فرحك يوم مش عادى لازم تعمل فوتسيشن فى مكان مش عادى🥰 دار الدفاع الجوى تصميم هندسى رائع يشرفك بأحدث الديكورات🔥❤ أكثر من لوكيشن يعنى خد راحتك فى الصور😎 هتكون أحلى ذكرى فى أجمل مكان هتدوم العمر كله😘 كمان لو حجزت معانا هتاخد غرفة فى الفندق ودخول الميكب أرتيست مجانا🔥😳 يلا مستنى اية أحجز الان العرض لفترة محدودة",
      newsImagePath:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfg6xZ8rgMuwvwnA6twXi3UAPscLhRlL-gfnQWjzjZyj9nKYBpJduvKw3qNoTxJv57Xb0&usqp=CAU",
      numberOfViews: "1321",
      totalComments: "222",
      totalLikes: "3",
      totalShares: "14")
];
