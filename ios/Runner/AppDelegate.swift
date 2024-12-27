import Flutter
import UIKit

@main
@objc class orlogoDelegate: FlutterorlogoDelegate {
  override func orlogolication(
    _ orlogolication: UIorlogolication,
    didFinishLaunchingWithOptions launchOptions: [UIorlogolication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.orlogolication(orlogolication, didFinishLaunchingWithOptions: launchOptions)
  }
}
