

import Foundation

@available(iOS 15.0, *)
protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}
@available(iOS 15.0, *)

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
