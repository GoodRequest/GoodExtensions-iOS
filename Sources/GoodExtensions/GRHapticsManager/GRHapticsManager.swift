//
//  GRHapticsManager.swift
//  
//
//  Created by Marek Vrican on 20/02/2023.
//  Copyright © GoodRequest s.r.o. All rights reserved.

import UIKit
import CoreHaptics

/// The `GRHapticsManager` class manages haptic feedback for a user interface.
public final class GRHapticsManager {

    /// An enumeration representing different levels of impact feedback.
    public enum ImpactGeneratorStyle {

        case light
        case medium
        case heavy

    }

    // MARK: - Constants

    /// A singleton instance of the `GRHapticsManager` class.
    public static let shared = GRHapticsManager()

    /// A `UINotificationFeedbackGenerator` that generates notification feedback.
    private let notificationGenerator = UINotificationFeedbackGenerator()

    /// A `UISelectionFeedbackGenerator` that generates selection feedback.
    private let selectionGenerator = UISelectionFeedbackGenerator()

    /// `UIImpactFeedbackGenerator`s that generate impact feedback at different levels.
    private let impactGenerators = (
        light: UIImpactFeedbackGenerator(style: .light),
        medium: UIImpactFeedbackGenerator(style: .medium),
        heavy: UIImpactFeedbackGenerator(style: .heavy)
    )

    /// The haptic engine used for custom haptic patterns.
    private var engine: CHHapticEngine?

    /// A boolean value indicating whether the device supports haptic feedback.
    private var supportsHaptics: Bool = false

    // MARK: - Initializer

    /// Initializes the haptic engine and sets the `supportsHaptics` property based on whether the device supports haptic feedback.
    private init() {
        initHapticEngine()
    }

}

// MARK: - Public

public extension GRHapticsManager {

    /// Plays a haptic feedback with the given intensity, sharpness, and duration.
    ///
    /// - Parameters:
    ///   - intensity: The intensity of the haptic feedback. Valid values are between 0 and 1.
    ///   - sharpness: The sharpness of the haptic feedback. Valid values are between 0 and 1.
    ///   - duration: The duration of the haptic feedback in seconds.
    ///
    /// This method requires a device that supports haptic feedback. If the device does not support haptic feedback, this method does nothing.
    func playHapticFeedback(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard supportsHaptics else { return }

        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)

        let hapticEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensityParameter, sharpnessParameter],
            relativeTime: 0,
            duration: duration
        )

        playCustomHaptics(events: [hapticEvent])
    }

    /// Plays a notification feedback with the given feedback type.
    ///
    /// - Parameter feedback: The feedback type to play.
    func playNotificationFeedback(_ feedback: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.notificationOccurred(feedback)
    }

    /// Plays a custom haptic pattern.
    ///
    /// - Parameter pattern: The haptic pattern to play.
    func playCustomPattern(pattern: GRHapticsPattern) {
        playCustomHaptics(events: pattern.events)
    }

    /// Plays a selection feedback.
    func playSelectionFeedback() {
        selectionGenerator.selectionChanged()
    }

    /// Plays an impact feedback with the given style.
    ///
    /// - Parameter style: The style of the impact feedback.
    func playImpactFeedback(style: ImpactGeneratorStyle) {
        switch style {
        case .light:
            impactGenerators.light.impactOccurred()

        case .medium:
            impactGenerators.medium.impactOccurred()

        case .heavy:
            impactGenerators.heavy.impactOccurred()
        }
    }

}

// MARK: - Private

private extension GRHapticsManager {

    /// Initializes the haptic engine and sets the `supportsHaptics` property based on whether the device supports haptic feedback.
    private func initHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
            supportsHaptics = true
        } catch {
            print("⚠️ Error starting haptic engine: \(error.localizedDescription)")
        }
    }

    /// Plays a custom haptic pattern using the `engine` property.
    private func playCustomHaptics(events: [CHHapticEvent]) {
        guard supportsHaptics else { return }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("⚠️ Failed to play pattern: \(error.localizedDescription).")
        }
    }

}
