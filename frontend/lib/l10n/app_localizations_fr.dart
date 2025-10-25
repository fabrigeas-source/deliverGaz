// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'DeliverGaz';

  @override
  String get appSubtitle => 'Service de Livraison de Gaz';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get welcomeMessage => 'Votre partenaire de livraison de gaz fiable';

  @override
  String get getStarted => 'Commencer';

  @override
  String get home => 'Accueil';

  @override
  String get findGasStations => 'Trouver des Stations de Gaz';

  @override
  String get orderDelivery => 'Commander une Livraison';

  @override
  String get trackOrder => 'Suivre la Commande';

  @override
  String get findGasStationsSelected =>
      'Trouver des stations de gaz sélectionné!';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signInTitle => 'Bon Retour';

  @override
  String get signInSubtitle => 'Connectez-vous à votre compte';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Entrez votre adresse email';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Entrez votre mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get noAccount => 'Vous n\'avez pas de compte?';

  @override
  String get hasAccount => 'Vous avez déjà un compte?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get signInSuccess => 'Connexion réussie';

  @override
  String get signInError => 'Erreur de connexion';

  @override
  String get orders => 'Commandes';

  @override
  String get myOrders => 'Mes commandes';

  @override
  String get orderHistory => 'Historique des Commandes';

  @override
  String get createOrder => 'Créer une Commande';

  @override
  String get orderDetails => 'Détails de la Commande';

  @override
  String get orderId => 'ID de Commande';

  @override
  String get orderStatus => 'Statut de la Commande';

  @override
  String get orderDate => 'Date de Commande';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderItems => 'Articles';

  @override
  String get all => 'Tout';

  @override
  String get pending => 'En Attente';

  @override
  String get processing => 'En Traitement';

  @override
  String get delivered => 'Livré';

  @override
  String get cancelled => 'Annulé';

  @override
  String get filterOrders => 'Filtrer les Commandes';

  @override
  String get sortBy => 'Trier par';

  @override
  String get date => 'Date';

  @override
  String get status => 'Statut';

  @override
  String get total => 'Total';

  @override
  String get id => 'ID';

  @override
  String testOrderCreated(String orderId) {
    return 'Commande test $orderId créée avec succès!';
  }

  @override
  String failedToCreateOrder(String error) {
    return 'Échec de la création de la commande: $error';
  }

  @override
  String get profile => 'Profil';

  @override
  String get myProfile => 'Mon Profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get personalInformation => 'Informations personnelles';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom de Famille';

  @override
  String get phoneNumber => 'Numéro de Téléphone';

  @override
  String get address => 'Adresse';

  @override
  String get city => 'Ville';

  @override
  String get state => 'État';

  @override
  String get zipCode => 'Code Postal';

  @override
  String get save => 'Sauvegarder';

  @override
  String get cancel => 'Annuler';

  @override
  String get shoppingCart => 'Panier';

  @override
  String get cart => 'Panier';

  @override
  String get addToCart => 'Ajouter au Panier';

  @override
  String get removeFromCart => 'Retirer du Panier';

  @override
  String get checkout => 'Commander';

  @override
  String get emptyCart => 'Votre panier est vide';

  @override
  String continueToCart(String amount) {
    return 'Continuer vers le panier ($amount)';
  }

  @override
  String get selectItemsFirst => 'Sélectionnez d\'abord des éléments';

  @override
  String get selectItems => 'Sélectionner les Articles pour votre Commande';

  @override
  String get selectItemsDescription =>
      'Choisissez parmi nos bouteilles de gaz et accessoires disponibles';

  @override
  String get gasCylinder13kg => 'Bouteille de Gaz 13kg';

  @override
  String get gasRegulator => 'Régulateur de Gaz';

  @override
  String get gasHose2m => 'Tuyau de Gaz 2m';

  @override
  String quantity(int count) {
    return 'Qté: $count';
  }

  @override
  String get selectQuantity => 'Sélectionner la Quantité';

  @override
  String get addingToCart => 'Ajout au panier...';

  @override
  String get payment => 'Paiement';

  @override
  String get paymentMethod => 'Méthode de Paiement';

  @override
  String get creditCard => 'Carte de Crédit';

  @override
  String get cash => 'Espèces';

  @override
  String get payPal => 'PayPal';

  @override
  String get processPayment => 'Traiter le Paiement';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get retry => 'RÉESSAYER';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get notifications => 'Notifications';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get logout => 'Déconnexion';

  @override
  String get noOrdersFound => 'Aucune commande trouvée';

  @override
  String get noOrdersMessage =>
      'Aucune commande trouvée correspondant à vos critères';

  @override
  String get currency => '\$';

  @override
  String priceFormat(String amount) {
    return '$amount\$';
  }

  @override
  String get paymentInformation => 'Informations de Paiement';

  @override
  String get orderSummary => 'Résumé de la Commande';

  @override
  String totalAmount(String amount) {
    return 'Montant Total';
  }

  @override
  String get paymentMethods => 'Méthodes de Paiement';

  @override
  String get mobilePayment => 'Paiement Mobile';

  @override
  String get bankTransfer => 'Virement Bancaire';

  @override
  String get cashOnDelivery => 'Paiement à la Livraison';

  @override
  String get mtnMobileMoney => 'MTN Mobile Money';

  @override
  String get orangeMoney => 'Orange Money';

  @override
  String get expressUnionMobile => 'Express Union Mobile';

  @override
  String get accountName => 'Nom du compte: DeliverGaz Ltd';

  @override
  String get accountNumber => 'Numéro de compte: 1234567890';

  @override
  String get bankName => 'Banque: Banque Commerciale du Cameroun';

  @override
  String get swiftCode => 'Code SWIFT: CBC123456';

  @override
  String get transferInstructions =>
      'Veuillez transférer le montant total vers le compte ci-dessus et télécharger votre reçu.';

  @override
  String get cashPaymentInfo => 'Informations de Paiement en Espèces';

  @override
  String get paymentCollectedOnDelivery =>
      '• Le paiement sera collecté à la livraison';

  @override
  String get haveExactChange => '• Veuillez avoir l\'appoint exact';

  @override
  String get deliveryFeeIncluded =>
      '• Frais de livraison: 5,00\$ (inclus dans le total)';

  @override
  String get estimatedDelivery => '• Livraison estimée: 2-4 heures';

  @override
  String get uploadReceipt => 'Télécharger le Reçu';

  @override
  String get selectFile => 'Sélectionner un Fichier';

  @override
  String get chooseFile => 'Choisir un Fichier';

  @override
  String get uploadPaymentProof => 'Télécharger la Preuve de Paiement';

  @override
  String get paymentProcessing => 'Traitement du Paiement...';

  @override
  String get paymentSuccessful => 'Paiement Réussi!';

  @override
  String paymentFailed(String error) {
    return 'Échec du paiement: $error';
  }

  @override
  String get registrationTitle => 'Créer un Nouveau Compte';

  @override
  String get registrationSubtitle => 'Rejoignez DeliverGaz aujourd\'hui';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get fullNameHint => 'Entrez votre nom complet';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get confirmPasswordHint => 'Ressaisissez votre mot de passe';

  @override
  String get termsAndConditions => 'J\'accepte les Termes et Conditions';

  @override
  String get createAccountButton => 'Créer un Compte';

  @override
  String get accountCreatedSuccess => 'Compte créé avec succès!';

  @override
  String get registrationFailed => 'Échec de l\'inscription';

  @override
  String get editUserInfo => 'Modifier les Informations Utilisateur';

  @override
  String get personalDetails => 'Détails Personnels';

  @override
  String get contactInformation => 'Informations de Contact';

  @override
  String get addressInformation => 'Informations d\'Adresse';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get discardChanges => 'Annuler les Modifications';

  @override
  String get changesSaved => 'Modifications sauvegardées avec succès!';

  @override
  String get failedToSaveChanges => 'Échec de la sauvegarde des modifications';

  @override
  String get userProfile => 'Profil utilisateur';

  @override
  String get accountSettings => 'Paramètres du Compte';

  @override
  String get preferences => 'Préférences';

  @override
  String get helpSupport => 'Aide et Support';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get termsOfService => 'Conditions de Service';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get cartEmpty => 'Votre panier est vide';

  @override
  String get cartEmptyMessage =>
      'Ajoutez des articles à votre panier pour continuer';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get deliveryFee => 'Frais de Livraison';

  @override
  String get tax => 'Taxe';

  @override
  String get grandTotal => 'Total Général';

  @override
  String get proceedToCheckout => 'Procéder au Paiement';

  @override
  String get continueShopping => 'Continuer les Achats';

  @override
  String get removeItem => 'Retirer l\'Article';

  @override
  String get updateQuantity => 'Mettre à Jour la Quantité';

  @override
  String get itemRemoved => 'Article retiré du panier';

  @override
  String get cartUpdated => 'Panier mis à jour';

  @override
  String get selectItemsForOrder =>
      'Sélectionnez des articles pour votre commande';

  @override
  String get itemCategoriesTitle => 'Parcourir les Catégories';

  @override
  String get addItemToCart => 'Ajouter au Panier';

  @override
  String get quantitySelector => 'Sélecteur de Quantité';

  @override
  String get pricePerItem => 'Prix par article';

  @override
  String get itemAddedToCart => 'Article ajouté au panier';

  @override
  String get selectQuantityFirst =>
      'Veuillez d\'abord sélectionner une quantité';

  @override
  String get orderCreation => 'Création de Commande';

  @override
  String get selectItemsStep => 'Sélectionner les Articles';

  @override
  String get reviewOrderStep => 'Réviser la Commande';

  @override
  String get paymentStep => 'Paiement';

  @override
  String get confirmationStep => 'Confirmation';

  @override
  String get orderPlaced => 'Commande Passée avec Succès!';

  @override
  String get orderNumber => 'Numéro de Commande';

  @override
  String get trackYourOrder => 'Suivre votre Commande';

  @override
  String get returnToHome => 'Retour à l\'Accueil';

  @override
  String get invalidEmail => 'Veuillez entrer une adresse email valide';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get fieldRequired => 'Ce champ est requis';

  @override
  String get phoneNumberInvalid =>
      'Veuillez entrer un numéro de téléphone valide';

  @override
  String get networkError =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get serverError => 'Erreur serveur. Veuillez réessayer plus tard.';

  @override
  String get unexpectedError => 'Une erreur inattendue s\'est produite';

  @override
  String get tryAgainLater => 'Veuillez réessayer plus tard';

  @override
  String get searchOrders => 'Rechercher des commandes...';

  @override
  String get filterByStatus => 'Filtrer par statut';

  @override
  String get sortByDate => 'Date';

  @override
  String get refreshOrders => 'Actualiser les commandes';

  @override
  String get currentLanguage => 'Langue Actuelle';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get languageChanged => 'Langue changée avec succès';

  @override
  String get cardDetails => 'Détails de la Carte';

  @override
  String get mobileMoneyDetails => 'Détails Mobile Money';

  @override
  String get bankTransferDetails => 'Détails Virement Bancaire';

  @override
  String get deliveryInformation => 'Informations de Livraison';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
    );
    return '$_temp0';
  }

  @override
  String get creditDebitCard => 'Carte de Crédit/Débit';

  @override
  String get creditDebitCardDesc =>
      'Payer avec Visa, Mastercard, ou autres cartes';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get mobileMoneyDesc =>
      'Payer avec MTN, Orange, ou autres portefeuilles mobiles';

  @override
  String get bankTransferDesc => 'Virement bancaire direct';

  @override
  String get payOnDelivery => 'Paiement à la Livraison';

  @override
  String get payOnDeliveryDesc => 'Payer en espèces à la livraison';

  @override
  String get cardNumber => 'Numéro de Carte';

  @override
  String get cardholderName => 'Nom du Titulaire';

  @override
  String get cardholderNameHint => 'Jean Dupont';

  @override
  String get expiryDate => 'Date d\'Expiration';

  @override
  String get cvv => 'CVV';

  @override
  String get pleaseEnterCardNumber => 'Veuillez entrer le numéro de carte';

  @override
  String get pleaseEnterValidCardNumber =>
      'Veuillez entrer un numéro de carte valide';

  @override
  String get pleaseEnterCardholderName => 'Veuillez entrer le nom du titulaire';

  @override
  String get required => 'Requis';

  @override
  String get invalidFormat => 'Format invalide';

  @override
  String get invalidCvv => 'CVV invalide';

  @override
  String get mobileMoneyProvider => 'Fournisseur Mobile Money';

  @override
  String get pleaseEnterPhoneNumber => 'Veuillez entrer le numéro de téléphone';

  @override
  String get pleaseSelectProvider => 'Veuillez sélectionner un fournisseur';

  @override
  String get bankTransferDetailsTitle => 'Détails du Virement Bancaire:';

  @override
  String referenceNumber(String timestamp) {
    return 'Référence: COMMANDE-$timestamp';
  }

  @override
  String get emailForConfirmation => 'Email pour Confirmation de Paiement';

  @override
  String get pleaseEnterEmail => 'Veuillez saisir votre email';

  @override
  String get pleaseEnterValidEmail => 'Veuillez saisir un email valide';

  @override
  String get cashOnDeliveryInfo => 'Informations Paiement à la Livraison';

  @override
  String get orderConfirmationSms =>
      '• La confirmation de commande sera envoyée par SMS';

  @override
  String get deliveryDetails => 'Détails de Livraison';

  @override
  String get deliveryAddress => 'Adresse de Livraison *';

  @override
  String get deliveryAddressHint => 'Entrez l\'adresse complète de livraison';

  @override
  String get contactPhoneNumber => 'Numéro de Téléphone de Contact *';

  @override
  String get contactPhoneHint => '+237 6XX XXX XXX';

  @override
  String get deliveryInstructions => 'Instructions de Livraison (Optionnel)';

  @override
  String get deliveryInstructionsHint =>
      'Instructions spéciales pour la livraison...';

  @override
  String get pleaseEnterDeliveryAddress =>
      'Veuillez entrer l\'adresse de livraison';

  @override
  String get pleaseEnterCompleteAddress =>
      'Veuillez entrer une adresse complète';

  @override
  String get pleaseEnterContactPhone =>
      'Veuillez entrer le téléphone de contact';

  @override
  String get pleaseEnterValidPhone => 'Veuillez entrer un numéro valide';

  @override
  String get deliveryOptions => 'Options de Livraison';

  @override
  String get standardDelivery => 'Livraison Standard (2-4 heures)';

  @override
  String get standardDeliveryDesc => 'Gratuit dans les limites de la ville';

  @override
  String get expressDelivery => 'Livraison Express (1-2 heures)';

  @override
  String get expressDeliveryDesc => 'Supplément de 3,00\$';

  @override
  String get placingOrder => 'Passage de Commande...';

  @override
  String get processingPayment => 'Traitement du Paiement...';

  @override
  String payOnDeliveryButton(String amount) {
    return 'Passer Commande - \$$amount (Paiement à la Livraison)';
  }

  @override
  String payNowButton(String amount) {
    return 'Payer Maintenant - \$$amount';
  }

  @override
  String get orderPlacedSuccess =>
      'Commande passée avec succès! Nous livrerons et collecterons le paiement.';

  @override
  String orderPlacementFailed(String error) {
    return 'Échec du passage de commande: $error';
  }

  @override
  String get resetForm => 'Réinitialiser le Formulaire';

  @override
  String get resetFormConfirmation =>
      'Êtes-vous sûr de vouloir réinitialiser tous les changements? Cela restaurera les valeurs originales.';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get formResetToOriginal =>
      'Formulaire réinitialisé aux valeurs originales';

  @override
  String get resetFormTooltip => 'Réinitialiser le Formulaire';

  @override
  String get saveChangesTooltip => 'Sauvegarder les Modifications';

  @override
  String get notificationPreferences => 'Préférences de Notification';

  @override
  String get privacySettings => 'Paramètres de Confidentialité';

  @override
  String get gender => 'Genre';

  @override
  String get dateOfBirth => 'Date de Naissance';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get other => 'Autre';

  @override
  String get selectDate => 'Sélectionner la Date';

  @override
  String get country => 'Pays';

  @override
  String get selectCountry => 'Sélectionner le Pays';

  @override
  String get emailNotifications => 'Notifications par email';

  @override
  String get smsNotifications => 'Notifications SMS';

  @override
  String get marketingEmails => 'Emails marketing';

  @override
  String get pushNotifications => 'Notifications Push';

  @override
  String get receiveGeneralUpdates =>
      'Recevoir les mises à jour générales et notifications par email';

  @override
  String get receiveSmsAlerts =>
      'Recevoir les alertes SMS pour les mises à jour importantes';

  @override
  String get receiveMarketingContent =>
      'Recevoir le contenu promotionnel et emails marketing';

  @override
  String get receivePushNotifications =>
      'Recevoir les notifications push sur votre appareil';

  @override
  String get profileVisibility => 'Visibilité du Profil';

  @override
  String get showBirthday => 'Afficher l\'Anniversaire';

  @override
  String get showPhone => 'Afficher le Numéro de Téléphone';

  @override
  String get makeProfileVisible =>
      'Rendre votre profil visible aux autres utilisateurs';

  @override
  String get displayBirthdayOnProfile =>
      'Afficher votre anniversaire sur votre profil';

  @override
  String get displayPhoneOnProfile =>
      'Afficher votre numéro de téléphone sur votre profil';

  @override
  String get saveInformation => 'Sauvegarder les Informations';

  @override
  String get changeProfilePicture => '• Changer la photo de profil';

  @override
  String get takePhoto => 'Prendre une Photo';

  @override
  String get chooseFromGallery => 'Choisir dans la Galerie';

  @override
  String get removePhoto => 'Supprimer la Photo';

  @override
  String get firstNameRequired => 'Le prénom est requis';

  @override
  String get firstNameTooShort =>
      'Le prénom doit contenir au moins 2 caractères';

  @override
  String get lastNameRequired => 'Le nom de famille est requis';

  @override
  String get lastNameTooShort =>
      'Le nom de famille doit contenir au moins 2 caractères';

  @override
  String get emailRequired => 'L\'email est requis';

  @override
  String get invalidEmailFormat => 'Format d\'email invalide';

  @override
  String get phoneRequired => 'Le numéro de téléphone est requis';

  @override
  String get phoneTooShort =>
      'Le numéro de téléphone doit contenir au moins 10 chiffres';

  @override
  String get addressRequired => 'L\'adresse est requise';

  @override
  String get addressTooShort =>
      'L\'adresse doit contenir au moins 5 caractères';

  @override
  String get cityRequired => 'La ville est requise';

  @override
  String get cityTooShort =>
      'Le nom de la ville doit contenir au moins 2 caractères';

  @override
  String get zipCodeRequired => 'Le code postal est requis';

  @override
  String get invalidZipCode => 'Format de code postal invalide';

  @override
  String get unitedStates => 'États-Unis';

  @override
  String get canada => 'Canada';

  @override
  String get unitedKingdom => 'Royaume-Uni';

  @override
  String get germany => 'Allemagne';

  @override
  String get france => 'France';

  @override
  String get spain => 'Espagne';

  @override
  String get italy => 'Italie';

  @override
  String get australia => 'Australie';

  @override
  String get japan => 'Japon';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get signInToYourAccount => 'Connectez-vous à votre compte';

  @override
  String get demoMode =>
      'Mode démo : Formulaire pré-rempli avec des identifiants de test. Cliquez simplement sur \"Se connecter\" !';

  @override
  String get prefilledEmailHelper =>
      'Pré-rempli avec un compte de test (john.doe@example.com)';

  @override
  String get prefilledPasswordHelper =>
      'Pré-rempli avec un mot de passe de test (password123)';

  @override
  String get pleaseEnterPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get passwordMustBe6Characters =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get or => 'ou';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get googleSignInNotImplemented =>
      'La connexion Google serait implémentée ici';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get successfullySignedIn => 'Vous vous êtes connecté avec succès';

  @override
  String get sessionInformation => 'Informations de session';

  @override
  String get signInTime => 'Heure de connexion';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get noAccountFound => 'Aucun compte trouvé avec cette adresse email';

  @override
  String get invalidCredentials => 'Email ou mot de passe invalide';

  @override
  String signInGenericError(String error) {
    return 'Une erreur s\'est produite lors de la connexion : $error';
  }

  @override
  String get signInSuccessMessage =>
      'Bon retour ! Vous vous êtes connecté avec succès.';

  @override
  String get signOutSuccess => 'Déconnexion réussie';

  @override
  String get signOutMessage => 'Vous avez été déconnecté avec succès.';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get forgotPasswordMessage =>
      'La fonctionnalité de réinitialisation de mot de passe serait implémentée ici. Pour cette démo, veuillez utiliser les identifiants pré-remplis.';

  @override
  String welcomeBackUser(String firstName) {
    return 'Bon retour, $firstName !';
  }

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String shoppingCartWithCount(int count) {
    return 'Panier ($count)';
  }

  @override
  String get refreshCart => 'Actualiser le panier';

  @override
  String get clearCart => 'Vider le panier';

  @override
  String get yourCartIsEmpty => 'Votre panier est vide';

  @override
  String get addSomeItemsToGetStarted =>
      'Ajoutez quelques articles pour commencer';

  @override
  String get startShopping => 'Commencer les achats';

  @override
  String itemsCount(int count) {
    return '$count Articles';
  }

  @override
  String totalPrice(String price) {
    return 'Total : $price €';
  }

  @override
  String itemsInCart(int count) {
    return '$count articles';
  }

  @override
  String failedToLoadCartItems(String error) {
    return 'Échec du chargement des articles du panier : $error';
  }

  @override
  String failedToUpdateQuantity(String error) {
    return 'Échec de la mise à jour de la quantité : $error';
  }

  @override
  String get itemRemovedFromCart => 'Article retiré du panier';

  @override
  String failedToRemoveItem(String error) {
    return 'Échec de la suppression de l\'article : $error';
  }

  @override
  String get clearCartConfirmation =>
      'Êtes-vous sûr de vouloir supprimer tous les articles de votre panier ?';

  @override
  String get clear => 'Vider';

  @override
  String get cartCleared => 'Panier vidé';

  @override
  String failedToClearCart(String error) {
    return 'Échec de la suppression du panier : $error';
  }

  @override
  String get yourCartIsEmptyCheckout => 'Votre panier est vide';

  @override
  String get myShoppingCart => 'Mon panier';

  @override
  String get viewCart => 'Voir le panier';

  @override
  String get registration => 'Inscription';

  @override
  String get createYourAccount => 'Créez votre compte';

  @override
  String get agreeToTerms => 'J\'accepte les conditions générales';

  @override
  String get creatingAccount => 'Création du compte...';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get clearForm => 'Effacer le formulaire';

  @override
  String welcomeRegistrationSuccess(String firstName) {
    return 'Bienvenue $firstName ! Inscription réussie !';
  }

  @override
  String get pleaseAgreeToTerms => 'Veuillez accepter les conditions générales';

  @override
  String get registrationSuccessful => 'Inscription réussie !';

  @override
  String get accountCreatedMessage => 'Votre compte a été créé avec succès.';

  @override
  String get registerAnotherUser => 'Inscrire un autre utilisateur';

  @override
  String get register => 'S\'inscrire';

  @override
  String get createNewOrder => 'Créer une Nouvelle Commande';

  @override
  String get orderCreationCancelled => 'Création de commande annulée';

  @override
  String get each => 'chacun';

  @override
  String get actionCancelled => 'Action Annulée';

  @override
  String get removedFromSelection => 'retiré de la sélection';

  @override
  String get addedToCart => 'ajouté au panier';

  @override
  String get failedToAddItemToCart =>
      'Échec de l\'ajout de l\'article au panier';

  @override
  String get itemsAddedToCart => 'Articles ajoutés au panier:';

  @override
  String get failedToAddItemsToCart =>
      'Échec de l\'ajout des articles au panier';

  @override
  String get cartError => 'Erreur de Panier';

  @override
  String get galleryFunctionality =>
      'La fonctionnalité galerie serait implémentée ici';

  @override
  String get profilePictureRemoved => 'Photo de profil supprimée';

  @override
  String get locateNearbyGasStations =>
      'Localiser les stations-service à proximité';

  @override
  String get createTestOrder => 'Créer Commande Test';

  @override
  String get inTransit => 'En Transit';

  @override
  String showingOrders(Object count) {
    return 'Affichage de $count commandes';
  }

  @override
  String get profileUpdatedSuccessfully => 'Profil mis à jour avec succès !';

  @override
  String get cameraFunctionalityNotImplemented =>
      'La fonctionnalité de caméra serait implémentée ici';

  @override
  String get receiveOrderUpdatesEmail =>
      'Recevoir les mises à jour de commande par email';

  @override
  String get receiveOrderUpdatesSMS =>
      'Recevoir les mises à jour de commande par SMS';

  @override
  String get receivePromotionalOffers => 'Recevoir des offres promotionnelles';

  @override
  String get editMyInformation => 'Modifier mes informations';

  @override
  String get profileEditingDescription =>
      'Cela naviguerait vers une page d\'édition de profil où vous pouvez :';

  @override
  String get updatePersonalInfo =>
      '• Mettre à jour les informations personnelles';

  @override
  String get modifyContactDetails => '• Modifier les détails de contact';

  @override
  String get updatePreferences => '• Mettre à jour les préférences';

  @override
  String get refresh => 'Actualiser';

  @override
  String get sortByStatus => 'Statut';

  @override
  String get sortByTotal => 'Total';

  @override
  String get sortByID => 'ID';

  @override
  String get chooseItemsDescription =>
      'Choisissez parmi nos bouteilles de gaz et accessoires disponibles';

  @override
  String get menu => 'Menu';

  @override
  String get settingsTapped => 'Paramètres sélectionnés!';

  @override
  String get aboutTapped => 'À propos sélectionné!';

  @override
  String get logoutTapped => 'Déconnexion sélectionnée!';

  @override
  String get confirmSignOut => 'Êtes-vous sûr de vouloir vous déconnecter?';
}
