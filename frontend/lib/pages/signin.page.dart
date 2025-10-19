import 'package:flutter/material.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';
import 'package:deliver_gaz/services.dart';
import 'home.page.dart';
import 'registration.page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables
  bool _isSignedIn = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Real-time validation states
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  // User info after sign in
  Map<String, String> _userInfo = {};

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  /// Check for existing user session and auto-login if valid
  void _checkExistingSession() async {
    try {
      final sessionData = await SessionStorage.getSession();
      
      if (sessionData != null && !sessionData.isExpired) {
        // Valid session found, navigate to home page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(title: 'DeliverGaz'),
            ),
          );
          
          // Show welcome back message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.welcomeBackUser(sessionData.user.firstName)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // No valid session, pre-fill form with test credentials for demo
        _emailController.text = 'john.doe@example.com';
        _passwordController.text = 'password123';
        // Trigger validation for pre-filled values
        _validateEmail(_emailController.text);
        _validatePassword(_passwordController.text);
        
        // Check if remember me was previously set
        final rememberMe = await SessionStorage.getRememberMe();
        setState(() {
          _rememberMe = rememberMe;
        });
      }
    } catch (e) {
      // Error checking session, continue with normal flow
      _emailController.text = 'john.doe@example.com';
      _passwordController.text = 'password123';
      _validateEmail(_emailController.text);
      _validatePassword(_passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Real-time validation methods
  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = value.isNotEmpty && 
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.isNotEmpty && value.length >= 6;
    });
  }

  // Helper method to get border color based on validation state
  Color _getBorderColor(bool isValid, String value) {
    if (value.isEmpty) {
      return Colors.grey;
    }
    return isValid ? Colors.green : Colors.red;
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userApiClient = UserApiClient();
        final authResult = await userApiClient.login(
          _emailController.text.trim(),
          _passwordController.text
        );

        // Save session if remember me is enabled or if this is successful login
        await SessionStorage.saveSession(
          user: authResult.user,
          token: authResult.token,
          expiresAt: authResult.expiresAt,
          rememberMe: _rememberMe,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to home page on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(title: 'DeliverGaz')
            ),
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.welcomeBackUser(authResult.user.firstName)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          String errorMessage = AppLocalizations.of(context)!.loginFailed;
          if (e is ApiException) {
            errorMessage = e.message;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _signOut() async {
    // Clear session storage
    await SessionStorage.clearSession();
    
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _rememberMe = false;
      _isSignedIn = false;
      _userInfo = {};
      _isEmailValid = false;
      _isPasswordValid = false;
    });
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.forgotPasswordTitle),
          content: Text(AppLocalizations.of(context)!.forgotPasswordMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.signIn),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isSignedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
              tooltip: i10n.signOut,
            ),
        ],
      ),
      body: _isSignedIn ? _buildWelcomeScreen() : _buildSignInForm(),
    );
  }

  Widget _buildSignInForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            
            // Welcome message
            const Icon(
              Icons.lock_person,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.welcomeBack,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.signInToYourAccount,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Demo Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.demoMode,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Email field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: _validateEmail,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                helperText: AppLocalizations.of(context)!.prefilledEmailHelper,
                helperStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _getBorderColor(_isEmailValid, _emailController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _getBorderColor(_isEmailValid, _emailController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _getBorderColor(_isEmailValid, _emailController.text),
                    width: 2.0,
                  ),
                ),
                suffixIcon: _emailController.text.isNotEmpty
                    ? Icon(
                        _isEmailValid ? Icons.check_circle : Icons.error,
                        color: _isEmailValid ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterEmail;
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return AppLocalizations.of(context)!.pleaseEnterValidEmail;
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              onChanged: _validatePassword,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                helperText: AppLocalizations.of(context)!.prefilledPasswordHelper,
                helperStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPasswordValid, _passwordController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPasswordValid, _passwordController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPasswordValid, _passwordController.text),
                    width: 2.0,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_passwordController.text.isNotEmpty)
                      Icon(
                        _isPasswordValid ? Icons.check_circle : Icons.error,
                        color: _isPasswordValid ? Colors.green : Colors.red,
                      ),
                    IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ],
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterPassword;
                }
                if (value.length < 6) {
                  return AppLocalizations.of(context)!.passwordMustBe6Characters;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Remember me and Forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text(AppLocalizations.of(context)!.rememberMe),
                  ],
                ),
                TextButton(
                  onPressed: _forgotPassword,
                  child: Text(AppLocalizations.of(context)!.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Sign In Button
            ElevatedButton(
              onPressed: _isLoading ? null : _signIn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.signIn,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),

            // Divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(AppLocalizations.of(context)!.or),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),

            // Social sign in buttons
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.googleSignInNotImplemented)),
                );
              },
              icon: const Icon(Icons.g_mobiledata, color: Colors.red),
              label: Text(AppLocalizations.of(context)!.continueWithGoogle),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.dontHaveAccount),
                TextButton(
                  onPressed: () {
                    // Navigate to registration page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.signUp,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.welcome,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.successfullySignedIn,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.sessionInformation,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(AppLocalizations.of(context)!.email, _userInfo['email'] ?? ''),
                  _buildInfoRow(AppLocalizations.of(context)!.signInTime, _formatDateTime(_userInfo['signInTime'] ?? '')),
                  _buildInfoRow(AppLocalizations.of(context)!.rememberMe, _userInfo['rememberMe'] == 'true' ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          ElevatedButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            label: Text(AppLocalizations.of(context)!.signOut),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    if (dateTimeString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }
}