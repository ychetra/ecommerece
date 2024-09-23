import 'package:get/get.dart';
import 'package:gridview_6_pages/model/user.dart';
import 'package:gridview_6_pages/view/Home_Page/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthController extends GetxController {
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<void> login(String email, String password) async {
    try {
      _isLoading.value = true;

      // Replace with your actual API URL
      final url = 'https://yourapi.com/login'; 

      // Sending a POST request to the login endpoint
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse response and navigate if successful
        final jsonResponse = jsonDecode(response.body);
        User user = User.fromJson(jsonResponse);

        // Navigate to Home Page if successful
        Get.to(Home(), arguments: user);
      } else {
        Get.snackbar("Error", "Incorrect email or password");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Try again later.");
    } finally {
      _isLoading.value = false;
    }
  }
}
