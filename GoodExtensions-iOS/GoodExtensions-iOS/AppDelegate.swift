//
//  AppDelegate.swift
//  GoodUIKit-Sample
//
//  Created by Andrej Jasso on 02/03/2023.
//

import UIKit
import Combine
import GoodExtensions
import GoodStructs
import GoodCombineExtensions

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pushButton: UIButton?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        window.backgroundColor = .white
        let controller = UIViewController()
        controller.view.backgroundColor = .green.withAlphaComponent(0.2)
        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let pushButton = UIButton(frame: CGRect(x: 50, y: 200, width: 200, height: 50))
        self.pushButton = pushButton
        pushButton.backgroundColor = .cyan.withAlphaComponent(0.5)
        pushButton.setTitle("Click to push", for: .normal)
        controller.view.addSubview(pushButton)

        pushButton.addTarget(self, action: #selector(self.haptic), for: .touchUpInside)

        return true
    }

    @objc
    func haptic() {
        GRHapticsManager.shared.playNotificationFeedback(.success)
        UIView.animate(withDuration: 0.5, delay: 0.0,
        animations: {
            self.pushButton?.transform = .identity.scaledBy(x: 0.9, y: 0.9)
        }, completion: { _ in
            self.pushButton?.transform = .identity
        })
    }

}

