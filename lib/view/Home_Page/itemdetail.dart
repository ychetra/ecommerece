import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gridview_6_pages/model/products.dart';
import 'package:gridview_6_pages/view/Home_Page/home_cart.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDetailPage extends StatelessWidget {
  final Products product;

  const ItemDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Handle product images, providing a placeholder if none exist
    List<String> productImages =
        product.images ?? ['https://via.placeholder.com/150'];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      carouselSection(productImages),
                      const SizedBox(height: 20),
                      productDetails(),
                      const SizedBox(height: 20),
                      productDescription(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                // Back Button (top left)
                Positioned(
                  top: 20,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.blue,
                      iconSize: 30,
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                // Shopping Cart Button (top right)
                Positioned(
                  top: 20,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      color: Colors.blue,
                      iconSize: 30,
                      onPressed: () {
                        Get.to(const HomeCart());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          productDetailsFooter(),
        ],
      ),
    );
  }

  Widget carouselSection(List<String> images) {
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 50,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 400,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }

  Widget productDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title ?? "No Title",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "\$${product.price?.toString() ?? '0.00'}",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget productDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        product.description ?? "No Description Available",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget productDetailsFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(25),
        color: Colors.blue.shade400,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add to Cart',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: () {
          // Handle add to cart action
          Get.to(const HomeCart());
        },
      ),
    );
  }
}
