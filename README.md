# notification_app_demo
Một ứng dụng demo đẩy thông báo bằng Flutter và Firebase Cloud Messaging
## Hướng dẫn cài đặt
1. Build/Run debug file main.dart trong thư mục lib bằng VisualStudioCode hoặc AndroidStudio lên trên một thiết bị giả lập Android nào đó (Ví dụ AndroidStimulator của AnroidStudio)
2. Sau đó sử dụng Firebase để push notification đến app
## Hướng dẫn sử dụng Firebase Cloud Messaging
1. Đăng ký email với mình (nhắn tin zalo/email đến itmtak48@gmail.com) để mình add vào firebase project
2. Vào https://console.firebase.google.com/ tìm đến project FlutterAppTesting, chọn Cloud Messaging, chọn "New Notification"
3. Mục 1 - Notification: Nhập tiêu đề, nội dung của thông báo, xong chọn "Next" đến mục 2,
4. Mục 2 - Target: Chọn APP rồi chọn đến ứng dụng PushNotificationAndroid (com.example.notification_app_v2), xong chọn "Next" đến mục 3,
5. Mục 3 - Schedule: Chọn "Now", xong chọn "Next" đến mục 4,
6. Mục 4 - Additional Option: Ở mục Custom Data nhập các giá trị: key = "click_action", value = "FLUTTER_NOTIFICATION_CLICK", xong chọn "Preview"
7. Xuất hiển pop-up xác nhận, chọn Publish
Cloud Messaging sẽ gửi 1 notification đến app đang cài đặt trên thiết bị giả lập Android, ngay cả khi ứng dụng đó đã bị đóng hoặc chạy trong background.
