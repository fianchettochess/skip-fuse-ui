// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
import SkipSwiftUI

final class AccessibilityOptionSetTests: XCTestCase {
    func testTraitsEmptyAndUnion() {
        let empty = SkipSwiftUI.AccessibilityTraits()
        let literal: SkipSwiftUI.AccessibilityTraits = []
        XCTAssertEqual(empty.rawValue, 0)
        XCTAssertEqual(literal.rawValue, 0)
        XCTAssertFalse(empty.contains(.isSelected))
        let union = SkipSwiftUI.AccessibilityTraits.isSelected.union(.isButton)
        XCTAssertTrue(union.contains(.isSelected))
        XCTAssertTrue(union.contains(.isButton))
        XCTAssertFalse(union.contains(.isHeader))
        var values: SkipSwiftUI.AccessibilityTraits = [.isSelected, .isButton]
        XCTAssertEqual(values, union)
        values.insert(.isHeader)
        XCTAssertTrue(values.contains(.isHeader))
        values.remove(.isSelected)
        XCTAssertFalse(values.contains(.isSelected))
        XCTAssertTrue(values.contains(.isButton))
    }

    func testTechnologiesEmptyAndUnion() {
        let empty = SkipSwiftUI.AccessibilityTechnologies()
        let literal: SkipSwiftUI.AccessibilityTechnologies = []
        XCTAssertEqual(empty.rawValue, 0)
        XCTAssertEqual(literal.rawValue, 0)
        XCTAssertFalse(empty.contains(.voiceOver))
        let union = SkipSwiftUI.AccessibilityTechnologies.voiceOver.union(.switchControl)
        XCTAssertTrue(union.contains(.voiceOver))
        XCTAssertTrue(union.contains(.switchControl))
        var values: SkipSwiftUI.AccessibilityTechnologies = [.voiceOver, .switchControl]
        XCTAssertEqual(values, union)
        values.remove(.voiceOver)
        XCTAssertFalse(values.contains(.voiceOver))
        XCTAssertTrue(values.contains(.switchControl))
        values.insert(.voiceOver)
        XCTAssertEqual(values, union)
    }
}
#endif
