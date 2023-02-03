//
//  UIStoryboard.swift
//  GoodExtensions
//
//  Created by Andrej Jasso on 29/09/2021.
//

import UIKit
import GRCompatible

public extension GRActive where Base: UIStoryboard {

    /// instantiates an UIViewController with given class
    /// 
    /// - Parameter clas: Class of the `UIViewController`
    /// - Returns: `UIViewController`
    func instantiateViewController<T: UIViewController>(withClass clas: T.Type) -> T? {
        return base.instantiateViewController(withIdentifier: String(describing: clas)) as? T
    }

}
