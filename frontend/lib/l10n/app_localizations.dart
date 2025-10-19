import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'DeliverGaz'**
  String get appTitle;

  /// The subtitle of the application
  ///
  /// In en, this message translates to:
  /// **'Gas Delivery Service'**
  String get appSubtitle;

  /// Welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// Welcome message subtitle
  ///
  /// In en, this message translates to:
  /// **'Your reliable gas delivery partner'**
  String get welcomeMessage;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @findGasStations.
  ///
  /// In en, this message translates to:
  /// **'Find Gas Stations'**
  String get findGasStations;

  /// No description provided for @orderDelivery.
  ///
  /// In en, this message translates to:
  /// **'Order Delivery'**
  String get orderDelivery;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @findGasStationsSelected.
  ///
  /// In en, this message translates to:
  /// **'Find gas stations selected!'**
  String get findGasStationsSelected;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign In Success'**
  String get signInSuccess;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Sign In Error'**
  String get signInError;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @createOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Order'**
  String get createOrder;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date'**
  String get orderDate;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderTotal;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderItems;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @filterOrders.
  ///
  /// In en, this message translates to:
  /// **'Filter Orders'**
  String get filterOrders;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// Success message when test order is created
  ///
  /// In en, this message translates to:
  /// **'Test order {orderId} created successfully!'**
  String testOrderCreated(String orderId);

  /// Error message when order creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create order: {error}'**
  String failedToCreateOrder(String error);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @removeFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove from Cart'**
  String get removeFromCart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @continueToCart.
  ///
  /// In en, this message translates to:
  /// **'Continue to Cart ({amount})'**
  String continueToCart(String amount);

  /// No description provided for @selectItemsFirst.
  ///
  /// In en, this message translates to:
  /// **'Select Items First'**
  String get selectItemsFirst;

  /// No description provided for @selectItems.
  ///
  /// In en, this message translates to:
  /// **'Select Items for Your Order'**
  String get selectItems;

  /// No description provided for @selectItemsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose from our available gas cylinders and accessories'**
  String get selectItemsDescription;

  /// No description provided for @gasCylinder13kg.
  ///
  /// In en, this message translates to:
  /// **'13kg Gas Cylinder'**
  String get gasCylinder13kg;

  /// No description provided for @gasRegulator.
  ///
  /// In en, this message translates to:
  /// **'Gas Regulator'**
  String get gasRegulator;

  /// No description provided for @gasHose2m.
  ///
  /// In en, this message translates to:
  /// **'2m Gas Hose'**
  String get gasHose2m;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Qty: {count}'**
  String quantity(int count);

  /// No description provided for @selectQuantity.
  ///
  /// In en, this message translates to:
  /// **'Select Quantity'**
  String get selectQuantity;

  /// No description provided for @addingToCart.
  ///
  /// In en, this message translates to:
  /// **'Adding to Cart...'**
  String get addingToCart;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @payPal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get payPal;

  /// No description provided for @processPayment.
  ///
  /// In en, this message translates to:
  /// **'Process Payment'**
  String get processPayment;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @noOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'No orders found matching your criteria'**
  String get noOrdersMessage;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get currency;

  /// Format for displaying prices
  ///
  /// In en, this message translates to:
  /// **'\${amount}'**
  String priceFormat(String amount);

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get paymentInformation;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total: \${amount}'**
  String totalAmount(String amount);

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @mobilePayment.
  ///
  /// In en, this message translates to:
  /// **'Mobile Payment'**
  String get mobilePayment;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashOnDelivery;

  /// No description provided for @mtnMobileMoney.
  ///
  /// In en, this message translates to:
  /// **'MTN Mobile Money'**
  String get mtnMobileMoney;

  /// No description provided for @orangeMoney.
  ///
  /// In en, this message translates to:
  /// **'Orange Money'**
  String get orangeMoney;

  /// No description provided for @expressUnionMobile.
  ///
  /// In en, this message translates to:
  /// **'Express Union Mobile'**
  String get expressUnionMobile;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name: DeliverGaz Ltd'**
  String get accountName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number: 1234567890'**
  String get accountNumber;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank: Commercial Bank of Cameroon'**
  String get bankName;

  /// No description provided for @swiftCode.
  ///
  /// In en, this message translates to:
  /// **'SWIFT Code: CBC123456'**
  String get swiftCode;

  /// No description provided for @transferInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please transfer the total amount to the account above and upload your receipt.'**
  String get transferInstructions;

  /// No description provided for @cashPaymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment Information'**
  String get cashPaymentInfo;

  /// No description provided for @paymentCollectedOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'• Payment will be collected upon delivery'**
  String get paymentCollectedOnDelivery;

  /// No description provided for @haveExactChange.
  ///
  /// In en, this message translates to:
  /// **'• Please have exact change ready'**
  String get haveExactChange;

  /// No description provided for @deliveryFeeIncluded.
  ///
  /// In en, this message translates to:
  /// **'• Delivery fee: \$5.00 (included in total)'**
  String get deliveryFeeIncluded;

  /// No description provided for @estimatedDelivery.
  ///
  /// In en, this message translates to:
  /// **'• Estimated delivery: 2-4 hours'**
  String get estimatedDelivery;

  /// No description provided for @uploadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Upload Receipt'**
  String get uploadReceipt;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @uploadPaymentProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Payment Proof'**
  String get uploadPaymentProof;

  /// No description provided for @paymentProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing Payment...'**
  String get paymentProcessing;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment successful! Order confirmed.'**
  String get paymentSuccessful;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed: {error}'**
  String paymentFailed(String error);

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get registrationTitle;

  /// No description provided for @registrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join DeliverGaz today'**
  String get registrationSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @editUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit User Information'**
  String get editUserInfo;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @addressInformation.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get addressInformation;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get discardChanges;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully!'**
  String get changesSaved;

  /// No description provided for @failedToSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes'**
  String get failedToSaveChanges;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add some items to your cart to continue'**
  String get cartEmptyMessage;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'• Delivery fee: \$5.00 (included in total)'**
  String get deliveryFee;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove Item'**
  String get removeItem;

  /// No description provided for @updateQuantity.
  ///
  /// In en, this message translates to:
  /// **'Update Quantity'**
  String get updateQuantity;

  /// No description provided for @itemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed from cart'**
  String get itemRemoved;

  /// No description provided for @cartUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cart updated'**
  String get cartUpdated;

  /// No description provided for @selectItemsForOrder.
  ///
  /// In en, this message translates to:
  /// **'Select Items for Your Order'**
  String get selectItemsForOrder;

  /// No description provided for @itemCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get itemCategoriesTitle;

  /// No description provided for @addItemToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addItemToCart;

  /// No description provided for @quantitySelector.
  ///
  /// In en, this message translates to:
  /// **'Quantity Selector'**
  String get quantitySelector;

  /// No description provided for @pricePerItem.
  ///
  /// In en, this message translates to:
  /// **'Price per item'**
  String get pricePerItem;

  /// No description provided for @itemAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Item added to cart'**
  String get itemAddedToCart;

  /// No description provided for @selectQuantityFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a quantity first'**
  String get selectQuantityFirst;

  /// No description provided for @orderCreation.
  ///
  /// In en, this message translates to:
  /// **'Order Creation'**
  String get orderCreation;

  /// No description provided for @selectItemsStep.
  ///
  /// In en, this message translates to:
  /// **'Select Items'**
  String get selectItemsStep;

  /// No description provided for @reviewOrderStep.
  ///
  /// In en, this message translates to:
  /// **'Review Order'**
  String get reviewOrderStep;

  /// No description provided for @paymentStep.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentStep;

  /// No description provided for @confirmationStep.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmationStep;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully!'**
  String get orderPlaced;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @trackYourOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Your Order'**
  String get trackYourOrder;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHome;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @phoneNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneNumberInvalid;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get tryAgainLater;

  /// No description provided for @searchOrders.
  ///
  /// In en, this message translates to:
  /// **'Search orders...'**
  String get searchOrders;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sortByDate;

  /// No description provided for @refreshOrders.
  ///
  /// In en, this message translates to:
  /// **'Refresh orders'**
  String get refreshOrders;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @cardDetails.
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get cardDetails;

  /// No description provided for @mobileMoneyDetails.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money Details'**
  String get mobileMoneyDetails;

  /// No description provided for @bankTransferDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer Details'**
  String get bankTransferDetails;

  /// No description provided for @deliveryInformation.
  ///
  /// In en, this message translates to:
  /// **'Delivery Information'**
  String get deliveryInformation;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @creditDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Credit/Debit Card'**
  String get creditDebitCard;

  /// No description provided for @creditDebitCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay with Visa, Mastercard, or other cards'**
  String get creditDebitCardDesc;

  /// No description provided for @mobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money'**
  String get mobileMoney;

  /// No description provided for @mobileMoneyDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay with MTN, Orange, or other mobile wallets'**
  String get mobileMoneyDesc;

  /// No description provided for @bankTransferDesc.
  ///
  /// In en, this message translates to:
  /// **'Direct bank transfer'**
  String get bankTransferDesc;

  /// No description provided for @payOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Pay on Delivery'**
  String get payOnDelivery;

  /// No description provided for @payOnDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay cash when your order arrives at your doorstep'**
  String get payOnDeliveryDesc;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// No description provided for @cardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardholderName;

  /// No description provided for @cardholderNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get cardholderNameHint;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @pleaseEnterCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter card number'**
  String get pleaseEnterCardNumber;

  /// No description provided for @pleaseEnterValidCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid card number'**
  String get pleaseEnterValidCardNumber;

  /// No description provided for @pleaseEnterCardholderName.
  ///
  /// In en, this message translates to:
  /// **'Please enter cardholder name'**
  String get pleaseEnterCardholderName;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get invalidFormat;

  /// No description provided for @invalidCvv.
  ///
  /// In en, this message translates to:
  /// **'Invalid CVV'**
  String get invalidCvv;

  /// No description provided for @mobileMoneyProvider.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money Provider'**
  String get mobileMoneyProvider;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseSelectProvider.
  ///
  /// In en, this message translates to:
  /// **'Please select a provider'**
  String get pleaseSelectProvider;

  /// No description provided for @bankTransferDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer Details:'**
  String get bankTransferDetailsTitle;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference: ORDER-{timestamp}'**
  String referenceNumber(String timestamp);

  /// No description provided for @emailForConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Email for Payment Confirmation'**
  String get emailForConfirmation;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @cashOnDeliveryInfo.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery Information'**
  String get cashOnDeliveryInfo;

  /// No description provided for @orderConfirmationSms.
  ///
  /// In en, this message translates to:
  /// **'• Order confirmation will be sent via SMS'**
  String get orderConfirmationSms;

  /// No description provided for @deliveryDetails.
  ///
  /// In en, this message translates to:
  /// **'Delivery Details'**
  String get deliveryDetails;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address *'**
  String get deliveryAddress;

  /// No description provided for @deliveryAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter complete delivery address'**
  String get deliveryAddressHint;

  /// No description provided for @contactPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone Number *'**
  String get contactPhoneNumber;

  /// No description provided for @contactPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+237 6XX XXX XXX'**
  String get contactPhoneHint;

  /// No description provided for @deliveryInstructions.
  ///
  /// In en, this message translates to:
  /// **'Delivery Instructions (Optional)'**
  String get deliveryInstructions;

  /// No description provided for @deliveryInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Any special instructions for delivery...'**
  String get deliveryInstructionsHint;

  /// No description provided for @pleaseEnterDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter delivery address'**
  String get pleaseEnterDeliveryAddress;

  /// No description provided for @pleaseEnterCompleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a complete address'**
  String get pleaseEnterCompleteAddress;

  /// No description provided for @pleaseEnterContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter contact phone number'**
  String get pleaseEnterContactPhone;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @deliveryOptions.
  ///
  /// In en, this message translates to:
  /// **'Delivery Options'**
  String get deliveryOptions;

  /// No description provided for @standardDelivery.
  ///
  /// In en, this message translates to:
  /// **'Standard Delivery (2-4 hours)'**
  String get standardDelivery;

  /// No description provided for @standardDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Free within city limits'**
  String get standardDeliveryDesc;

  /// No description provided for @expressDelivery.
  ///
  /// In en, this message translates to:
  /// **'Express Delivery (1-2 hours)'**
  String get expressDelivery;

  /// No description provided for @expressDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Additional \$3.00 charge'**
  String get expressDeliveryDesc;

  /// No description provided for @placingOrder.
  ///
  /// In en, this message translates to:
  /// **'Placing Order...'**
  String get placingOrder;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing Payment...'**
  String get processingPayment;

  /// No description provided for @payOnDeliveryButton.
  ///
  /// In en, this message translates to:
  /// **'Place Order - \${amount} (Pay on Delivery)'**
  String payOnDeliveryButton(String amount);

  /// No description provided for @payNowButton.
  ///
  /// In en, this message translates to:
  /// **'Pay Now - \${amount}'**
  String payNowButton(String amount);

  /// No description provided for @orderPlacedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully! We\'ll deliver and collect payment.'**
  String get orderPlacedSuccess;

  /// No description provided for @orderPlacementFailed.
  ///
  /// In en, this message translates to:
  /// **'Order placement failed: {error}'**
  String orderPlacementFailed(String error);

  /// No description provided for @resetForm.
  ///
  /// In en, this message translates to:
  /// **'Reset Form'**
  String get resetForm;

  /// No description provided for @resetFormConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all changes? This will restore the original values.'**
  String get resetFormConfirmation;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @formResetToOriginal.
  ///
  /// In en, this message translates to:
  /// **'Form reset to original values'**
  String get formResetToOriginal;

  /// No description provided for @resetFormTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reset Form'**
  String get resetFormTooltip;

  /// No description provided for @saveChangesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesTooltip;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @marketingEmails.
  ///
  /// In en, this message translates to:
  /// **'Marketing Emails'**
  String get marketingEmails;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @receiveGeneralUpdates.
  ///
  /// In en, this message translates to:
  /// **'Receive general updates and notifications via email'**
  String get receiveGeneralUpdates;

  /// No description provided for @receiveSmsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Receive SMS alerts for important updates'**
  String get receiveSmsAlerts;

  /// No description provided for @receiveMarketingContent.
  ///
  /// In en, this message translates to:
  /// **'Receive promotional content and marketing emails'**
  String get receiveMarketingContent;

  /// No description provided for @receivePushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications on your device'**
  String get receivePushNotifications;

  /// No description provided for @profileVisibility.
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get profileVisibility;

  /// No description provided for @showBirthday.
  ///
  /// In en, this message translates to:
  /// **'Show Birthday'**
  String get showBirthday;

  /// No description provided for @showPhone.
  ///
  /// In en, this message translates to:
  /// **'Show Phone Number'**
  String get showPhone;

  /// No description provided for @makeProfileVisible.
  ///
  /// In en, this message translates to:
  /// **'Make your profile visible to other users'**
  String get makeProfileVisible;

  /// No description provided for @displayBirthdayOnProfile.
  ///
  /// In en, this message translates to:
  /// **'Display your birthday on your profile'**
  String get displayBirthdayOnProfile;

  /// No description provided for @displayPhoneOnProfile.
  ///
  /// In en, this message translates to:
  /// **'Display your phone number on your profile'**
  String get displayPhoneOnProfile;

  /// No description provided for @saveInformation.
  ///
  /// In en, this message translates to:
  /// **'Save Information'**
  String get saveInformation;

  /// No description provided for @changeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'• Change profile picture'**
  String get changeProfilePicture;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @firstNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'First name must be at least 2 characters'**
  String get firstNameTooShort;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @lastNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Last name must be at least 2 characters'**
  String get lastNameTooShort;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 10 digits'**
  String get phoneTooShort;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @addressTooShort.
  ///
  /// In en, this message translates to:
  /// **'Address must be at least 5 characters'**
  String get addressTooShort;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get cityRequired;

  /// No description provided for @cityTooShort.
  ///
  /// In en, this message translates to:
  /// **'City name must be at least 2 characters'**
  String get cityTooShort;

  /// No description provided for @zipCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'ZIP code is required'**
  String get zipCodeRequired;

  /// No description provided for @invalidZipCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid ZIP code format'**
  String get invalidZipCode;

  /// No description provided for @unitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get unitedStates;

  /// No description provided for @canada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get canada;

  /// No description provided for @unitedKingdom.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get unitedKingdom;

  /// No description provided for @germany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get germany;

  /// No description provided for @france.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get france;

  /// No description provided for @spain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get spain;

  /// No description provided for @italy.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get italy;

  /// No description provided for @australia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get australia;

  /// No description provided for @japan.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get japan;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @signInToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToYourAccount;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo Mode: Form pre-filled with test credentials. Just click \"Sign In\"!'**
  String get demoMode;

  /// No description provided for @prefilledEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'Pre-filled with test account (john.doe@example.com)'**
  String get prefilledEmailHelper;

  /// No description provided for @prefilledPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'Pre-filled with test password (password123)'**
  String get prefilledPasswordHelper;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMustBe6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBe6Characters;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @googleSignInNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Google Sign In would be implemented here'**
  String get googleSignInNotImplemented;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @successfullySignedIn.
  ///
  /// In en, this message translates to:
  /// **'You have successfully signed in'**
  String get successfullySignedIn;

  /// No description provided for @sessionInformation.
  ///
  /// In en, this message translates to:
  /// **'Session Information'**
  String get sessionInformation;

  /// No description provided for @signInTime.
  ///
  /// In en, this message translates to:
  /// **'Sign In Time'**
  String get signInTime;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noAccountFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email address'**
  String get noAccountFound;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @signInGenericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during sign in: {error}'**
  String signInGenericError(String error);

  /// No description provided for @signInSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! You have been signed in successfully.'**
  String get signInSuccessMessage;

  /// No description provided for @signOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign Out Success'**
  String get signOutSuccess;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You have been signed out successfully.'**
  String get signOutMessage;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset functionality would be implemented here. For this demo, please use the pre-filled credentials.'**
  String get forgotPasswordMessage;

  /// No description provided for @welcomeBackUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {firstName}!'**
  String welcomeBackUser(String firstName);

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @shoppingCartWithCount.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart ({count})'**
  String shoppingCartWithCount(int count);

  /// No description provided for @refreshCart.
  ///
  /// In en, this message translates to:
  /// **'Refresh Cart'**
  String get refreshCart;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @addSomeItemsToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add some items to get started'**
  String get addSomeItemsToGetStarted;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get startShopping;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String itemsCount(int count);

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total: \${price}'**
  String totalPrice(String price);

  /// No description provided for @itemsInCart.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsInCart(int count);

  /// No description provided for @failedToLoadCartItems.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cart items: {error}'**
  String failedToLoadCartItems(String error);

  /// No description provided for @failedToUpdateQuantity.
  ///
  /// In en, this message translates to:
  /// **'Failed to update quantity: {error}'**
  String failedToUpdateQuantity(String error);

  /// No description provided for @itemRemovedFromCart.
  ///
  /// In en, this message translates to:
  /// **'Item removed from cart'**
  String get itemRemovedFromCart;

  /// No description provided for @failedToRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove item: {error}'**
  String failedToRemoveItem(String error);

  /// No description provided for @clearCartConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all items from your cart?'**
  String get clearCartConfirmation;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cartCleared.
  ///
  /// In en, this message translates to:
  /// **'Cart cleared'**
  String get cartCleared;

  /// No description provided for @failedToClearCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cart: {error}'**
  String failedToClearCart(String error);

  /// No description provided for @yourCartIsEmptyCheckout.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmptyCheckout;

  /// No description provided for @myShoppingCart.
  ///
  /// In en, this message translates to:
  /// **'My Shopping Cart'**
  String get myShoppingCart;

  /// No description provided for @viewCart.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCart;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createYourAccount;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get agreeToTerms;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creatingAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @clearForm.
  ///
  /// In en, this message translates to:
  /// **'Clear Form'**
  String get clearForm;

  /// No description provided for @welcomeRegistrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome {firstName}! Registration successful!'**
  String welcomeRegistrationSuccess(String firstName);

  /// No description provided for @pleaseAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to terms and conditions'**
  String get pleaseAgreeToTerms;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registrationSuccessful;

  /// No description provided for @accountCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully.'**
  String get accountCreatedMessage;

  /// No description provided for @registerAnotherUser.
  ///
  /// In en, this message translates to:
  /// **'Register Another User'**
  String get registerAnotherUser;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createNewOrder.
  ///
  /// In en, this message translates to:
  /// **'Create New Order'**
  String get createNewOrder;

  /// No description provided for @orderCreationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order creation cancelled'**
  String get orderCreationCancelled;

  /// No description provided for @each.
  ///
  /// In en, this message translates to:
  /// **'each'**
  String get each;

  /// No description provided for @actionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Action Cancelled'**
  String get actionCancelled;

  /// No description provided for @removedFromSelection.
  ///
  /// In en, this message translates to:
  /// **'removed from selection'**
  String get removedFromSelection;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'added to cart'**
  String get addedToCart;

  /// No description provided for @failedToAddItemToCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to add item to cart'**
  String get failedToAddItemToCart;

  /// No description provided for @itemsAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Items added to cart:'**
  String get itemsAddedToCart;

  /// No description provided for @failedToAddItemsToCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to add items to cart'**
  String get failedToAddItemsToCart;

  /// No description provided for @cartError.
  ///
  /// In en, this message translates to:
  /// **'Cart Error'**
  String get cartError;

  /// No description provided for @galleryFunctionality.
  ///
  /// In en, this message translates to:
  /// **'Gallery functionality would be implemented here'**
  String get galleryFunctionality;

  /// No description provided for @profilePictureRemoved.
  ///
  /// In en, this message translates to:
  /// **'Profile picture removed'**
  String get profilePictureRemoved;

  /// No description provided for @locateNearbyGasStations.
  ///
  /// In en, this message translates to:
  /// **'Locate nearby gas stations'**
  String get locateNearbyGasStations;

  /// No description provided for @createTestOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Test Order'**
  String get createTestOrder;

  /// No description provided for @inTransit.
  ///
  /// In en, this message translates to:
  /// **'In Transit'**
  String get inTransit;

  /// No description provided for @showingOrders.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} orders'**
  String showingOrders(Object count);

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @cameraFunctionalityNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Camera functionality would be implemented here'**
  String get cameraFunctionalityNotImplemented;

  /// No description provided for @receiveOrderUpdatesEmail.
  ///
  /// In en, this message translates to:
  /// **'Receive order updates via email'**
  String get receiveOrderUpdatesEmail;

  /// No description provided for @receiveOrderUpdatesSMS.
  ///
  /// In en, this message translates to:
  /// **'Receive order updates via SMS'**
  String get receiveOrderUpdatesSMS;

  /// No description provided for @receivePromotionalOffers.
  ///
  /// In en, this message translates to:
  /// **'Receive promotional offers'**
  String get receivePromotionalOffers;

  /// No description provided for @editMyInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit My Information'**
  String get editMyInformation;

  /// No description provided for @profileEditingDescription.
  ///
  /// In en, this message translates to:
  /// **'This would navigate to a profile editing page where you can:'**
  String get profileEditingDescription;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'• Update personal information'**
  String get updatePersonalInfo;

  /// No description provided for @modifyContactDetails.
  ///
  /// In en, this message translates to:
  /// **'• Modify contact details'**
  String get modifyContactDetails;

  /// No description provided for @updatePreferences.
  ///
  /// In en, this message translates to:
  /// **'• Update preferences'**
  String get updatePreferences;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @sortByStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sortByStatus;

  /// No description provided for @sortByTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get sortByTotal;

  /// No description provided for @sortByID.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get sortByID;

  /// No description provided for @chooseItemsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose from our available gas cylinders and accessories'**
  String get chooseItemsDescription;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @settingsTapped.
  ///
  /// In en, this message translates to:
  /// **'Settings tapped!'**
  String get settingsTapped;

  /// No description provided for @aboutTapped.
  ///
  /// In en, this message translates to:
  /// **'About tapped!'**
  String get aboutTapped;

  /// No description provided for @logoutTapped.
  ///
  /// In en, this message translates to:
  /// **'Logout tapped!'**
  String get logoutTapped;

  /// No description provided for @confirmSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmSignOut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
