// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utility/auth/landing_screen.dart';
import 'package:utility/auth/phoneOtpScreen.dart';
import 'package:utility/model/profile_model.dart';
import 'package:utility/provider/token_http_client.dart' show TokenAwareHttpClient;
import 'package:utility/ui/homeScreen.dart';
import 'package:utility/utils/custom_toast.dart';

class CommonProvider extends ChangeNotifier {
  final String revokeUrl =
      'https://graph.facebook.com/v15.0/oauth/access_token';
  // final String accessToken =
  //     'EAAX3NkCAgccBOw7RciPDy7zBj8y3ZB0YlZAKlUUweXmutYMFQJI1X5t02JCp1vuw7KEtsLqFbHNkpIWqyARC3ZBZAjuWJD5eomA41ugzHsJ3tdI8yzLjCvtEOOlHMxPQqpMtt1QuAqaQgxPakqBwltc2oaaLDsEKZB25rE6mba0Nvis92GAFQc4hMrTy0V1ZCBUwZDZD';
  final String phoneNumberId = '550877591444135';
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isSignedIn = false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneSignUpController = TextEditingController();

  bool isButtonEnabled = false;
  var userName;
  var userId;
  var phoneNumber;
  var signUpSuccess;
  var createdAt;
  int secondsRemaining = 120;
  static const String baseUrl = 'https://api.iotiq.co.in';
  // static const String baseUrl = 'https://utilityiot.onrender.com';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void setLoginLoading(bool val) {
    _isLoggedIn = val;
    notifyListeners();
  }

  bool _isLoadingSignUp = false;
  bool get isLoadingSignUp => _isLoadingSignUp;

  void setLoadingSignUp(bool val) {
    _isLoadingSignUp = val;
    notifyListeners();
  }

  String? _selectedSpaceName;
  String? get selectedSpaceName => _selectedSpaceName;

  void setSelectedSpaceName(String name) {
    _selectedSpaceName = name;
    notifyListeners();
  }

  Future<void> signIn(String mobileNumber, BuildContext context) async {
    const url = '$baseUrl/signin';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'mobile_number': mobileNumber});

    setLoading(true);

    try {
      final response = await TokenAwareHttpClient.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        context: context,
      );

      if (response.statusCode == 200) {
        debugPrint('Success: ${response.body}');
        final responseData = jsonDecode(response.body);
        final success = responseData['success'];
        final message = responseData['message'];

        if (success == true) {
          // Show toast, then navigate
          await CustomToast.showSuccessToast(msg: message);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setLoading(false); // stop loader before navigating
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Phoneotpscreen(phoneNumber: phoneController.text),
              ),
            );
          });
        } else {
          setLoading(false);
          CustomToast.showErrorToast(msg: message);
        }
      } else {
        setLoading(false);
        debugPrint('Failed with status: ${response.statusCode}');
        final responseData = jsonDecode(response.body);
        CustomToast.showErrorToast(msg: "${responseData['message']}");
      }
    } catch (e) {
      debugPrint('Error: $e');
      setLoading(false);
      CustomToast.showErrorToast(msg: "$e");
    }
  }

  Future<void> saveTokens(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  String _accessToken = '';

  String get accessToken => _accessToken;

  void setAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  void setUserName(String? name) {
    userName = name;
    notifyListeners();
  }

  ///verify otp login
  Future<void> verifyOtpLogin(String otp, BuildContext context) async {
    final url = Uri.parse('$baseUrl/signin/otp');
    final body = jsonEncode({
      'mobile_number': phoneController.text,
      'otp': otp,
    });
    setLoginLoading(true);
    try {
      final response = await TokenAwareHttpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
        context: context,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        final token = data['tokens']['accessToken'];
        final refreshToken = data['tokens']['refreshToken'];
        await prefs.setString('refreshToken', refreshToken);
        final commonProvider = Provider.of<CommonProvider>(
          context,
          listen: false,
        );
        await prefs.setString('access_token', token);
        commonProvider.setAccessToken(token); // ✅ Ensure this line is there

        await saveTokens(token);
        debugPrint('OTP verified successfully: $data');
        await prefs.setBool('isLoggedIn', true);

        CustomToast.showSuccessToast(msg: "Sign in successful.");

        await Future.delayed(
          Duration(seconds: 2),
        ); // allow time for token to save
        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Homescreen(startIndex: 1, phoneNumber: userName),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        debugPrint('Failed to verify OTP. Status: ${response.statusCode}');
        final data = jsonDecode(response.body);
        CustomToast.showErrorToast(msg: "${data['message']}");
        debugPrint('Body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      setLoginLoading(false);
    }
  }

  bool isTokenValid(String expiryTime) {
    final expiry = DateTime.parse(expiryTime);
    return DateTime.now().isBefore(expiry);
  }

  bool _isLoggingOut = false;

  Future<void> logout(BuildContext context) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refreshToken');
    await prefs.remove('user_name');
    await prefs.remove('user_id');
    await prefs.remove('mobile_number');
    await prefs.remove('isLoggedIn');

    _isLoggedIn = false;
    _accessToken = '';
    userName = null;
    userId = null;
    phoneNumber = null;

    notifyListeners();

    await CustomToast.showSuccessToast(msg: "Logged out successfully");

    // Delay ensures toast is visible before navigating away
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingScreen()),
        (route) => false,
      );
    });

    _isLoggingOut = false;
  }

  /// signUp
  Future<void> signUp(
    String mobileNumber,
    String userName,
    BuildContext context,
  ) async {
    final url = Uri.parse('$baseUrl/signup');

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'mobile_number': mobileNumber,
      'user_name': userName,
    });
    setLoadingSignUp(true);
    try {
      final response = await TokenAwareHttpClient.post(
        url,
        headers: headers,
        body: body,
        context: context,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        CustomToast.showSuccessToast(msg: "${responseData['message']}");
        debugPrint('Signup successful: $responseData');
      } else {
        debugPrint('Signup failed: ${response.statusCode}');
        final responseData = jsonDecode(response.body);
        CustomToast.showErrorToast(msg: "${responseData['message']}");
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint('Error occurred during signup: $e');
      CustomToast.showErrorToast(msg: '$e');
      setLoadingSignUp(false);
    }
  }

  bool get isSignedIn => _isSignedIn;

  /// verify otp signup
  /// Verify OTP during signup process
  Future<void> verifyOtpSignup(String otp, BuildContext context) async {
    final url = Uri.parse('$baseUrl/signup/otp');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'mobile_number': phoneSignUpController.text,
      'otp': otp,
    });

    _isSignedIn = true;

    try {
      final response = await TokenAwareHttpClient.post(
        url,
        headers: headers,
        body: body,
        context: context,
      );

      final data = jsonDecode(response.body);
      print("Response data: $data");

      if (data['user'] != null && data['tokens'] != null) {
        final prefs = await SharedPreferences.getInstance();

        // Assuming `data['success']` is a bool
        bool signUpSuccess = data['success'];
        String token = data['tokens']['accessToken'];
        String refreshToken = data['tokens']['refreshToken'];

        // Save access and refresh tokens
        await prefs.setString('access_token', token);
        await prefs.setString('refreshToken', refreshToken);

        // Save success as bool (correct type)
        await prefs.setBool('success', signUpSuccess);

        // Update app-wide access token via Provider
        final commonProvider = Provider.of<CommonProvider>(
          context,
          listen: false,
        );
        commonProvider.setAccessToken(token);

        // Show success toast
        CustomToast.showSuccessToast(msg: "${data['message']}");

        // Navigate to Home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Homescreen(startIndex: 1, phoneNumber: userName),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        // Error from backend
        CustomToast.showErrorToast(
          msg: data['message'] ?? "OTP verification failed",
        );
      }
    } catch (e) {
      debugPrint('Error during OTP verification: $e');
      CustomToast.showErrorToast(msg: "$e");
      _isSignedIn = false;
    }
  }

  Future<bool> refreshAccessToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint("⚠️ No refresh token found in SharedPreferences.");
      logout(context);
      return false;
    }

    const url = '$baseUrl/refresh-token';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'refreshToken': refreshToken});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("🔄 Token refresh response: $data");

        final newAccessToken =
            data['tokens']?['accessToken'] ?? data['accessToken'];
        final newRefreshToken =
            data['tokens']?['refreshToken'] ?? data['refreshToken'];

        debugPrint("New access token: $newAccessToken");
        debugPrint("New refresh token: $newRefreshToken");

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await prefs.setString('access_token', newAccessToken);
          setAccessToken(newAccessToken);
        } else {
          debugPrint("⚠️ Access token missing or empty in refresh response");
          logout(context);
          return false;
        }

        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await prefs.setString('refreshToken', newRefreshToken);
        }

        debugPrint("✅ Access token refreshed successfully.");
        return true;
      } else {
        debugPrint(
          "❌ Failed to refresh token: ${response.statusCode} ${response.body}",
        );
        logout(context);
        return false;
      }
    } catch (e) {
      debugPrint("🔥 Error during token refresh: $e");
      logout(context);
      return false;
    }
  }

  GetUserProfileModel? getUserProfileModel;
  Future<GetUserProfileModel?> fetchUserProfile(BuildContext context) async {
    final url = Uri.parse('$baseUrl/user');
    final token = Provider.of<CommonProvider>(
      context,
      listen: false,
    ).accessToken;
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await TokenAwareHttpClient.get(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        getUserProfileModel = getUserProfileModelFromJson(response.body);
        final prefs = await SharedPreferences.getInstance();
        userName = getUserProfileModel!.data!.userName;
        phoneNumber = getUserProfileModel!.data!.mobileNumber;
        createdAt = getUserProfileModel!.data!.createdAt;
        userId = getUserProfileModel!.data!.id;

        await prefs.setString('user_name', userName);
        await prefs.setString('mobile_number', phoneNumber);
        await prefs.setString('id', userId);

        notifyListeners(); // ✅ THIS is what you're missing

        return getUserProfileModel;
      } else {
        print(
          "Failed to load user profile. Status Code: ${response.statusCode}",
        );
        return null;
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
  }

  Future<void> ensureValidToken(BuildContext context) async {
    // Implement logic to decode token and check expiry
    // OR always call refresh token before sensitive APIs
    await refreshAccessToken(context);
  }
}
