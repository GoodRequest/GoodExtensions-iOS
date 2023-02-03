//
//  UIView.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import UIKit
import GRCompatible
import GoodStructs
import CoreGraphics

// MARK: - Initialization from XIB

public extension UIView {

    /// Loads a view from a nib file of the same name as the class.
    static func loadFromNib() -> Self {
        return GRActive.loadNib(self)
    }
    
}

public extension GRActive where Base: UIView {

    /// Loads a nib file from a specified bundle.
    ///
    /// - Parameters:
    ///   - owner: AnyObject that acts as an owner for the nib file.
    ///   - bundle: Bundle where the nib file is located. The default value is `Bundle.main`.
    /// - Returns: The view object of type `A` that is the top-level object in the nib file.
    /// - Throws:
    ///   - `fatalError` if the class name of the `Base` class has no components.
    ///   - `fatalError` if the nib file with the specified name doesn't exist.
    static func loadNib<A>(_ owner: AnyObject, bundle: Bundle = Bundle.main) -> A {
        guard let nibName = NSStringFromClass(Base.classForCoder()).components(separatedBy: ".").last else {
            fatalError("Class name [\(NSStringFromClass(Base.classForCoder()))] has no components.")
        }

        guard let nib = bundle.loadNibNamed(nibName, owner: owner, options: nil) else {
            fatalError("Nib with name [\(nibName)] doesn't exists.")
        }
        for item in nib {
            if let item = item as? A {
                return item
            }
        }
        // swiftlint:disable force_cast
        return nib.last as! A
        // swiftlint:enable force_cast
    }

    /// CGRect that represents the frame of the view without considering any transforms applied to it.
    var frameWithoutTransform: CGRect {
        let center = base.center
        let size   = base.bounds.size

        return CGRect(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }

}

// MARK: - Mask rendering

public extension GRActive where Base: UIView {

    @available(*, deprecated, message: "Deprecated, use circleMasked() instead")
    var circleMaskImage: UIView {
        base.clipsToBounds = true
        base.layer.cornerRadius = base.frame.width / 2.0
        return base
    }

    /// Applies a circular mask to the base view.
    ///
    /// - Returns: The base view with a circular mask applied.
    @discardableResult
    func circleMasked() -> UIView {
        base.clipsToBounds = true
        base.layer.cornerRadius = base.frame.width / 2.0
        return base
    }

}

// MARK: - UIView InspectableAttributes

public extension UIView {

    /// View corner radius. Don't forget to set clipsToBounds = true
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    /// View border color
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.black.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    /// View border width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// View's layer masks to bounds
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    /// View shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// View shadow color
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.black.cgColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }

    /// View shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    /// View shadow offset
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

}

// MARK: - UIView Animations

public extension GRActive where Base: UIView {

    /// Animates shake with view
    func shakeView(duration: CFTimeInterval = 0.02, repeatCount: Float = 8.0, offset: CGFloat = 5.0) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: base.center.x - offset, y: base.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: base.center.x + offset, y: base.center.y))
        base.layer.add(animation, forKey: "position")
    }

    enum Rotate {

        case by0
        case by90
        case by180
        case by270
        case custom(Double)

        var rotationValue: Double {
            switch self {
            case .by0:
                return 0.0

            case .by90:
                return .pi / 2

            case .by180:
                return .pi

            case .by270:
                return .pi + .pi / 2

            case .custom(let value):
                return value
            }
        }

    }

    /// Rotates the view by specified angle.
    func rotate(_ rotateBy: Rotate) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.5,
            options: .beginFromCurrentState,
            animations: { [weak base] in
                base?.transform = CGAffineTransform(rotationAngle: CGFloat(rotateBy.rotationValue))
            }
        )
    }

}

public extension GRActive where Base: UIView {

    enum ViewAnimationType {

        case identity
        case show
        case hide

    }

    /// Animates the changes to a UIView
    /// 
    /// - Parameters:
    ///   - duration: The duration of the animation, in seconds.
    ///   - afterDelay: The delay, in seconds, before the animation starts.
    ///   - dampingRatio: The damping ratio determines the amount of oscillation in the animation.
    ///   - animationCurve: The animation curve used to determine the timing of the animation.
    ///   - animationType: The type of animation to perform.
    /// - Returns: `UIViewPropertyAnimator` object.
    @discardableResult
    func animate(
        duration: TimeInterval,
        afterDelay: TimeInterval,
        dampingRatio: CGFloat? = nil,
        animationCurve: Base.AnimationCurve? = nil,
        animationType: ViewAnimationType
    ) -> UIViewPropertyAnimator {
        var animator = UIViewPropertyAnimator()

        if let dampingRatio = dampingRatio {
            animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio)
        } else if let animationCurve = animationCurve {
            animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve)
        }

        animator.addAnimations {
            switch animationType {
            case .identity:
                self.base.transform = .identity

            case .show:
                self.base.alpha = 1.0

            case .hide:
                self.base.alpha = 0.0
            }
        }

        animator.startAnimation(afterDelay: afterDelay)

        return animator
    }

}


