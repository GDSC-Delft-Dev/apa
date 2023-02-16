import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // The "googleMapsApiKey" variable is fetched from Debug.xcconfig
    GMSServices.provideAPIKey(Bundle.main.object(forInfoDictionaryKey:"googleMapsApiKey") as? String ?? "");
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
