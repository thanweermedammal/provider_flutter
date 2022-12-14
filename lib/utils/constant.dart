import 'package:nb_utils/nb_utils.dart';

const packageName = "com.elcon.service.provider"; // Don't Change it.

//region Configs
const decimalPoint = 2;
const perPageItem = 25;
const planRemainingDays = 15;
//endregion

//region Commission Types
const CommissionTypePercent = 'percent';
const CommissionTypeFixed = 'fixed';
//endregion

const DiscountTypeFixed = 'fixed';

//region Messages
var passwordLengthMsg =
    'Password length should be more than $passwordLengthGlobal';
//endregion

//region Countdown
const startTimer = "startTimer";
const pauseTimer = "pauseTimer";
const resumeTimer = "resumeTimer";
//endregion

//region LiveStream Keys
const tokenStream = 'tokenStream';
const streamTab = 'streamTab';
const LiveStreamUpdateBookings = 'LiveStreamUpdateBookings';
const HandyBoardStream = 'HandyBoardStream';
const handymanAllBooking = "handymanAllBooking";
const providerAllBooking = "providerAllBooking";

//endregion

//region Theme Mode Type
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;
//endregion

//region SharedPreferences Keys
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_TESTER = 'IS_TESTER';
const USER_ID = 'USER_ID';
const USER_TYPE = 'USER_TYPE';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const STATUS = 'STATUS';
const ADDRESS = 'ADDRESS';
const PLAYERID = 'PLAYERID';
const UID = 'UID';
const SERVICE_ADDRESS_ID = 'SERVICE_ADDRESS_ID';
const PROVIDER_ID = 'PROVIDER_ID';
const TOTAL_BOOKING = 'total_booking';
const CREATED_AT = 'created_at';
const IS_PLAN_SUBSCRIBE = 'IS_PLAN_SUBSCRIBE';
const PLAN_TITLE = 'PLAN_TITLE';
const PLAN_END_DATE = 'PLAN_END_DATE';
const PLAN_IDENTIFIER = 'PLAN_IDENTIFIER';
const PAYMENT_LIST = 'PAYMENT_LIST';
const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERM_CONDITIONS = 'TERM_CONDITIONS';
const INQUIRY_EMAIL = 'INQUIRY_EMAIL';
const HELPLINE_NUMBER = 'HELPLINE_NUMBER';
const PASSWORD = 'PASSWORD';
const IN_MAINTENANCE_MODE = 'inMaintenanceMode';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';
const HAS_IN_REVIEW = 'hasInReview';
const SERVER_LANGUAGES = 'SERVER_LANGUAGES';

//endregion

//region  Login Type
const UserTypeProvider = 'provider';
const UserTypeHandyman = 'handyman';
const UserStatusCode = 1;
//endregion

//region ProviderType
const ProviderTypeFreelance = 'freelance';
const ProviderTypeCompany = 'company';
//endregion

//region Notification Mark as Read
const MarkAsRead = 'markas_read';
//endregion

//region SERVICE TYPE

const ServiceTypeHourly = 'hourly';
const ServiceTypeFixed = 'fixed';
const TXT_HOURLY = 'hr';
//endregion

//region Errors
const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User not found";
//endregion

//region service payment method
const COD = 'cash';
//endregion

//region service payment status
const PAID = 'paid';
const PENDING = 'pending';
//endregion

//region ProviderStore
const RESTORE = "restore";
const FORCE_DELETE = "forcedelete";
const type = "type";
//endregion

//region default handyman login
const DEFAULT_PROVIDER_EMAIL = 'demo@provider.com';
const DEFAULT_HANDYMAN_EMAIL = 'demo@handyman.com';
const DEFAULT_PASS = '12345678';
//endregion

//region currency
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const SELECT_SUBCATEGORY = "SELECT_SUBCATEGORY";
const SELECT_USER_TYPE = "SELECT_USER_TYPE";
const PER_PAGE_CHAT_COUNT = 50;
const PER_PAGE_CHAT_LIST_COUNT = 10;

const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region RTLLanguage
List<String> RTLLanguage = ['ar', 'ur'];
//endregion

//region MessageType
enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}
//endregion

//region MessageExtension
extension MessageExtension on MessageType {
  String? get name {
    switch (this) {
      case MessageType.TEXT:
        return 'TEXT';
      case MessageType.IMAGE:
        return 'IMAGE';
      case MessageType.VIDEO:
        return 'VIDEO';
      case MessageType.AUDIO:
        return 'AUDIO';
      default:
        return null;
    }
  }
}
//endregion

//region SERVICE PAYMENT STATUS
const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const SERVICE_PAYMENT_STATUS_PENDING = 'pending';
//endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
//endregion

//region DateFormat
const DATE_FORMAT_1 = 'M/d/yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'hh:mm a';
const DATE_FORMAT_4 = 'd MMM';
const DATE_FORMAT_5 = 'yyyy';
const DATE_FORMAT_6 = 'd MMMM, yyyy';
const DATE_FORMAT_7 = 'yyyy-MM-dd';
//endregion

//region SUBSCRIPTION PAYMENT STATUS
const SUBSCRIPTION_STATUS_ACTIVE = 'active';
const SUBSCRIPTION_STATUS_INACTIVE = 'inactive';
//endregion

//region EARNING TYPE
const EARNING_TYPE = 'EARNING_TYPE';
const EARNING_TYPE_COMMISSION = 'commission';
const EARNING_TYPE_SUBSCRIPTION = 'subscription';
const FREE = 'free';
//endregion

//region WALLET TYPE
const ADD_WALLET = 'add_wallet';
const UPDATE_WALLET = 'update_wallet';
const WALLET_PAYOUT_TRANSFER = 'wallet_payout_transfer';
//endregion

const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';
