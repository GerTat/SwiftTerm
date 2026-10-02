#if os(iOS)
import UIKit
import XCTest
@testable import SwiftTerm

final class IOSAccessorySafeAreaTests: XCTestCase {
    private final class Accessory: TerminalAccessory {
        var testSafeAreaInsets = UIEdgeInsets.zero

        override var safeAreaInsets: UIEdgeInsets { testSafeAreaInsets }
    }

    func testLandscapeKeysStayInsideSafeArea() {
        let terminal = TerminalView(frame: CGRect(x: 0, y: 0, width: 956, height: 200))
        let accessory = Accessory(
            frame: CGRect(x: 0, y: 0, width: 956, height: 36),
            inputViewStyle: .keyboard,
            container: terminal
        )
        accessory.testSafeAreaInsets = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 62)
        accessory.safeAreaInsetsDidChange()

        XCTAssertGreaterThanOrEqual(accessory.views.first?.frame.minX ?? -1, 62)
        XCTAssertLessThanOrEqual(accessory.views.last?.frame.maxX ?? .infinity, 894)
        XCTAssertGreaterThan(accessory.views.count, 0)
    }

    func testSafeAreaChangeRebuildsKeyWidths() {
        let terminal = TerminalView(frame: CGRect(x: 0, y: 0, width: 956, height: 200))
        let accessory = Accessory(
            frame: CGRect(x: 0, y: 0, width: 956, height: 36),
            inputViewStyle: .keyboard,
            container: terminal
        )
        accessory.testSafeAreaInsets = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 62)
        accessory.safeAreaInsetsDidChange()
        let landscapeCount = accessory.views.count
        accessory.controlModifier = true

        accessory.testSafeAreaInsets = .zero
        accessory.safeAreaInsetsDidChange()

        XCTAssertEqual(accessory.views.first?.frame.minX, 2)
        XCTAssertGreaterThanOrEqual(accessory.views.count, landscapeCount)
        XCTAssertLessThanOrEqual(accessory.views.last?.frame.maxX ?? .infinity, 954)
        XCTAssertTrue(accessory.controlButton?.isSelected ?? false)
    }
}
#endif
