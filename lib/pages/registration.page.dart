import 'package:flutter/material.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';
import 'package:deliver_gaz/services.dart';
import 'signin.page.dart';

// Registration Page with User Information State Management
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // User information state
  Map<String, String> _userInfo = {};
  bool _isRegistered = false;
  bool _isLoading = false;
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now();
  bool _agreeToTerms = false;

  // Validation states for real-time feedback
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Real-time validation methods
  void _validateFirstName(String value) {
    setState(() {
      _isFirstNameValid = value.isNotEmpty;
    });
  }

  void _validateLastName(String value) {
    setState(() {
      _isLastNameValid = value.isNotEmpty;
    });
  }

  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = value.isNotEmpty && 
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    });
  }

  void _validatePhone(String value) {
    setState(() {
      _isPhoneValid = value.isNotEmpty;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.isNotEmpty && value.length >= 6;
    });
    // Also revalidate confirm password when password changes
    _validateConfirmPassword(_confirmPasswordController.text);
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      _isConfirmPasswordValid = value.isNotEmpty && 
          value == _passwordController.text;
    });
  }

  // Helper method to get border color based on validation state
  Color _getBorderColor(bool isValid, String value) {
    if (value.isEmpty) {
      return Colors.grey; // Default color for empty fields
    }
    return isValid ? Colors.green : Colors.red;
  }

  void _submitRegistration() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userApiClient = UserApiClient();
        final authResult = await userApiClient.register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim(),
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.welcomeRegistrationSuccess(authResult.user.firstName)),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to sign in page after successful registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          String errorMessage = AppLocalizations.of(context)!.registrationFailed;
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
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseAgreeToTerms),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _clearForm() {
    setState(() {
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _selectedGender = 'Male';
      _selectedDate = DateTime.now();
      _agreeToTerms = false;
      _userInfo = {};
      _isRegistered = false;
      // Reset validation states
      _isFirstNameValid = false;
      _isLastNameValid = false;
      _isEmailValid = false;
      _isPhoneValid = false;
      _isPasswordValid = false;
      _isConfirmPasswordValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registration),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isRegistered)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _clearForm,
              tooltip: AppLocalizations.of(context)!.clearForm,
            ),
        ],
      ),
      body: _isRegistered ? _buildUserProfile() : _buildRegistrationForm(),
    );
  }

  Widget _buildRegistrationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.createYourAccount,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // First Name
            TextFormField(
              controller: _firstNameController,
              onChanged: _validateFirstName,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.firstName,
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isFirstNameValid, _firstNameController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isFirstNameValid, _firstNameController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isFirstNameValid, _firstNameController.text),
                    width: 2.0,
                  ),
                ),
                suffixIcon: _firstNameController.text.isNotEmpty
                    ? Icon(
                        _isFirstNameValid ? Icons.check_circle : Icons.error,
                        color: _isFirstNameValid ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Last Name
            TextFormField(
              controller: _lastNameController,
              onChanged: _validateLastName,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.lastName,
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isLastNameValid, _lastNameController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isLastNameValid, _lastNameController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isLastNameValid, _lastNameController.text),
                    width: 2.0,
                  ),
                ),
                suffixIcon: _lastNameController.text.isNotEmpty
                    ? Icon(
                        _isLastNameValid ? Icons.check_circle : Icons.error,
                        color: _isLastNameValid ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: _validateEmail,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isEmailValid, _emailController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isEmailValid, _emailController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
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
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: _validatePhone,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.phoneNumber,
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPhoneValid, _phoneController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPhoneValid, _phoneController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPhoneValid, _phoneController.text),
                    width: 2.0,
                  ),
                ),
                suffixIcon: _phoneController.text.isNotEmpty
                    ? Icon(
                        _isPhoneValid ? Icons.check_circle : Icons.error,
                        color: _isPhoneValid ? Colors.green : Colors.red,
                      )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Gender Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.gender,
                prefixIcon: const Icon(Icons.wc),
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: 'Male',
                  child: Text(AppLocalizations.of(context)!.male),
                ),
                DropdownMenuItem<String>(
                  value: 'Female',
                  child: Text(AppLocalizations.of(context)!.female),
                ),
                DropdownMenuItem<String>(
                  value: 'Other',
                  child: Text(AppLocalizations.of(context)!.other),
                ),
              ],
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Date of Birth
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.dateOfBirth,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDate.toLocal().toString().split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              onChanged: _validatePassword,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.password,
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPasswordValid, _passwordController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPasswordValid, _passwordController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isPasswordValid, _passwordController.text),
                    width: 2.0,
                  ),
                ),
                suffixIcon: _passwordController.text.isNotEmpty
                    ? Icon(
                        _isPasswordValid ? Icons.check_circle : Icons.error,
                        color: _isPasswordValid ? Colors.green : Colors.red,
                      )
                    : null,
                helperText: 'Password must be at least 6 characters',
                helperStyle: TextStyle(
                  color: _passwordController.text.isNotEmpty
                      ? (_isPasswordValid ? Colors.green : Colors.red)
                      : Colors.grey,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              onChanged: _validateConfirmPassword,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.confirmPassword,
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isConfirmPasswordValid, _confirmPasswordController.text),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isConfirmPasswordValid, _confirmPasswordController.text),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _getBorderColor(_isConfirmPasswordValid, _confirmPasswordController.text),
                    width: 2.0,
                  ),
                ),
                suffixIcon: _confirmPasswordController.text.isNotEmpty
                    ? Icon(
                        _isConfirmPasswordValid ? Icons.check_circle : Icons.error,
                        color: _isConfirmPasswordValid ? Colors.green : Colors.red,
                      )
                    : null,
                helperText: 'Passwords must match',
                helperStyle: TextStyle(
                  color: _confirmPasswordController.text.isNotEmpty
                      ? (_isConfirmPasswordValid ? Colors.green : Colors.red)
                      : Colors.grey,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Terms and Conditions
            CheckboxListTile(
              title: Text(AppLocalizations.of(context)!.agreeToTerms),
              value: _agreeToTerms,
              onChanged: (bool? value) {
                setState(() {
                  _agreeToTerms = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),

            // Register Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.creatingAccount)
                    ],
                  )
                : Text(
                    AppLocalizations.of(context)!.register,
                    style: const TextStyle(fontSize: 16),
                  ),
            ),

            const SizedBox(height: 30),

            // Back to Sign In Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.alreadyHaveAccount,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.signIn,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Registration Successful!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const Text(
            'User Information:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow('First Name', _userInfo['firstName'] ?? ''),
                  _buildInfoRow('Last Name', _userInfo['lastName'] ?? ''),
                  _buildInfoRow('Email', _userInfo['email'] ?? ''),
                  _buildInfoRow('Phone', _userInfo['phone'] ?? ''),
                  _buildInfoRow('Gender', _userInfo['gender'] ?? ''),
                  _buildInfoRow('Date of Birth', _userInfo['dateOfBirth'] ?? ''),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: _clearForm,
              icon: const Icon(Icons.refresh),
              label: const Text('Register Another User'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}