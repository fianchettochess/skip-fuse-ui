// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
#if !SKIP
@testable import SkipSwiftUI
import SkipUI

final class SensoryFeedbackTests: XCTestCase {
    func testWeightValuesAndBridgeIdentifiersAreDistinct() {
        XCTAssertNotEqual(SensoryFeedback.Weight.light, .medium)
        XCTAssertNotEqual(SensoryFeedback.Weight.medium, .heavy)
        XCTAssertNotEqual(SensoryFeedback.Weight.light, .heavy)
        let effects = [SensoryFeedback.Weight.light, .medium, .heavy].map {
            SensoryFeedback.impact(weight: $0)
        }
        XCTAssertEqual(Set(effects.map { $0.identifier }).count, 3)
    }

    func testFlexibilityValuesAndBridgeIdentifiersAreDistinct() {
        let values: [SensoryFeedback.Flexibility] = [.soft, .solid, .rigid]
        XCTAssertEqual(Set(values).count, 3)
        XCTAssertEqual(Set(values.map { SensoryFeedback.impact(flexibility: $0).identifier }).count, 3)
    }

    func testIntensitySurvivesTheNativeBridge() {
        let values = [0.0, 0.25, 0.5, 1.0].map {
            SensoryFeedback.impact(weight: .medium, intensity: $0).identifier
        }
        XCTAssertEqual(Set(values).count, 4)
    }

    func testExistingBridgeConstantsRemainCompatible() {
        XCTAssertEqual(SensoryFeedback.success.identifier, 1)
        XCTAssertEqual(SensoryFeedback.warning.identifier, 2)
        XCTAssertEqual(SensoryFeedback.error.identifier, 3)
        XCTAssertEqual(SensoryFeedback.impact.identifier, 11)
        XCTAssertEqual(SensoryFeedback.impact(weight: .medium), .impact)
    }
    func testNativeIdentifiersDecodeWithTheAndroidWireContract() throws {
        let weights: [(SkipSwiftUI.SensoryFeedback.Weight, HapticFeedbackImpact.Style)] = [
            (.light, .light), (.medium, .medium), (.heavy, .heavy)
        ]
        for (weight, style) in weights {
            for intensity in [0.0, 0.25, 0.5, 1.0] {
                let feedback = SkipSwiftUI.SensoryFeedback.impact(weight: weight, intensity: intensity)
                let decoded = try XCTUnwrap(HapticFeedbackImpact(rawValue: feedback.identifier))
                XCTAssertEqual(decoded.style, style)
                XCTAssertEqual(decoded.intensity, intensity, accuracy: 1.0 / 65535.0)
            }
        }
        let flexibilities: [(SkipSwiftUI.SensoryFeedback.Flexibility, HapticFeedbackImpact.Style)] = [
            (.soft, .soft), (.solid, .medium), (.rigid, .rigid)
        ]
        for (flexibility, style) in flexibilities {
            let feedback = SkipSwiftUI.SensoryFeedback.impact(flexibility: flexibility, intensity: 0.5)
            let decoded = try XCTUnwrap(HapticFeedbackImpact(rawValue: feedback.identifier))
            XCTAssertEqual(decoded.style, style)
            XCTAssertEqual(decoded.intensity, 0.5, accuracy: 1.0 / 65535.0)
        }
    }

}
#endif
