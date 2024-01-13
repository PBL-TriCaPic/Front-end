import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  ////////////////////////////////////
  /// スクショ制限機能として追加
  private var textField = UITextField()
  ////////////////////////////////////

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    ///////////////////////////////// /
    /// スクショ制限機能として追加
    makeSecureYourScreen()
    let controller : FlutterViewController = self.window?.rootViewController as! FlutterViewController
    let securityChannel = FlutterMethodChannel(name: "secureScreenshotChannel", binaryMessenger: controller.binaryMessenger)
    securityChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "secureiOS" {
            self.textField.isSecureTextEntry = true
        } else if call.method == "unSecureiOS" {
            self.textField.isSecureTextEntry = false
        }
    })
    //////////////////////////////////

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  //////////////////////////////////
  /// スクショ制限機能として追加
  private func makeSecureYourScreen() {
    if(!self.window.subviews.contains(textField)){
      self.window.addSubview(textField)
      textField.centerYAnchor.constraint(equalTo: self.window.centerYAnchor).isActive = true
      textField.centerXAnchor.constraint(equalTo: self.window.centerXAnchor).isActive = true
      self.window.layer.superlayer?.addSublayer(textField.layer)
      textField.layer.sublayers?.first?.addSublayer(self.window.layer)
    }
  }
  //////////////////////////////////
}
