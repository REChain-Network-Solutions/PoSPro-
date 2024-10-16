import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
  });
}

// Our demo Products

List<Product> demoCategory = [
  Product(
    id: 1,
    images: [
      "images/profile.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Mobile",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "images/profile.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Laptop",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "images/profile.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Tab",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "images/p1.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Mouse",
    price: 20.20,
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];

List<Product> demoProduct = [
  Product(
    id: 1,
    images: [
      "images/profile.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Shoe Sneakers",
    price: 64.99,
    description: 'description',
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 2,
    images: [
      "images/profile.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Woman Dress",
    price: 50.5,
    description: 'description',
    rating: 4.1,
    isPopular: true,
  ),
  Product(
    id: 3,
    images: [
      "images/profile.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Tab",
    price: 36.55,
    description: 'description',
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  Product(
    id: 4,
    images: [
      "images/profile.png",
    ],
    colors: const [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Shoe Sneakers",
    price: 20.20,
    description: 'description',
    rating: 4.1,
    isFavourite: true,
  ),
];

const String description = "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
