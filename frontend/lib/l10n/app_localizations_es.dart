// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'DeliverGaz';

  @override
  String get appSubtitle => 'Servicio de Entrega de Gas';

  @override
  String get welcome => 'Bienvenido a DeliverGaz';

  @override
  String get welcomeMessage => 'Su socio confiable de entrega de gas';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get home => 'Inicio';

  @override
  String get findGasStations => 'Encontrar Estaciones de Gas';

  @override
  String get orderDelivery => 'Pedir Entrega';

  @override
  String get trackOrder => 'Rastrear Pedido';

  @override
  String get findGasStationsSelected =>
      '¡Encontrar estaciones de gas seleccionado!';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signInTitle => 'Bienvenido de Vuelta';

  @override
  String get signInSubtitle => 'Inicia sesión en tu cuenta';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Ingresa tu dirección de email';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Ingresa tu contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu Contraseña?';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get hasAccount => '¿Ya tienes una cuenta?';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get signInSuccess => '¡Inicio de sesión exitoso!';

  @override
  String get signInError =>
      'Error al iniciar sesión. Por favor verifica tus credenciales.';

  @override
  String get orders => 'Pedidos';

  @override
  String get myOrders => 'Mis Pedidos';

  @override
  String get orderHistory => 'Historial de Pedidos';

  @override
  String get createOrder => 'Crear Pedido';

  @override
  String get orderDetails => 'Detalles del Pedido';

  @override
  String get orderId => 'ID del Pedido';

  @override
  String get orderStatus => 'Estado del Pedido';

  @override
  String get orderDate => 'Fecha del Pedido';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderItems => 'Artículos';

  @override
  String get all => 'Todos';

  @override
  String get pending => 'Pendiente';

  @override
  String get processing => 'Procesando';

  @override
  String get delivered => 'Entregado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get filterOrders => 'Filtrar Pedidos';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get date => 'Fecha';

  @override
  String get status => 'Estado';

  @override
  String get total => 'Total';

  @override
  String get id => 'ID';

  @override
  String testOrderCreated(String orderId) {
    return '¡Pedido de prueba $orderId creado exitosamente!';
  }

  @override
  String failedToCreateOrder(String error) {
    return 'Error al crear el pedido: $error';
  }

  @override
  String get profile => 'Perfil';

  @override
  String get myProfile => 'Mi Perfil';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get personalInformation => 'Información Personal';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get phoneNumber => 'Número de Teléfono';

  @override
  String get address => 'Dirección';

  @override
  String get city => 'Ciudad';

  @override
  String get state => 'Estado';

  @override
  String get zipCode => 'Código Postal';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get shoppingCart => 'Carrito de Compras';

  @override
  String get cart => 'Carrito';

  @override
  String get addToCart => 'Agregar al Carrito';

  @override
  String get removeFromCart => 'Quitar del Carrito';

  @override
  String get checkout => 'Pagar';

  @override
  String get emptyCart => 'Tu carrito está vacío';

  @override
  String continueToCart(String amount) {
    return 'Continuar al carrito ($amount)';
  }

  @override
  String get selectItemsFirst => 'Seleccione elementos primero';

  @override
  String get selectItems => 'Seleccionar Artículos para tu Pedido';

  @override
  String get selectItemsDescription =>
      'Elige entre nuestros cilindros de gas y accesorios disponibles';

  @override
  String get gasCylinder13kg => 'Cilindro de Gas 13kg';

  @override
  String get gasRegulator => 'Regulador de Gas';

  @override
  String get gasHose2m => 'Manguera de Gas 2m';

  @override
  String quantity(int count) {
    return 'Cant: $count';
  }

  @override
  String get selectQuantity => 'Seleccionar Cantidad';

  @override
  String get addingToCart => 'Agregando al carrito...';

  @override
  String get payment => 'Pago';

  @override
  String get paymentMethod => 'Método de Pago';

  @override
  String get creditCard => 'Tarjeta de Crédito';

  @override
  String get cash => 'Efectivo';

  @override
  String get payPal => 'PayPal';

  @override
  String get processPayment => 'Procesar Pago';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get settings => 'Configuraciones';

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get noOrdersFound => 'No se encontraron pedidos';

  @override
  String get noOrdersMessage =>
      'No se encontraron pedidos que coincidan con tus criterios';

  @override
  String get currency => '\$';

  @override
  String priceFormat(String amount) {
    return '\$$amount';
  }

  @override
  String get paymentInformation => 'Información de Pago';

  @override
  String get orderSummary => 'Resumen del Pedido';

  @override
  String totalAmount(String amount) {
    return 'Monto Total';
  }

  @override
  String get paymentMethods => 'Métodos de Pago';

  @override
  String get mobilePayment => 'Pago Móvil';

  @override
  String get bankTransfer => 'Transferencia Bancaria';

  @override
  String get cashOnDelivery => 'Pago Contra Entrega';

  @override
  String get mtnMobileMoney => 'MTN Mobile Money';

  @override
  String get orangeMoney => 'Orange Money';

  @override
  String get expressUnionMobile => 'Express Union Mobile';

  @override
  String get accountName => 'Nombre de cuenta: DeliverGaz Ltd';

  @override
  String get accountNumber => 'Número de cuenta: 1234567890';

  @override
  String get bankName => 'Banco: Banco Comercial de Camerún';

  @override
  String get swiftCode => 'Código SWIFT: CBC123456';

  @override
  String get transferInstructions =>
      'Por favor transfiera el monto total a la cuenta anterior y suba su recibo.';

  @override
  String get cashPaymentInfo => 'Información de Pago en Efectivo';

  @override
  String get paymentCollectedOnDelivery => '• El pago se cobrará en la entrega';

  @override
  String get haveExactChange => '• Por favor tenga el cambio exacto listo';

  @override
  String get deliveryFeeIncluded =>
      '• Tarifa de entrega: \$5.00 (incluida en el total)';

  @override
  String get estimatedDelivery => '• Entrega estimada: 2-4 horas';

  @override
  String get uploadReceipt => 'Subir Recibo';

  @override
  String get selectFile => 'Seleccionar Archivo';

  @override
  String get chooseFile => 'Elegir Archivo';

  @override
  String get uploadPaymentProof => 'Subir Comprobante de Pago';

  @override
  String get paymentProcessing => 'Procesando Pago...';

  @override
  String get paymentSuccessful => '¡Pago Exitoso!';

  @override
  String paymentFailed(String error) {
    return 'Error en el pago: $error';
  }

  @override
  String get registrationTitle => 'Crear Nueva Cuenta';

  @override
  String get registrationSubtitle => 'Únete a DeliverGaz hoy';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get fullNameHint => 'Ingresa tu nombre completo';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get confirmPasswordHint => 'Vuelve a ingresar tu contraseña';

  @override
  String get termsAndConditions => 'Acepto los Términos y Condiciones';

  @override
  String get createAccountButton => 'Crear Cuenta';

  @override
  String get accountCreatedSuccess => '¡Cuenta creada exitosamente!';

  @override
  String get registrationFailed =>
      'Registro fallido. Por favor intenta de nuevo.';

  @override
  String get editUserInfo => 'Editar Información de Usuario';

  @override
  String get personalDetails => 'Detalles Personales';

  @override
  String get contactInformation => 'Información de Contacto';

  @override
  String get addressInformation => 'Información de Dirección';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get discardChanges => 'Descartar Cambios';

  @override
  String get changesSaved => '¡Cambios guardados exitosamente!';

  @override
  String get failedToSaveChanges => 'Error al guardar los cambios';

  @override
  String get userProfile => 'Perfil de Usuario';

  @override
  String get accountSettings => 'Configuración de Cuenta';

  @override
  String get preferences => 'Preferencias';

  @override
  String get helpSupport => 'Ayuda y Soporte';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get cartEmpty => 'Tu carrito está vacío';

  @override
  String get cartEmptyMessage =>
      'Agrega algunos artículos a tu carrito para continuar';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => 'Tarifa de Entrega';

  @override
  String get tax => 'Impuesto';

  @override
  String get grandTotal => 'Total General';

  @override
  String get proceedToCheckout => 'Proceder al Pago';

  @override
  String get continueShopping => 'Continuar Comprando';

  @override
  String get removeItem => 'Quitar Artículo';

  @override
  String get updateQuantity => 'Actualizar Cantidad';

  @override
  String get itemRemoved => 'Artículo removido del carrito';

  @override
  String get cartUpdated => 'Carrito actualizado';

  @override
  String get selectItemsForOrder => 'Seleccione artículos para su pedido';

  @override
  String get itemCategoriesTitle => 'Navegar Categorías';

  @override
  String get addItemToCart => 'Agregar al Carrito';

  @override
  String get quantitySelector => 'Selector de Cantidad';

  @override
  String get pricePerItem => 'Precio por artículo';

  @override
  String get itemAddedToCart => 'Artículo agregado al carrito';

  @override
  String get selectQuantityFirst => 'Por favor selecciona una cantidad primero';

  @override
  String get orderCreation => 'Creación de Pedido';

  @override
  String get selectItemsStep => 'Seleccionar Artículos';

  @override
  String get reviewOrderStep => 'Revisar Pedido';

  @override
  String get paymentStep => 'Pago';

  @override
  String get confirmationStep => 'Confirmación';

  @override
  String get orderPlaced => '¡Pedido Realizado Exitosamente!';

  @override
  String get orderNumber => 'Número de Pedido';

  @override
  String get trackYourOrder => 'Rastrear tu Pedido';

  @override
  String get returnToHome => 'Volver al Inicio';

  @override
  String get invalidEmail => 'Por favor ingresa una dirección de email válida';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get fieldRequired => 'Este campo es requerido';

  @override
  String get phoneNumberInvalid =>
      'Por favor ingresa un número de teléfono válido';

  @override
  String get networkError => 'Error de red. Por favor verifica tu conexión.';

  @override
  String get serverError => 'Error del servidor. Por favor intenta más tarde.';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado';

  @override
  String get tryAgainLater => 'Por favor intenta de nuevo más tarde';

  @override
  String get searchOrders => 'Buscar pedidos...';

  @override
  String get filterByStatus => 'Filtrar por estado';

  @override
  String get sortByDate => 'Fecha';

  @override
  String get refreshOrders => 'Actualizar pedidos';

  @override
  String get currentLanguage => 'Idioma Actual';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get languageChanged => 'Idioma cambiado exitosamente';

  @override
  String get cardDetails => 'Detalles de la Tarjeta';

  @override
  String get mobileMoneyDetails => 'Detalles Mobile Money';

  @override
  String get bankTransferDetails => 'Detalles Transferencia Bancaria';

  @override
  String get deliveryInformation => 'Información de Entrega';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
    );
    return '$_temp0';
  }

  @override
  String get creditDebitCard => 'Tarjeta de Crédito/Débito';

  @override
  String get creditDebitCardDesc =>
      'Pagar con Visa, Mastercard, u otras tarjetas';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get mobileMoneyDesc =>
      'Pagar con MTN, Orange, u otras billeteras móviles';

  @override
  String get bankTransferDesc => 'Direct bank transfer';

  @override
  String get payOnDelivery => 'Pago Contra Entrega';

  @override
  String get payOnDeliveryDesc => 'Pagar en efectivo cuando llegue tu pedido';

  @override
  String get cardNumber => 'Número de Tarjeta';

  @override
  String get cardholderName => 'Nombre del Titular';

  @override
  String get cardholderNameHint => 'Juan Pérez';

  @override
  String get expiryDate => 'Fecha de Vencimiento';

  @override
  String get cvv => 'CVV';

  @override
  String get pleaseEnterCardNumber => 'Por favor ingrese el número de tarjeta';

  @override
  String get pleaseEnterValidCardNumber =>
      'Por favor ingrese un número de tarjeta válido';

  @override
  String get pleaseEnterCardholderName =>
      'Por favor ingrese el nombre del titular';

  @override
  String get required => 'Requerido';

  @override
  String get invalidFormat => 'Formato inválido';

  @override
  String get invalidCvv => 'CVV inválido';

  @override
  String get mobileMoneyProvider => 'Proveedor Mobile Money';

  @override
  String get pleaseEnterPhoneNumber =>
      'Por favor ingrese el número de teléfono';

  @override
  String get pleaseSelectProvider => 'Por favor seleccione un proveedor';

  @override
  String get bankTransferDetailsTitle => 'Detalles de Transferencia Bancaria:';

  @override
  String referenceNumber(String timestamp) {
    return 'Referencia: PEDIDO-$timestamp';
  }

  @override
  String get emailForConfirmation => 'Email para Confirmación de Pago';

  @override
  String get pleaseEnterEmail => 'Por favor ingrese una dirección de email';

  @override
  String get pleaseEnterValidEmail => 'Por favor ingrese un email válido';

  @override
  String get cashOnDeliveryInfo => 'Información Pago Contra Entrega';

  @override
  String get orderConfirmationSms =>
      '• Order confirmation will be sent via SMS';

  @override
  String get deliveryDetails => 'Detalles de Entrega';

  @override
  String get deliveryAddress => 'Dirección de Entrega *';

  @override
  String get deliveryAddressHint => 'Ingrese la dirección completa de entrega';

  @override
  String get contactPhoneNumber => 'Número de Teléfono de Contacto *';

  @override
  String get contactPhoneHint => '+237 6XX XXX XXX';

  @override
  String get deliveryInstructions => 'Instrucciones de Entrega (Opcional)';

  @override
  String get deliveryInstructionsHint =>
      'Instrucciones especiales para la entrega...';

  @override
  String get pleaseEnterDeliveryAddress =>
      'Por favor ingrese la dirección de entrega';

  @override
  String get pleaseEnterCompleteAddress =>
      'Por favor ingrese una dirección completa';

  @override
  String get pleaseEnterContactPhone =>
      'Por favor ingrese el teléfono de contacto';

  @override
  String get pleaseEnterValidPhone => 'Por favor ingrese un número válido';

  @override
  String get deliveryOptions => 'Opciones de Entrega';

  @override
  String get standardDelivery => 'Entrega Estándar (2-4 horas)';

  @override
  String get standardDeliveryDesc =>
      'Gratis dentro de los límites de la ciudad';

  @override
  String get expressDelivery => 'Entrega Express (1-2 horas)';

  @override
  String get expressDeliveryDesc => 'Cargo adicional de \$3.00';

  @override
  String get placingOrder => 'Realizando Pedido...';

  @override
  String get processingPayment => 'Procesando Pago...';

  @override
  String payOnDeliveryButton(String amount) {
    return 'Realizar Pedido - \$$amount (Pago Contra Entrega)';
  }

  @override
  String payNowButton(String amount) {
    return 'Pagar Ahora - \$$amount';
  }

  @override
  String get orderPlacedSuccess =>
      '¡Pedido realizado exitosamente! Entregaremos y cobraremos el pago.';

  @override
  String orderPlacementFailed(String error) {
    return 'Error al realizar el pedido: $error';
  }

  @override
  String get resetForm => 'Restablecer Formulario';

  @override
  String get resetFormConfirmation =>
      '¿Está seguro de que quiere restablecer todos los cambios? Esto restaurará los valores originales.';

  @override
  String get reset => 'Restablecer';

  @override
  String get formResetToOriginal =>
      'Formulario restablecido a valores originales';

  @override
  String get resetFormTooltip => 'Restablecer Formulario';

  @override
  String get saveChangesTooltip => 'Guardar Cambios';

  @override
  String get notificationPreferences => 'Preferencias de Notificación';

  @override
  String get privacySettings => 'Configuración de Privacidad';

  @override
  String get gender => 'Género';

  @override
  String get dateOfBirth => 'Fecha de Nacimiento';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Femenino';

  @override
  String get other => 'Otro';

  @override
  String get selectDate => 'Seleccionar Fecha';

  @override
  String get country => 'País';

  @override
  String get selectCountry => 'Seleccionar País';

  @override
  String get emailNotifications => 'Notificaciones por Email';

  @override
  String get smsNotifications => 'Notificaciones SMS';

  @override
  String get marketingEmails => 'Emails de Marketing';

  @override
  String get pushNotifications => 'Notificaciones Push';

  @override
  String get receiveGeneralUpdates =>
      'Recibir actualizaciones generales y notificaciones por email';

  @override
  String get receiveSmsAlerts =>
      'Recibir alertas SMS para actualizaciones importantes';

  @override
  String get receiveMarketingContent =>
      'Recibir contenido promocional y emails de marketing';

  @override
  String get receivePushNotifications =>
      'Recibir notificaciones push en su dispositivo';

  @override
  String get profileVisibility => 'Visibilidad del Perfil';

  @override
  String get showBirthday => 'Mostrar Cumpleaños';

  @override
  String get showPhone => 'Mostrar Número de Teléfono';

  @override
  String get makeProfileVisible => 'Hacer su perfil visible a otros usuarios';

  @override
  String get displayBirthdayOnProfile => 'Mostrar su cumpleaños en su perfil';

  @override
  String get displayPhoneOnProfile =>
      'Mostrar su número de teléfono en su perfil';

  @override
  String get saveInformation => 'Guardar Información';

  @override
  String get changeProfilePicture => 'Cambiar Foto de Perfil';

  @override
  String get takePhoto => 'Tomar Foto';

  @override
  String get chooseFromGallery => 'Elegir de la Galería';

  @override
  String get removePhoto => 'Eliminar Foto';

  @override
  String get firstNameRequired => 'El nombre es requerido';

  @override
  String get firstNameTooShort => 'El nombre debe tener al menos 2 caracteres';

  @override
  String get lastNameRequired => 'El apellido es requerido';

  @override
  String get lastNameTooShort => 'El apellido debe tener al menos 2 caracteres';

  @override
  String get emailRequired => 'El email es requerido';

  @override
  String get invalidEmailFormat => 'Formato de email inválido';

  @override
  String get phoneRequired => 'El número de teléfono es requerido';

  @override
  String get phoneTooShort =>
      'El número de teléfono debe tener al menos 10 dígitos';

  @override
  String get addressRequired => 'La dirección es requerida';

  @override
  String get addressTooShort => 'La dirección debe tener al menos 5 caracteres';

  @override
  String get cityRequired => 'La ciudad es requerida';

  @override
  String get cityTooShort =>
      'El nombre de la ciudad debe tener al menos 2 caracteres';

  @override
  String get zipCodeRequired => 'El código postal es requerido';

  @override
  String get invalidZipCode => 'Formato de código postal inválido';

  @override
  String get unitedStates => 'Estados Unidos';

  @override
  String get canada => 'Canadá';

  @override
  String get unitedKingdom => 'Reino Unido';

  @override
  String get germany => 'Alemania';

  @override
  String get france => 'Francia';

  @override
  String get spain => 'España';

  @override
  String get italy => 'Italia';

  @override
  String get australia => 'Australia';

  @override
  String get japan => 'Japón';

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
  String get createNewOrder => 'Crear Nuevo Pedido';

  @override
  String get orderCreationCancelled => 'Creación de pedido cancelada';

  @override
  String get each => 'cada uno';

  @override
  String get actionCancelled => 'Acción Cancelada';

  @override
  String get removedFromSelection => 'eliminado de la selección';

  @override
  String get addedToCart => 'agregado al carrito';

  @override
  String get failedToAddItemToCart => 'Error al agregar artículo al carrito';

  @override
  String get itemsAddedToCart => 'Artículos agregados al carrito:';

  @override
  String get failedToAddItemsToCart => 'Error al agregar artículos al carrito';

  @override
  String get cartError => 'Error de Carrito';

  @override
  String get galleryFunctionality =>
      'La funcionalidad de galería se implementaría aquí';

  @override
  String get profilePictureRemoved => 'Foto de perfil eliminada';

  @override
  String get locateNearbyGasStations =>
      'Localizar estaciones de gasolina cercanas';

  @override
  String get createTestOrder => 'Crear Pedido de Prueba';

  @override
  String get inTransit => 'En Tránsito';

  @override
  String showingOrders(Object count) {
    return 'Mostrando $count pedidos';
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
  String get refresh => 'Actualizar';

  @override
  String get sortByStatus => 'Estado';

  @override
  String get sortByTotal => 'Total';

  @override
  String get sortByID => 'ID';

  @override
  String get chooseItemsDescription =>
      'Elija entre nuestros cilindros de gas y accesorios disponibles';

  @override
  String get menu => 'Menú';

  @override
  String get settingsTapped => '¡Configuraciones seleccionadas!';

  @override
  String get aboutTapped => '¡Acerca de seleccionado!';

  @override
  String get logoutTapped => '¡Cerrar sesión seleccionado!';

  @override
  String get confirmSignOut => '¿Estás seguro de que quieres cerrar sesión?';
}
