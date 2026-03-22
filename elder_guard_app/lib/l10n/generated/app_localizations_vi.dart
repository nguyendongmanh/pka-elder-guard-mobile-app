// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Elder Guard';

  @override
  String get loginAction => 'Đăng nhập';

  @override
  String get registerAction => 'Đăng ký';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Mật khẩu';

  @override
  String get usernameHint => 'Tên người dùng';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get noAccountPrompt => 'Chưa có tài khoản?';

  @override
  String get hasAccountPrompt => 'Đã có tài khoản?';

  @override
  String get signUpNow => 'Đăng ký ngay';

  @override
  String get signInNow => 'Đăng nhập ngay';

  @override
  String get loginIntro => 'Vui lòng đăng nhập để tiếp tục';

  @override
  String get registerIntro => 'Vui lòng điền thông tin để tạo tài khoản';

  @override
  String get switchLanguageLabel => 'Đổi ngôn ngữ';

  @override
  String get requiredFieldError => 'Vui lòng nhập thông tin này.';

  @override
  String get invalidEmailError => 'Vui lòng nhập email hợp lệ.';

  @override
  String get passwordTooShortError => 'Mật khẩu phải có ít nhất 6 ký tự.';

  @override
  String get usernameTooShortError => 'Tên người dùng phải có ít nhất 3 ký tự.';

  @override
  String get registerSuccessMessage => 'Tạo tài khoản thành công. Hãy đăng nhập để tiếp tục.';

  @override
  String get forgotPasswordUnavailable => 'Chức năng quên mật khẩu chưa khả dụng.';

  @override
  String get emailAlreadyExistsError => 'Email này đã được đăng ký.';

  @override
  String get userNotFoundError => 'Không tìm thấy tài khoản với email này.';

  @override
  String get incorrectPasswordError => 'Mật khẩu không chính xác.';

  @override
  String get validationErrorMessage => 'Vui lòng kiểm tra lại thông tin đã nhập.';

  @override
  String get networkErrorMessage => 'Không thể kết nối tới máy chủ. Hãy kiểm tra API localhost.';

  @override
  String get serverErrorMessage => 'Máy chủ trả về phản hồi không hợp lệ.';

  @override
  String get unknownErrorMessage => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get homeTitle => 'Chào mừng quay lại';

  @override
  String get homeSubtitle => 'Bạn đã đăng nhập và sẵn sàng gọi các API cần xác thực.';

  @override
  String signedInAs(String email) {
    return 'Đăng nhập với $email';
  }

  @override
  String connectedToApi(String baseUrl) {
    return 'Đang kết nối tới $baseUrl';
  }

  @override
  String get logoutAction => 'Đăng xuất';

  @override
  String get loadingMessage => 'Đang chuẩn bị ElderGuard...';
}
