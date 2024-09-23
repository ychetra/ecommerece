import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gridview_6_pages/model/products.dart';
import 'package:gridview_6_pages/view/Home_Page/itemdetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class ProductGridPage extends StatefulWidget {
  @override
  _ProductGridPageState createState() => _ProductGridPageState();
}

class _ProductGridPageState extends State<ProductGridPage> {
  List<Products> productList = [];
  int currentPage = 1;
  final int itemsPerPage = 10;
  bool isLoading = false; // Flag to track loading state
  bool hasMoreProducts = true; // Flag to track if there are more products

  @override
  void initState() {
    super.initState();
    fetchMoreProducts();
  }

  Future<void> fetchMoreProducts() async {
    if (isLoading || !hasMoreProducts) return;

    setState(() {
      isLoading = true; // Set loading to true when fetching begins
    });

    try {
      final products = await fetchProducts(currentPage, itemsPerPage);
      if (products.isNotEmpty) {
        setState(() {
          productList.addAll(products);
          currentPage++;
        });
      } else {
        // If no products are returned, set hasMoreProducts to false
        setState(() {
          hasMoreProducts = false;
        });
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching completes
      });
    }
  }

  Future<List<Products>> fetchProducts(int page, int limit) async {
    final response = await http.get(Uri.parse(
        'https://api.escuelajs.co/api/v1/products?offset=${(page - 1) * limit}&limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> productJson = jsonDecode(response.body);
      return productJson
          .map<Products?>((json) {
            Products product = Products.fromJson(json);
            if (product.images != null && product.images!.isNotEmpty) {
              final imageUrl = product.images![0];
              // Ensure the image URL starts with a valid scheme
              if (Uri.tryParse(imageUrl)?.isAbsolute == true) {
                return product;
              }
            }
            return null; // Skip products with invalid images
          })
          .where((product) => product != null)
          .cast<Products>()
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent &&
              !isLoading &&
              hasMoreProducts) {
            fetchMoreProducts();
          }
          return false;
        },
        child: GridView.builder(
          itemCount: productList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = productList[index];
            return GestureDetector(
              onTap: () {
                Get.to(ItemDetailPage(product: product));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: product.images![0],
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        product.title ?? "No Title",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "\$${product.price.toString()}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
