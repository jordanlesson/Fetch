import 'package:meta/meta.dart';

class StoreItem {
  final String name;
  final double price;
  final List<String> photos;
  final String description;
  final List<String> sizes;
  final List<String> colors;

  StoreItem({
    @required this.name,
    @required this.price,
    @required this.photos,
    @required this.description,
    this.sizes,
    this.colors,
  });
}

final demoStoreItems = List<StoreItem>.from([
  StoreItem(
    name: "Fetch T-Shirt",
    price: 20.00,
    description: "A Fetch T-Shirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Hoodie",
    price: 30.00,
    description: "A Fetch Hoodie",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Sweatshirt",
    price: 45.00,
    description: "A Fetch Sweatshirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch T-Shirt",
    price: 20.00,
    description: "A Fetch T-Shirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Hoodie",
    price: 30.00,
    description: "A Fetch Hoodie",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Sweatshirt",
    price: 45.00,
    description: "A Fetch Sweatshirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch T-Shirt",
    price: 20.00,
    description: "A Fetch T-Shirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Hoodie",
    price: 30.00,
    description: "A Fetch Hoodie",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Sweatshirt",
    price: 45.00,
    description: "A Fetch Sweatshirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch T-Shirt",
    price: 20.00,
    description: "A Fetch T-Shirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Hoodie",
    price: 30.00,
    description: "A Fetch Hoodie",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
  StoreItem(
    name: "Fetch Sweatshirt",
    price: 45.00,
    description: "A Fetch Sweatshirt",
    photos: [
      "assets/shirt.jpg",
    ],
    colors: [
      "black",
    ],
    sizes: ["s", "m", "l"],
  ),
]);
