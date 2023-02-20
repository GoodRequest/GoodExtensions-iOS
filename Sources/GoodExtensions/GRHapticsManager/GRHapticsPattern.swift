//
//  GRHapticsPattern.swift
//  
//
//  Created by Marek Vrican on 20/02/2023.
//  Copyright © GoodRequest s.r.o. All rights reserved.

import CoreHaptics

/// A protocol for defining a custom haptic pattern.
///
///     enum HapticsPattern: GRHapticsPattern {
///
///         case sos
///
///         var events: [CHHapticEvent] {
///         switch self {
///         case .sos:
///             return [
///                 CHHapticEvent (eventType: .hapticTransient, parameters: [], relativeTime: 0),
///                 CHHapticEvent (eventType: .hapticTransient, parameters: [], relativeTime: 0.2),
///                 CHHapticEvent (eventType: .hapticTransient, parameters: [], relativeTime: 0.4),
///                 CHHapticEvent (eventType: .hapticContinuous, parameters: [], relativeTime: 0.6, duration: 0.5),
///                 CHHapticEvent (eventType: .hapticContinuous, parameters: [], relativeTime: 1.2, duration: 0.5),
///                 CHHapticEvent (eventType: .hapticContinuous, parameters: [], relativeTime: 1.8, duration: 0.5),
///                 CHHapticEvent (eventType: .hapticTransient, parameters: [], relativeTime: 2.4),
///                 CHHapticEvent (eventType: .hapticTransient, parameters: [], relativeTime: 2.6),
///                 CHHapticEvent (eventType: .hapticTransient, parameters: [], relativeTime: 2.8),
///                 ]
///             }
///         }
///     }
public protocol GRHapticsPattern {

    /// An array of CHHapticEvent objects that defines the custom haptic pattern.
    var events: [CHHapticEvent] { get }

}
