import 'package:flutter/material.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

class EditUserInformationPage extends StatefulWidget {
  const EditUserInformationPage({super.key});

  @override
  State<EditUserInformationPage> createState() => _EditUserInformationPageState();
}

class _EditUserInformationPageState extends State<EditUserInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  // Real-time validation states
  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;
  bool _isAddressValid = false;
  bool _isCityValid = false;
  bool _isZipCodeValid = false;

  String? _selectedGender;
  String? _selectedCountry;
  DateTime _selectedDate = DateTime.now().subtract(const Duration(days: 365 * 25));
  
  // Notification preferences
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _marketingEmails = true;
  bool _pushNotifications = true;

  // Privacy settings
  bool _profileVisibility = true;
  bool _showBirthday = false;
  bool _showPhone = false;

  final List<String> _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'France',
    'Spain',
    'Italy',
    'Australia',
    'Japan',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Simulate loading existing user data
    _firstNameController.text = "John";
    _lastNameController.text = "Doe";
    _emailController.text = "john.doe@example.com";
    _phoneController.text = "+1 (555) 123-4567";
    _addressController.text = "123 Main Street, Apt 4B";
    _cityController.text = "New York";
    _zipCodeController.text = "10001";
    
    // Validate loaded data
    _validateFirstName(_firstNameController.text);
    _validateLastName(_lastNameController.text);
    _validateEmail(_emailController.text);
    _validatePhone(_phoneController.text);
    _validateAddress(_addressController.text);
    _validateCity(_cityController.text);
    _validateZipCode(_zipCodeController.text);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  // Real-time validation methods
  void _validateFirstName(String value) {
    setState(() {
      _isFirstNameValid = value.isNotEmpty && value.length >= 2;
    });
  }

  void _validateLastName(String value) {
    setState(() {
      _isLastNameValid = value.isNotEmpty && value.length >= 2;
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
      _isPhoneValid = value.isNotEmpty && value.length >= 10;
    });
  }

  void _validateAddress(String value) {
    setState(() {
      _isAddressValid = value.isNotEmpty && value.length >= 5;
    });
  }

  void _validateCity(String value) {
    setState(() {
      _isCityValid = value.isNotEmpty && value.length >= 2;
    });
  }

  void _validateZipCode(String value) {
    setState(() {
      _isZipCodeValid = value.isNotEmpty && 
          RegExp(r'^\d{5}(-\d{4})?$').hasMatch(value);
    });
  }

  Color _getBorderColor(bool isValid, String value) {
    if (value.isEmpty) {
      return Colors.grey;
    }
    return isValid ? Colors.green : Colors.red;
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

  void _saveUserInformation() {
    final i10n = AppLocalizations.of(context)!;
    
    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Simulate network delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(i10n.changesSaved),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          
          Navigator.of(context).pop(); // Go back to previous page
        }
      });
    }
  }

  void _resetForm() {
    final i10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(i10n.resetForm),
          content: Text(i10n.resetFormConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(i10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadUserData(); // Reload original data
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(i10n.formResetToOriginal),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(i10n.reset),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    
    // Initialize localized values if they haven't been set
    _selectedGender ??= i10n.male;
    _selectedCountry ??= 'United States'; // Uses internal key, displays localized text
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.editUserInfo),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetForm,
            tooltip: i10n.resetFormTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveUserInformation,
            tooltip: i10n.saveChangesTooltip,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(),
              const SizedBox(height: 30),

              // Personal Information Section
              _buildSectionHeader(i10n.personalInformation, Icons.person),
              const SizedBox(height: 16),
              _buildPersonalInformationFields(i10n),
              const SizedBox(height: 30),

              // Contact Information Section
              _buildSectionHeader(i10n.contactInformation, Icons.contact_phone),
              const SizedBox(height: 16),
              _buildContactInformationFields(i10n),
              const SizedBox(height: 30),

              // Address Information Section
              _buildSectionHeader(i10n.addressInformation, Icons.location_on),
              const SizedBox(height: 16),
              _buildAddressInformationFields(i10n),
              const SizedBox(height: 30),

              // Notification Preferences Section
              _buildSectionHeader(i10n.notificationPreferences, Icons.notifications),
              const SizedBox(height: 16),
              _buildNotificationPreferences(i10n),
              const SizedBox(height: 30),

              // Privacy Settings Section
              _buildSectionHeader(i10n.privacySettings, Icons.privacy_tip),
              const SizedBox(height: 16),
              _buildPrivacySettings(i10n),
              const SizedBox(height: 30),

              // Action Buttons
              _buildActionButtons(i10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  _showProfilePictureOptions();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInformationFields(AppLocalizations i10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildValidatedTextField(
                controller: _firstNameController,
                label: i10n.firstName,
                icon: Icons.person,
                validator: _validateFirstName,
                isValid: _isFirstNameValid,
                validationMessage: i10n.firstNameTooShort,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildValidatedTextField(
                controller: _lastNameController,
                label: i10n.lastName,
                icon: Icons.person_outline,
                validator: _validateLastName,
                isValid: _isLastNameValid,
                validationMessage: i10n.lastNameTooShort,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Gender Dropdown
        DropdownButtonFormField<String>(
          initialValue: _selectedGender,
          decoration: InputDecoration(
            labelText: i10n.gender,
            prefixIcon: const Icon(Icons.wc),
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem<String>(value: i10n.male, child: Text(i10n.male)),
            DropdownMenuItem<String>(value: i10n.female, child: Text(i10n.female)),
            DropdownMenuItem<String>(value: i10n.other, child: Text(i10n.other)),
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
              labelText: i10n.dateOfBirth,
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
            ),
            child: Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInformationFields(AppLocalizations i10n) {
    return Column(
      children: [
        _buildValidatedTextField(
          controller: _emailController,
          label: i10n.email,
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          isValid: _isEmailValid,
          validationMessage: i10n.invalidEmailFormat,
        ),
        const SizedBox(height: 16),
        _buildValidatedTextField(
          controller: _phoneController,
          label: i10n.phoneNumber,
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: _validatePhone,
          isValid: _isPhoneValid,
          validationMessage: i10n.phoneTooShort,
        ),
      ],
    );
  }

  Widget _buildAddressInformationFields(AppLocalizations i10n) {
    return Column(
      children: [
        _buildValidatedTextField(
          controller: _addressController,
          label: i10n.address,
          icon: Icons.home,
          validator: _validateAddress,
          isValid: _isAddressValid,
          validationMessage: i10n.addressTooShort,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildValidatedTextField(
                controller: _cityController,
                label: i10n.city,
                icon: Icons.location_city,
                validator: _validateCity,
                isValid: _isCityValid,
                validationMessage: i10n.cityTooShort,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildValidatedTextField(
                controller: _zipCodeController,
                label: i10n.zipCode,
                icon: Icons.local_post_office,
                keyboardType: TextInputType.number,
                validator: _validateZipCode,
                isValid: _isZipCodeValid,
                validationMessage: i10n.invalidZipCode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedCountry,
          decoration: InputDecoration(
            labelText: i10n.country,
            prefixIcon: const Icon(Icons.public),
            border: const OutlineInputBorder(),
          ),
          items: _getLocalizedCountries(i10n),
          onChanged: (newValue) {
            setState(() {
              _selectedCountry = newValue!;
            });
          },
        ),
      ],
    );
  }
  
  List<DropdownMenuItem<String>> _getLocalizedCountries(AppLocalizations i10n) {
    final Map<String, String> countryTranslations = {
      'United States': i10n.unitedStates,
      'Canada': i10n.canada,
      'United Kingdom': i10n.unitedKingdom,
      'Germany': i10n.germany,
      'France': i10n.france,
      'Spain': i10n.spain,
      'Italy': i10n.italy,
      'Australia': i10n.australia,
      'Japan': i10n.japan,
      'Other': i10n.other,
    };
    
    return _countries.map((String country) {
      return DropdownMenuItem<String>(
        value: country,
        child: Text(countryTranslations[country] ?? country),
      );
    }).toList();
  }

  Widget _buildNotificationPreferences(AppLocalizations i10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(i10n.emailNotifications),
              subtitle: Text(i10n.receiveGeneralUpdates),
              value: _emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(i10n.smsNotifications),
              subtitle: Text(i10n.receiveSmsAlerts),
              value: _smsNotifications,
              onChanged: (bool value) {
                setState(() {
                  _smsNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(i10n.pushNotifications),
              subtitle: Text(i10n.receivePushNotifications),
              value: _pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(i10n.marketingEmails),
              subtitle: Text(i10n.receiveMarketingContent),
              value: _marketingEmails,
              onChanged: (bool value) {
                setState(() {
                  _marketingEmails = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySettings(AppLocalizations i10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(i10n.profileVisibility),
              subtitle: Text(i10n.makeProfileVisible),
              value: _profileVisibility,
              onChanged: (bool value) {
                setState(() {
                  _profileVisibility = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(i10n.showBirthday),
              subtitle: Text(i10n.displayBirthdayOnProfile),
              value: _showBirthday,
              onChanged: (bool value) {
                setState(() {
                  _showBirthday = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(i10n.showPhone),
              subtitle: Text(i10n.displayPhoneOnProfile),
              value: _showPhone,
              onChanged: (bool value) {
                setState(() {
                  _showPhone = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) validator,
    required bool isValid,
    required String validationMessage,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _getBorderColor(isValid, controller.text),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _getBorderColor(isValid, controller.text),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _getBorderColor(isValid, controller.text),
            width: 2.0,
          ),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? Icon(
                isValid ? Icons.check_circle : Icons.error,
                color: isValid ? Colors.green : Colors.red,
              )
            : null,
      ),
      validator: (value) {
        final i10n = AppLocalizations.of(context)!;
        if (value == null || value.isEmpty) {
          return i10n.fieldRequired;
        }
        if (!isValid) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(AppLocalizations i10n) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _saveUserInformation,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.save),
              const SizedBox(width: 8),
              Text(
                i10n.saveChanges,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _resetForm,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.orange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.refresh, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                i10n.resetForm,
                style: const TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showProfilePictureOptions() {
    final i10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(i10n.takePhoto),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(i10n.cameraFunctionalityNotImplemented)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(i10n.chooseFromGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(i10n.galleryFunctionality)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text(i10n.removePhoto),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(i10n.profilePictureRemoved)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}