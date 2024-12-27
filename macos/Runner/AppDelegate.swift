import Cocoa
import FlutterMacOS

@main
class orlogoDelegate: FlutterorlogoDelegate {
  override func orlogolicationShouldTerminateAfterLastWindowClosed(_ sender: NSorlogolication) -> Bool {
    return true
  }
}
