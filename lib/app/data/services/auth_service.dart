// File: app/data/services/auth_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _userKey = 'user';
  final _credentialsKey = 'credentials';

  // Simulated user for testing
  final _testUser = UserModel(
    id: '1',
    username: 'testuser',
    email: 'test@example.com',
  );

  // User observable
  final Rxn<UserModel> _user = Rxn<UserModel>();
  UserModel? get user => _user.value;
  bool get isLoggedIn => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    // Try to get user from storage
    final userData = _storage.read(_userKey);
    if (userData != null) {
      _user.value = UserModel.fromJson(userData);
    }
  }

  // Simulated login
  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo, we'll accept only one credential set
    if (email == 'test@example.com' && password == 'password123') {
      _user.value = _testUser;
      
      // Store user data
      await _storage.write(_userKey, _testUser.toJson());
      
      // Store credentials (in a real app, you would NEVER do this - for demo only)
      await _storage.write(_credentialsKey, {'email': email, 'password': password});
      
      return true;
    }
    
    return false;
  }

  // Simulated register
  Future<bool> register(String username, String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo, we'll accept any registration
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: email,
    );
    
    _user.value = newUser;
    
    // Store user data
    await _storage.write(_userKey, newUser.toJson());
    
    // Store credentials (in a real app, you would NEVER do this - for demo only)
    await _storage.write(_credentialsKey, {'email': email, 'password': password});
    
    return true;
  }

  // Simulated OTP verification
  Future<bool> verifyOtp(String email, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo, accept any 6-digit OTP
    return otp.length == 6;
  }

  // Simulated password reset
  Future<bool> resetPassword(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For demo, accept any email
    return true;
  }

  // Logout
  Future<void> logout() async {
    _user.value = null;
    await _storage.remove(_userKey);
  }
  
  // New methods for profile management
  
  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Get stored credentials (in a real app, you would verify with the backend)
      final credentials = _storage.read(_credentialsKey);
      
      if (credentials != null && credentials['password'] == currentPassword) {
        // Update password in stored credentials
        credentials['password'] = newPassword;
        await _storage.write(_credentialsKey, credentials);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Delete account
  Future<bool> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Get stored credentials (in a real app, you would verify with the backend)
      final credentials = _storage.read(_credentialsKey);
      
      if (credentials != null && 
          credentials['email'] == email && 
          credentials['password'] == password) {
        
        // Remove user data and credentials
        await _storage.remove(_userKey);
        await _storage.remove(_credentialsKey);
        
        // Clear current user
        _user.value = null;
        
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
}