// MARK: - Blurring

public extension GRActive where Base: UIView {
    
    private final class BlurredImageView: UIImageView, NameDescribable {}

    /// Adds a blurred image view to the base view.
    ///
    /// - Parameters:
    ///   - blurRadius: The blur radius of the image. Defaults to 3.5.
    ///   - animated: A flag indicating if the blur should be added animated. Defaults to false.
    ///   - duration: The duration of the animation in seconds. Defaults to 0.3.
    func blur(_ blurRadius: Double = 3.5, animated: Bool = false, duration: CGFloat = 0.3) {
        removeBlur()
        guard let blurredImage = createBlurryImage(blurRadius) else {
            return
        }

        let blurredImageView = BlurredImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor = .clear

        blurredImageView.alpha = 0
        
        base.addSubview(blurredImageView)
        
        NSLayoutConstraint.activate([
            blurredImageView.centerXAnchor.constraint(equalTo: base.centerXAnchor),
            blurredImageView.centerYAnchor.constraint(equalTo: base.centerYAnchor)
        ])

        if animated {
            UIView.animate(withDuration: duration) {
                blurredImageView.alpha = 1
            }
        } else {
            blurredImageView.alpha = 1
        }
    }

    /// Removes the blurred image view from the base view.
    ///
    /// - Parameters:
    ///   - animated: A flag indicating if the removal of the blur should be animated. Defaults to false.
    ///   - duration: The duration of the animation in seconds. Defaults to 0.3.
    func removeBlur(animated: Bool = false, duration: CGFloat = 0.3) {
        guard let blurredImageView = firstSubview(forType: BlurredImageView.self) else {
            return
        }

        if animated {
            UIView.animate(
                withDuration: duration,
                animations: {
                    blurredImageView.alpha = 0
                },
                completion: { _ in
                    blurredImageView.removeFromSuperview()
                }
            )
        } else {
            blurredImageView.alpha = 0
            blurredImageView.removeFromSuperview()
        }
    }

    /// Creates a blurry image from the current view
    ///
    /// - Parameter blurRadius: The radius of the blur effect
    /// - Returns: A blurred image if the creation is successful, otherwise nil.
    private func createBlurryImage(_ blurRadius: Double) -> UIImage? {
        UIGraphicsBeginImageContext(base.bounds.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        base.layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }

}

// MARK: - Layer

public extension GRActive where Base: UIView {

    /// Represents type of the gradient direction
    enum GradientDirection {

        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
        case custom(startPoint: CGPoint, endPoint: CGPoint, id: String? = nil)

        var id: String {
            switch self {
            case .bottomToTop:
                return "GRGradientLayer_BottomToTop"

            case .leftToRight:
                return "GRGradientLayer_LeftToRight"

            case .rightToLeft:
                return "GRGradientLayer_RightToLeft"

            case .topToBottom:
                return "GRGradientLayer_TopToBottom"

            case .custom(_, _, let id):
                let id = id ?? "Default"

                return "GRGradientLayer_\(id)"
            }
        }
    }

    /// Sets gradient layer in foreground
    /// - Parameters:
    ///   - colors: Array of colors used
    ///   - locations: location of colors
    ///   - direction: Direction of the gradient
    func setGradientLayerInForeground(colors: [UIColor], locations: [NSNumber] = [0, 1], direction: GradientDirection) {
        base.layer.sublayers?
            .filter { $0.name == direction.id }
            .forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = base.layer as? CAGradientLayer ?? CAGradientLayer().then {
            $0.name = direction.id
            $0.frame = base.bounds
            $0.colors = colors.map { $0.cgColor }
            $0.locations = locations
            $0.cornerRadius = base.cornerRadius

            switch direction {
            case .topToBottom:
                $0.startPoint = CGPoint(x: 0.0, y: 1.0)
                $0.endPoint = CGPoint(x: 1.0, y: 1.0)

            case .leftToRight:
                $0.startPoint = CGPoint(x: 0.0, y: 0.5)
                $0.endPoint = CGPoint(x: 1.0, y: 0.5)

            case .rightToLeft:
                $0.startPoint = CGPoint(x: 1.0, y: 0.5)
                $0.endPoint = CGPoint(x: 0.0, y: 0.5)

            case .bottomToTop:
                $0.startPoint = CGPoint(x: 0.5, y: 1.0)
                $0.endPoint = CGPoint(x: 0.5, y: 0.0)

            case .custom(let startPoint, let endPoint, _):
                $0.startPoint = startPoint
                $0.endPoint = endPoint
            }
        }
        base.layer.insertSublayer(gradientLayer, at: .zero)
    }

