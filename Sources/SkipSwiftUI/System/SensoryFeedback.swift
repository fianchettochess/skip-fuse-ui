// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import SkipBridge
import SkipUI

public struct SensoryFeedback : Equatable, Sendable {
    let identifier: Int // For bridging

    public static let success = SensoryFeedback(identifier: 1) // For bridging

    public static let warning = SensoryFeedback(identifier: 2) // For bridging

    public static let error = SensoryFeedback(identifier: 3) // For bridging

    public static let selection = SensoryFeedback(identifier: 4) // For bridging

    public static let increase = SensoryFeedback(identifier: 5) // For bridging

    public static let decrease = SensoryFeedback(identifier: 6) // For bridging

    public static let start = SensoryFeedback(identifier: 7) // For bridging

    public static let stop = SensoryFeedback(identifier: 8) // For bridging

    public static let alignment = SensoryFeedback(identifier: 9) // For bridging

    public static let levelChange = SensoryFeedback(identifier: 10) // For bridging

    @available(*, unavailable)
    public static let pathComplete = SensoryFeedback(identifier: -1)

    public static let impact = SensoryFeedback(identifier: 11) // For bridging

    public static func impact(weight: SensoryFeedback.Weight = .medium, intensity: Double = 1.0) -> SensoryFeedback {
        return SensoryFeedback(identifier: HapticFeedbackImpact(style: weight.style, intensity: intensity).rawValue)
    }

    public static func impact(flexibility: SensoryFeedback.Flexibility, intensity: Double = 1.0) -> SensoryFeedback {
        return SensoryFeedback(identifier: HapticFeedbackImpact(style: flexibility.style, intensity: intensity).rawValue)
    }

    public struct Weight : Equatable, Sendable {
        fileprivate let style: HapticFeedbackImpact.Style
        public static let light = SensoryFeedback.Weight(style: .light)

        public static let medium = SensoryFeedback.Weight(style: .medium)

        public static let heavy = SensoryFeedback.Weight(style: .heavy)
    }

    public struct Flexibility : Hashable, Sendable {
        fileprivate let style: HapticFeedbackImpact.Style
        public static let rigid = SensoryFeedback.Flexibility(style: .rigid)

        public static let solid = SensoryFeedback.Flexibility(style: .medium)

        public static let soft = SensoryFeedback.Flexibility(style: .soft)
    }
}

extension View {
    nonisolated public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T) -> some View where T : Equatable {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.sensoryFeedback(bridgedFeedback: feedback.identifier, trigger: SwiftEquatable(trigger))
        }
    }

    nonisolated public func sensoryFeedback<T>(_ feedback: SensoryFeedback, trigger: T, condition: @escaping (_ oldValue: T, _ newValue: T) -> Bool) -> some View where T : Equatable {
        return self.sensoryFeedback(trigger: trigger) { oldValue, newValue in
            return condition(oldValue, newValue) ? feedback : nil
        }
    }

    nonisolated public func sensoryFeedback<T>(trigger: T, _ feedback: @escaping (_ oldValue: T, _ newValue: T) -> SensoryFeedback?) -> some View where T : Equatable {
        return ModifierView(target: self) {
            $0.Java_viewOrEmpty.sensoryFeedbackClosure(trigger: SwiftEquatable(trigger), bridgedFeedback: { oldValue, newValue in
                let oldUnwrapped = (oldValue as? SwiftEquatable)?.base as! T
                let newUnwrapped = (newValue as? SwiftEquatable)?.base as! T
                guard let feedback = feedback(oldUnwrapped, newUnwrapped) else {
                    return nil
                }
                return feedback.identifier
            })
        }
    }
}
