// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DeliverGaz';

  @override
  String get appSubtitle => 'Gas Delivery Service';

  @override
  String get welcome => 'Welcome!';

  @override
  String get welcomeMessage => 'Your reliable gas delivery partner';

  @override
  String get getStarted => 'Get Started';

  @override
  String get home => 'Home';

  @override
  String get findGasStations => 'Find Gas Stations';

  @override
  String get orderDelivery => 'Order Delivery';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get findGasStationsSelected => 'Find gas stations selected!';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signInTitle => 'Welcome Back';

  @override
  String get signInSubtitle => 'Sign in to your account';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signInSuccess => 'Sign In Success';

  @override
  String get signInError => 'Sign In Error';

  @override
  String get orders => 'Orders';

  @override
  String get myOrders => 'My Orders';

  @override
  String get orderHistory => 'Order History';

  @override
  String get createOrder => 'Create Order';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderId => 'Order ID';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get orderDate => 'Order Date';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderItems => 'Items';

  @override
  String get all => 'All';

  @override
  String get pending => 'Pending';

  @override
  String get processing => 'Processing';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get filterOrders => 'Filter Orders';

  @override
  String get sortBy => 'Sort by';

  @override
  String get date => 'Date';

  @override
  String get status => 'Status';

  @override
  String get total => 'Total';

  @override
  String get id => 'ID';

  @override
  String testOrderCreated(String orderId) {
    return 'Test order $orderId created successfully!';
  }

  @override
  String failedToCreateOrder(String error) {
    return 'Failed to create order: $error';
  }

  @override
  String get profile => 'Profile';

  @override
  String get myProfile => 'My Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get zipCode => 'ZIP Code';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get shoppingCart => 'Shopping Cart';

  @override
  String get cart => 'Cart';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get removeFromCart => 'Remove from Cart';

  @override
  String get checkout => 'Checkout';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String continueToCart(String amount) {
    return 'Continue to Cart ($amount)';
  }

  @override
  String get selectItemsFirst => 'Select Items First';

  @override
  String get selectItems => 'Select Items for Your Order';

  @override
  String get selectItemsDescription =>
      'Choose from our available gas cylinders and accessories';

  @override
  String get gasCylinder13kg => '13kg Gas Cylinder';

  @override
  String get gasRegulator => 'Gas Regulator';

  @override
  String get gasHose2m => '2m Gas Hose';

  @override
  String quantity(int count) {
    return 'Qty: $count';
  }

  @override
  String get selectQuantity => 'Select Quantity';

  @override
  String get addingToCart => 'Adding to Cart...';

  @override
  String get payment => 'Payment';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get cash => 'Cash';

  @override
  String get payPal => 'PayPal';

  @override
  String get processPayment => 'Process Payment';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'RETRY';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get logout => 'Logout';

  @override
  String get noOrdersFound => 'No orders found';

  @override
  String get noOrdersMessage => 'No orders found matching your criteria';

  @override
  String get currency => '\$';

  @override
  String priceFormat(String amount) {
    return '\$$amount';
  }

  @override
  String get paymentInformation => 'Payment Information';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String totalAmount(String amount) {
    return 'Total: \$$amount';
  }

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get mobilePayment => 'Mobile Payment';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get cashOnDelivery => 'Cash on Delivery';

  @override
  String get mtnMobileMoney => 'MTN Mobile Money';

  @override
  String get orangeMoney => 'Orange Money';

  @override
  String get expressUnionMobile => 'Express Union Mobile';

  @override
  String get accountName => 'Account Name: DeliverGaz Ltd';

  @override
  String get accountNumber => 'Account Number: 1234567890';

  @override
  String get bankName => 'Bank: Commercial Bank of Cameroon';

  @override
  String get swiftCode => 'SWIFT Code: CBC123456';

  @override
  String get transferInstructions =>
      'Please transfer the total amount to the account above and upload your receipt.';

  @override
  String get cashPaymentInfo => 'Cash Payment Information';

  @override
  String get paymentCollectedOnDelivery =>
      '• Payment will be collected upon delivery';

  @override
  String get haveExactChange => '• Please have exact change ready';

  @override
  String get deliveryFeeIncluded =>
      '• Delivery fee: \$5.00 (included in total)';

  @override
  String get estimatedDelivery => '• Estimated delivery: 2-4 hours';

  @override
  String get uploadReceipt => 'Upload Receipt';

  @override
  String get selectFile => 'Select File';

  @override
  String get chooseFile => 'Choose File';

  @override
  String get uploadPaymentProof => 'Upload Payment Proof';

  @override
  String get paymentProcessing => 'Processing Payment...';

  @override
  String get paymentSuccessful => 'Payment successful! Order confirmed.';

  @override
  String paymentFailed(String error) {
    return 'Payment failed: $error';
  }

  @override
  String get registrationTitle => 'Create New Account';

  @override
  String get registrationSubtitle => 'Join DeliverGaz today';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get termsAndConditions => 'I agree to the Terms and Conditions';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get editUserInfo => 'Edit User Information';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get addressInformation => 'Address Information';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get discardChanges => 'Discard Changes';

  @override
  String get changesSaved => 'Changes saved successfully!';

  @override
  String get failedToSaveChanges => 'Failed to save changes';

  @override
  String get userProfile => 'User Profile';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get signOut => 'Sign Out';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyMessage => 'Add some items to your cart to continue';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => '• Delivery fee: \$5.00 (included in total)';

  @override
  String get tax => 'Tax';

  @override
  String get grandTotal => 'Grand Total';

  @override
  String get proceedToCheckout => 'Proceed to Checkout';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get removeItem => 'Remove Item';

  @override
  String get updateQuantity => 'Update Quantity';

  @override
  String get itemRemoved => 'Item removed from cart';

  @override
  String get cartUpdated => 'Cart updated';

  @override
  String get selectItemsForOrder => 'Select Items for Your Order';

  @override
  String get itemCategoriesTitle => 'Browse Categories';

  @override
  String get addItemToCart => 'Add to Cart';

  @override
  String get quantitySelector => 'Quantity Selector';

  @override
  String get pricePerItem => 'Price per item';

  @override
  String get itemAddedToCart => 'Item added to cart';

  @override
  String get selectQuantityFirst => 'Please select a quantity first';

  @override
  String get orderCreation => 'Order Creation';

  @override
  String get selectItemsStep => 'Select Items';

  @override
  String get reviewOrderStep => 'Review Order';

  @override
  String get paymentStep => 'Payment';

  @override
  String get confirmationStep => 'Confirmation';

  @override
  String get orderPlaced => 'Order Placed Successfully!';

  @override
  String get orderNumber => 'Order Number';

  @override
  String get trackYourOrder => 'Track Your Order';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get phoneNumberInvalid => 'Please enter a valid phone number';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get tryAgainLater => 'Please try again later';

  @override
  String get searchOrders => 'Search orders...';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get sortByDate => 'Date';

  @override
  String get refreshOrders => 'Refresh orders';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get cardDetails => 'Card Details';

  @override
  String get mobileMoneyDetails => 'Mobile Money Details';

  @override
  String get bankTransferDetails => 'Bank Transfer Details';

  @override
  String get deliveryInformation => 'Delivery Information';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get creditDebitCard => 'Credit/Debit Card';

  @override
  String get creditDebitCardDesc => 'Pay with Visa, Mastercard, or other cards';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get mobileMoneyDesc => 'Pay with MTN, Orange, or other mobile wallets';

  @override
  String get bankTransferDesc => 'Direct bank transfer';

  @override
  String get payOnDelivery => 'Pay on Delivery';

  @override
  String get payOnDeliveryDesc =>
      'Pay cash when your order arrives at your doorstep';

  @override
  String get cardNumber => 'Card Number';

  @override
  String get cardholderName => 'Cardholder Name';

  @override
  String get cardholderNameHint => 'John Doe';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get cvv => 'CVV';

  @override
  String get pleaseEnterCardNumber => 'Please enter card number';

  @override
  String get pleaseEnterValidCardNumber => 'Please enter a valid card number';

  @override
  String get pleaseEnterCardholderName => 'Please enter cardholder name';

  @override
  String get required => 'Required';

  @override
  String get invalidFormat => 'Invalid format';

  @override
  String get invalidCvv => 'Invalid CVV';

  @override
  String get mobileMoneyProvider => 'Mobile Money Provider';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter phone number';

  @override
  String get pleaseSelectProvider => 'Please select a provider';

  @override
  String get bankTransferDetailsTitle => 'Bank Transfer Details:';

  @override
  String referenceNumber(String timestamp) {
    return 'Reference: ORDER-$timestamp';
  }

  @override
  String get emailForConfirmation => 'Email for Payment Confirmation';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get cashOnDeliveryInfo => 'Cash on Delivery Information';

  @override
  String get orderConfirmationSms =>
      '• Order confirmation will be sent via SMS';

  @override
  String get deliveryDetails => 'Delivery Details';

  @override
  String get deliveryAddress => 'Delivery Address *';

  @override
  String get deliveryAddressHint => 'Enter complete delivery address';

  @override
  String get contactPhoneNumber => 'Contact Phone Number *';

  @override
  String get contactPhoneHint => '+237 6XX XXX XXX';

  @override
  String get deliveryInstructions => 'Delivery Instructions (Optional)';

  @override
  String get deliveryInstructionsHint =>
      'Any special instructions for delivery...';

  @override
  String get pleaseEnterDeliveryAddress => 'Please enter delivery address';

  @override
  String get pleaseEnterCompleteAddress => 'Please enter a complete address';

  @override
  String get pleaseEnterContactPhone => 'Please enter contact phone number';

  @override
  String get pleaseEnterValidPhone => 'Please enter a valid phone number';

  @override
  String get deliveryOptions => 'Delivery Options';

  @override
  String get standardDelivery => 'Standard Delivery (2-4 hours)';

  @override
  String get standardDeliveryDesc => 'Free within city limits';

  @override
  String get expressDelivery => 'Express Delivery (1-2 hours)';

  @override
  String get expressDeliveryDesc => 'Additional \$3.00 charge';

  @override
  String get placingOrder => 'Placing Order...';

  @override
  String get processingPayment => 'Processing Payment...';

  @override
  String payOnDeliveryButton(String amount) {
    return 'Place Order - \$$amount (Pay on Delivery)';
  }

  @override
  String payNowButton(String amount) {
    return 'Pay Now - \$$amount';
  }

  @override
  String get orderPlacedSuccess =>
      'Order placed successfully! We\'ll deliver and collect payment.';

  @override
  String orderPlacementFailed(String error) {
    return 'Order placement failed: $error';
  }

  @override
  String get resetForm => 'Reset Form';

  @override
  String get resetFormConfirmation =>
      'Are you sure you want to reset all changes? This will restore the original values.';

  @override
  String get reset => 'Reset';

  @override
  String get formResetToOriginal => 'Form reset to original values';

  @override
  String get resetFormTooltip => 'Reset Form';

  @override
  String get saveChangesTooltip => 'Save Changes';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get gender => 'Gender';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get selectDate => 'Select Date';

  @override
  String get country => 'Country';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get smsNotifications => 'SMS Notifications';

  @override
  String get marketingEmails => 'Marketing Emails';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get receiveGeneralUpdates =>
      'Receive general updates and notifications via email';

  @override
  String get receiveSmsAlerts => 'Receive SMS alerts for important updates';

  @override
  String get receiveMarketingContent =>
      'Receive promotional content and marketing emails';

  @override
  String get receivePushNotifications =>
      'Receive push notifications on your device';

  @override
  String get profileVisibility => 'Profile Visibility';

  @override
  String get showBirthday => 'Show Birthday';

  @override
  String get showPhone => 'Show Phone Number';

  @override
  String get makeProfileVisible => 'Make your profile visible to other users';

  @override
  String get displayBirthdayOnProfile =>
      'Display your birthday on your profile';

  @override
  String get displayPhoneOnProfile =>
      'Display your phone number on your profile';

  @override
  String get saveInformation => 'Save Information';

  @override
  String get changeProfilePicture => '• Change profile picture';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get firstNameTooShort => 'First name must be at least 2 characters';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get lastNameTooShort => 'Last name must be at least 2 characters';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneTooShort => 'Phone number must be at least 10 digits';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get addressTooShort => 'Address must be at least 5 characters';

  @override
  String get cityRequired => 'City is required';

  @override
  String get cityTooShort => 'City name must be at least 2 characters';

  @override
  String get zipCodeRequired => 'ZIP code is required';

  @override
  String get invalidZipCode => 'Invalid ZIP code format';

  @override
  String get unitedStates => 'United States';

  @override
  String get canada => 'Canada';

  @override
  String get unitedKingdom => 'United Kingdom';

  @override
  String get germany => 'Germany';

  @override
  String get france => 'France';

  @override
  String get spain => 'Spain';

  @override
  String get italy => 'Italy';

  @override
  String get australia => 'Australia';

  @override
  String get japan => 'Japan';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToYourAccount => 'Sign in to your account';

  @override
  String get demoMode =>
      'Demo Mode: Form pre-filled with test credentials. Just click \"Sign In\"!';

  @override
  String get prefilledEmailHelper =>
      'Pre-filled with test account (john.doe@example.com)';

  @override
  String get prefilledPasswordHelper =>
      'Pre-filled with test password (password123)';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMustBe6Characters =>
      'Password must be at least 6 characters';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get or => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get googleSignInNotImplemented =>
      'Google Sign In would be implemented here';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get successfullySignedIn => 'You have successfully signed in';

  @override
  String get sessionInformation => 'Session Information';

  @override
  String get signInTime => 'Sign In Time';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get noAccountFound => 'No account found with this email address';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String signInGenericError(String error) {
    return 'An error occurred during sign in: $error';
  }

  @override
  String get signInSuccessMessage =>
      'Welcome back! You have been signed in successfully.';

  @override
  String get signOutSuccess => 'Sign Out Success';

  @override
  String get signOutMessage => 'You have been signed out successfully.';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordMessage =>
      'Password reset functionality would be implemented here. For this demo, please use the pre-filled credentials.';

  @override
  String welcomeBackUser(String firstName) {
    return 'Welcome back, $firstName!';
  }

  @override
  String get loginFailed => 'Login failed';

  @override
  String shoppingCartWithCount(int count) {
    return 'Shopping Cart ($count)';
  }

  @override
  String get refreshCart => 'Refresh Cart';

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get yourCartIsEmpty => 'Your cart is empty';

  @override
  String get addSomeItemsToGetStarted => 'Add some items to get started';

  @override
  String get startShopping => 'Start Shopping';

  @override
  String itemsCount(int count) {
    return '$count Items';
  }

  @override
  String totalPrice(String price) {
    return 'Total: \$$price';
  }

  @override
  String itemsInCart(int count) {
    return '$count items';
  }

  @override
  String failedToLoadCartItems(String error) {
    return 'Failed to load cart items: $error';
  }

  @override
  String failedToUpdateQuantity(String error) {
    return 'Failed to update quantity: $error';
  }

  @override
  String get itemRemovedFromCart => 'Item removed from cart';

  @override
  String failedToRemoveItem(String error) {
    return 'Failed to remove item: $error';
  }

  @override
  String get clearCartConfirmation =>
      'Are you sure you want to remove all items from your cart?';

  @override
  String get clear => 'Clear';

  @override
  String get cartCleared => 'Cart cleared';

  @override
  String failedToClearCart(String error) {
    return 'Failed to clear cart: $error';
  }

  @override
  String get yourCartIsEmptyCheckout => 'Your cart is empty';

  @override
  String get myShoppingCart => 'My Shopping Cart';

  @override
  String get viewCart => 'View Cart';

  @override
  String get registration => 'Registration';

  @override
  String get createYourAccount => 'Create Your Account';

  @override
  String get agreeToTerms => 'I agree to the Terms and Conditions';

  @override
  String get creatingAccount => 'Creating account...';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get clearForm => 'Clear Form';

  @override
  String welcomeRegistrationSuccess(String firstName) {
    return 'Welcome $firstName! Registration successful!';
  }

  @override
  String get pleaseAgreeToTerms => 'Please agree to terms and conditions';

  @override
  String get registrationSuccessful => 'Registration Successful!';

  @override
  String get accountCreatedMessage =>
      'Your account has been created successfully.';

  @override
  String get registerAnotherUser => 'Register Another User';

  @override
  String get register => 'Register';

  @override
  String get createNewOrder => 'Create New Order';

  @override
  String get orderCreationCancelled => 'Order creation cancelled';

  @override
  String get each => 'each';

  @override
  String get actionCancelled => 'Action Cancelled';

  @override
  String get removedFromSelection => 'removed from selection';

  @override
  String get addedToCart => 'added to cart';

  @override
  String get failedToAddItemToCart => 'Failed to add item to cart';

  @override
  String get itemsAddedToCart => 'Items added to cart:';

  @override
  String get failedToAddItemsToCart => 'Failed to add items to cart';

  @override
  String get cartError => 'Cart Error';

  @override
  String get galleryFunctionality =>
      'Gallery functionality would be implemented here';

  @override
  String get profilePictureRemoved => 'Profile picture removed';

  @override
  String get locateNearbyGasStations => 'Locate nearby gas stations';

  @override
  String get createTestOrder => 'Create Test Order';

  @override
  String get inTransit => 'In Transit';

  @override
  String showingOrders(Object count) {
    return 'Showing $count orders';
  }

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully!';

  @override
  String get cameraFunctionalityNotImplemented =>
      'Camera functionality would be implemented here';

  @override
  String get receiveOrderUpdatesEmail => 'Receive order updates via email';

  @override
  String get receiveOrderUpdatesSMS => 'Receive order updates via SMS';

  @override
  String get receivePromotionalOffers => 'Receive promotional offers';

  @override
  String get editMyInformation => 'Edit My Information';

  @override
  String get profileEditingDescription =>
      'This would navigate to a profile editing page where you can:';

  @override
  String get updatePersonalInfo => '• Update personal information';

  @override
  String get modifyContactDetails => '• Modify contact details';

  @override
  String get updatePreferences => '• Update preferences';

  @override
  String get refresh => 'Refresh';

  @override
  String get sortByStatus => 'Status';

  @override
  String get sortByTotal => 'Total';

  @override
  String get sortByID => 'ID';

  @override
  String get chooseItemsDescription =>
      'Choose from our available gas cylinders and accessories';

  @override
  String get menu => 'Menu';

  @override
  String get settingsTapped => 'Settings tapped!';

  @override
  String get aboutTapped => 'About tapped!';

  @override
  String get logoutTapped => 'Logout tapped!';

  @override
  String get confirmSignOut => 'Are you sure you want to sign out?';
}
