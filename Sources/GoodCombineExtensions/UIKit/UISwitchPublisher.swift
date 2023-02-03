//
//  UISwitchCombineExtension.swift
//  
//
//  Created by Andrej Jasso on 11/03/2022.
//

import Combine
import GRCompatible
import UIKit

public extension GRActive where Base: UISwitch {

    /// A publisher for the isOn property of a UIControl instance.
    var isOnPublisher: AnyPublisher<Bool, Never> {
        Publishers.ControlProperty(control: base, events: .valueChanged, keyPath: \.isOn)
            .eraseToAnyPublisher()
    }

}
