class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Easy products and sales management',
      image: 'assets/images/Easy Product.png',
      description:
          "Effortlessly manage all your store transactions and products in one app"),
  UnbordingContent(
      title: 'Choose your own payment method',
      image: 'assets/images/Many Payment.png',
      description:
          "Seamless payout with various payment method you can choose from"),
  UnbordingContent(
      title: 'Manage branch  without worries',
      image: 'assets/images/Manage branch.png',
      description:
          "Track all your store branches and operation with confidence"),
];
