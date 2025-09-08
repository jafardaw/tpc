class OnBoarding {
  String title;
  String description;
  String image;

  OnBoarding({
    required this.title,
    required this.description,
    required this.image,
  });
}

List<OnBoarding> onBoardinglist = [
  OnBoarding(
    title: 'Efficient Inventory Management',
    image: "assets/json/onboarding1.json",
    description:
        'A comprehensive system for managing raw materials and products, helping you track quantities, categorize items, and receive alerts when stock is low.',
  ),
  OnBoarding(
    title: 'Cost Analysis and Accurate Pricing',
    image: "assets/json/onboarding2.json",
    description:
        'An interactive platform to calculate estimated and actual costs, allowing you to optimize profit margins and make more informed financial decisions.',
  ),
  OnBoarding(
    title: 'User Management and Access Control',
    image: "assets/json/onboarding3.json",
    description:
        'Define user roles such as Manager, Accountant, and Warehouse Keeper with tailored permissions to ensure data security and seamless administration.',
  ),
];