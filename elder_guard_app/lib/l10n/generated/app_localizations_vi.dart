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
  String get networkErrorMessage => 'Không thể kết nối tới máy chủ. Hãy kiểm tra cấu hình API.';

  @override
  String get serverErrorMessage => 'Máy chủ trả về phản hồi không hợp lệ.';

  @override
  String get unknownErrorMessage => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get homeTitle => 'Chào mừng quay lại';

  @override
  String get homeSubtitle => 'Bạn đã đăng nhập và sẵn sàng gọi các API cần xác thực.';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navMonitoring => 'Giám sát';

  @override
  String get navAlerts => 'Cảnh báo';

  @override
  String get navMenu => 'Menu';

  @override
  String dashboardHeartRateSummary(int value) {
    return 'Nhịp tim trung bình: $value bpm';
  }

  @override
  String dashboardStepSummary(int value) {
    return 'Số bước chân: $value';
  }

  @override
  String get monitoringTitle => 'Giám sát camera';

  @override
  String get monitoringSubtitle => 'Theo dõi nhanh các khu vực quan trọng trong nhà.';

  @override
  String get monitoringAddCameraAction => 'Thêm camera';

  @override
  String get monitoringAddCameraTitle => 'Thêm camera demo';

  @override
  String get monitoringEditCameraTitle => 'Đổi tên camera';

  @override
  String get monitoringCameraNameLabel => 'Tên camera';

  @override
  String get monitoringCameraNameHint => 'Nhập tên camera';

  @override
  String get monitoringCancelAction => 'Hủy';

  @override
  String get monitoringSaveAction => 'Lưu';

  @override
  String get monitoringRenameAction => 'Sửa tên';

  @override
  String get monitoringDeleteAction => 'Xóa camera';

  @override
  String get monitoringDemoBadge => 'DEMO';

  @override
  String get monitoringTapToView => 'Widget camera demo, không phát video.';

  @override
  String monitoringDemoTapMessage(String cameraName) {
    return '$cameraName hiện chỉ là widget demo.';
  }

  @override
  String get monitoringEmptyTitle => 'Chưa có camera demo nào';

  @override
  String get monitoringEmptyDescription => 'Hãy thêm camera để thử giao diện giám sát dạng demo.';

  @override
  String get monitoringLivingRoomCamera => 'Camera phòng khách';

  @override
  String get monitoringEntryCamera => 'Camera cửa ra vào';

  @override
  String get monitoringLiveStatus => 'TRỰC TIẾP';

  @override
  String get monitoringRecentMovement => 'Phát hiện chuyển động 2 phút trước.';

  @override
  String get monitoringNoMovement => 'Yên tĩnh trong 20 phút gần đây.';

  @override
  String get alertsTitle => 'Cảnh báo chăm sóc';

  @override
  String get alertsSubtitle => 'Nhắc nhở và cập nhật hoạt động gần đây.';

  @override
  String get alertsMedicationReminderTitle => 'Nhắc uống thuốc';

  @override
  String get alertsMedicationReminderBody => '08:00 - Đã xác nhận uống thuốc buổi sáng.';

  @override
  String get alertsMovementUpdateTitle => 'Cập nhật di chuyển';

  @override
  String get alertsMovementUpdateBody => '21:10 - Phát hiện đi lại ban đêm.';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuPersonalInfoTitle => 'Thông tin cá nhân';

  @override
  String get menuHealthProfileTitle => 'Hồ sơ sức khỏe';

  @override
  String get menuSettingsPrivacyTitle => 'Cài đặt và quyền riêng tư';

  @override
  String get menuAboutTitle => 'Giới thiệu';

  @override
  String menuComingSoonMessage(String section) {
    return '$section sẽ sớm được cập nhật.';
  }

  @override
  String get healthProfileDemoDescription => 'Dữ liệu dưới đây là hồ sơ sức khỏe mô phỏng để demo giao diện theo dõi người cao tuổi.';

  @override
  String get healthProfileDemoBadge => 'DỮ LIỆU DEMO';

  @override
  String get healthProfileDemoName => 'Nguyễn Thị Lan';

  @override
  String get healthProfileAgeLabel => 'Tuổi';

  @override
  String healthProfileAgeValue(String label, int age) {
    return '$label: $age';
  }

  @override
  String healthProfileFieldValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get healthProfileBloodTypeLabel => 'Nhóm máu';

  @override
  String get healthProfileCareLevelLabel => 'Mức chăm sóc';

  @override
  String get healthProfileCareLevelValue => 'Theo dõi hằng ngày';

  @override
  String get healthProfileVitalsSection => 'Chỉ số sinh tồn';

  @override
  String get healthProfileHeartRateLabel => 'Nhịp tim nghỉ';

  @override
  String healthProfileHeartRateValue(int value) {
    return '$value bpm';
  }

  @override
  String get healthProfileBloodPressureLabel => 'Huyết áp';

  @override
  String get healthProfileSpo2Label => 'SpO2';

  @override
  String healthProfileSpo2Value(int value) {
    return '$value%';
  }

  @override
  String get healthProfileWeightLabel => 'Cân nặng';

  @override
  String healthProfileWeightValue(int value) {
    return '$value kg';
  }

  @override
  String get healthProfileConditionsSection => 'Bệnh nền và ghi chú';

  @override
  String get healthProfileConditionHypertension => 'Tăng huyết áp';

  @override
  String get healthProfileConditionArthritis => 'Thoái hóa khớp';

  @override
  String get healthProfileConditionMemory => 'Suy giảm trí nhớ nhẹ';

  @override
  String get healthProfileAllergyLabel => 'Dị ứng';

  @override
  String get healthProfileAllergyValue => 'Chưa ghi nhận dị ứng thuốc';

  @override
  String get healthProfileLastCheckupLabel => 'Lần khám gần nhất';

  @override
  String get healthProfileLastCheckupValue => '26/03/2026';

  @override
  String get healthProfileMedicationSection => 'Lịch dùng thuốc';

  @override
  String get healthProfileMedicationMorningLabel => 'Buổi sáng';

  @override
  String get healthProfileMedicationMorningValue => 'Amlodipine 5mg sau bữa sáng';

  @override
  String get healthProfileMedicationEveningLabel => 'Buổi tối';

  @override
  String get healthProfileMedicationEveningValue => 'Canxi D3 trước khi ngủ';

  @override
  String get healthProfileEmergencySection => 'Liên hệ khẩn cấp';

  @override
  String get healthProfileEmergencyContactLabel => 'Người liên hệ';

  @override
  String get healthProfileEmergencyContactValue => 'Nguyễn Minh Tuấn (con trai)';

  @override
  String get healthProfileEmergencyPhoneLabel => 'Số điện thoại';

  @override
  String get healthProfileEmergencyPhoneValue => '0903 456 789';

  @override
  String get healthProfileAddressLabel => 'Địa chỉ';

  @override
  String get healthProfileAddressValue => '145 Lê Lợi, Quận 1, TP.HCM';

  @override
  String get notificationCenterTitle => 'Thông báo';

  @override
  String get notificationCenterSubtitle => 'Các cảnh báo push đã nhận trên thiết bị này.';

  @override
  String get notificationEmptyMessage => 'Chưa có thông báo nào.';

  @override
  String get notificationStatusTitle => 'Trạng thái push';

  @override
  String get notificationRegistrationLabel => 'Đăng ký với backend';

  @override
  String get notificationSubscriptionLabel => 'Subscription ID';

  @override
  String get notificationUserLabel => 'User ID';

  @override
  String get notificationStatusWaitingForLogin => 'Đang chờ đăng nhập';

  @override
  String get notificationStatusWaitingForSubscription => 'Đang chờ subscription ID';

  @override
  String get notificationStatusRegistered => 'Đã đăng ký';

  @override
  String get notificationStatusFailed => 'Đăng ký thất bại';

  @override
  String get notificationPopupOpenAction => 'Mở';

  @override
  String get notificationSourceForeground => 'Foreground';

  @override
  String get notificationSourceOpened => 'Đã mở';

  @override
  String get notificationLoadingList => 'Đang tải danh sách thông báo...';

  @override
  String get notificationLoadingDetails => 'Đang tải chi tiết thông báo...';

  @override
  String get notificationRetryAction => 'Thử lại';

  @override
  String get notificationNotFoundMessage => 'Không tìm thấy thông báo này.';

  @override
  String notificationItemTitle(int cameraId) {
    return 'Cảnh báo camera $cameraId';
  }

  @override
  String notificationItemBody(String eventType, String timestamp) {
    return 'Phát hiện $eventType lúc $timestamp';
  }

  @override
  String notificationDetailTitle(int eventId) {
    return 'Thông báo #$eventId';
  }

  @override
  String get notificationFieldEventId => 'Mã sự kiện';

  @override
  String get notificationFieldCameraId => 'Mã camera';

  @override
  String get notificationFieldEventType => 'Loại sự kiện';

  @override
  String get notificationFieldConfidence => 'Độ tin cậy';

  @override
  String get notificationFieldTimestamp => 'Thời gian';

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