    /// Removes all gradient layers in foreground
    func removeAllGradientLayersInForeground() {
        base.layer.sublayers?
            .filter { $0.name?.contains("GRGradientLayer_") ?? false }
            .forEach { $0.removeFromSuperlayer() }
    }

    /// Updates gradient layer
    ///
    /// - Parameters:
    ///   - direction: Direction of the gradient
    ///   - colors: Array of colors used
    ///   - locations: Locations of colors
    func updateGradientLayer(direction: GradientDirection, colors: [UIColor], locations: [NSNumber] = [0, 1]) {
        let layer = base.layer.sublayers?
            .first { $0.name?.contains(direction.id) ?? false } as? CAGradientLayer
        
        layer?.colors = colors.map { $0.cgColor }
        layer?.locations = locations
    }


    /// Removes gradient with given direction
    ///
    /// - Parameter direction: Gradient direction
    func removeGradientLayerWithDirection(direction: GradientDirection) {
        base.layer.sublayers?
            .first { $0.name?.contains(direction.id) ?? false }?.removeFromSuperlayer()
    }

}

// MARK: - Dimming

public extension GRActive where Base: UIView {

    ///The DimView is a private class that represents a black view with an adjustable alpha value.
    ///The alpha value can be changed by calling the changeIntensity method and passing in the desired alpha value.
    private final class DimView: UIView {

        init(intensity alpha: CGFloat = 0.3) {
            super.init(frame: .zero)

            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .black.withAlphaComponent(alpha)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func changeIntensity(_ alpha: CGFloat) {
            backgroundColor = .black.withAlphaComponent(alpha)
        }

    }

    /// Adds a `DimView` to the base view and sets its constraints to occupy the entire base view
    ///
    /// - Parameters:
    ///   - alpha: intensity of the dim view, default: `0.3`
    ///   - animated: animated dimming, default: `false`
    ///   - duration: the duration of the animation, default: `0.3`
    func dim(intensity alpha: CGFloat = 0.3, animated: Bool = false, duration: CGFloat = 0.3) {
        removeDim()
        let dimView = DimView(intensity: 0)

        base.addSubview(dimView)
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: base.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: base.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: base.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: base.bottomAnchor)
        ])

        if animated {
            UIView.animate(withDuration: duration) {
                dimView.changeIntensity(alpha)
            }
        } else {
            dimView.changeIntensity(alpha)
        }
    }

    /// Removes the DimView from the base view
    ///
    /// - Parameters:
    ///   - animated: Removal can be animated, default is `false`
    ///   - duration: Animation duration, default is `0.3`
    func removeDim(animated: Bool = false, duration: CGFloat = 0.3) {
        let dimView = base.gr.firstSubview(forType: DimView.self)
        if animated {
            UIView.animate(
                withDuration: duration,
                animations: {
                    dimView?.changeIntensity(0)
                },
                completion: { _ in
                    dimView?.removeFromSuperview()
                }
            )
        } else {
            dimView?.changeIntensity(0)
            dimView?.removeFromSuperview()
        }
    }

}

// MARK: - Blurring

extension UIView {

    /// Creates a blurry image from the current view
    ///
    /// - Parameter blurRadius: The radius of the blur effect
    /// - Returns: A blurred image if the creation is successful, otherwise nil.
    func createBlurryImage(_ blurRadius: Double) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: currentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()

            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }

}

// MARK: - Subview search

public extension GRActive where Base: UIView {

    /// Returns the first subview of a given type T
    ///
    /// - Parameter type: The type of the subview being searched for
    /// - Returns: The first subview of the specified type T if found, otherwise nil
    func firstSubview<T>(forType type: T.Type) -> T? {
        for subview in base.subviews where subview is T {
            return subview as? T
        }

        var searchedView: T?
        for subview in base.subviews {
            searchedView = subview.gr.firstSubview(forType: type)
        }
        return searchedView
    }

}
