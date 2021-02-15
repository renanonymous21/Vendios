//
//  UIAlertExtension.swift
//  vendios
//
//  Created by Rendy K.R on 24/12/20.
//

import UIKit

extension UIAlertController {
    func show(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let visibleViewController = UIApplication.shared.windows.first?.visibleViewController {
            visibleViewController.present(self, animated: animated, completion: completion)
        }
    }
    
}

extension UIWindow {
    
    var visibleViewController: UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        return visibleViewController(for: rootViewController)
    }
    
    private func visibleViewController(for controller: UIViewController) -> UIViewController {
        var nextViewController: UIViewController? = nil
        if let presented = controller.presentedViewController {
            nextViewController = presented
        } else if let navigationController = controller as? UINavigationController,
                  let visible = navigationController.visibleViewController {
            nextViewController = visible
        } else if let tabBarController = controller as? UITabBarController,
                  let visible = (tabBarController.selectedViewController ??
                                    tabBarController.presentedViewController) {
            nextViewController = visible
        }
        
        if let nextOnStackViewController = nextViewController {
            return visibleViewController(for: nextOnStackViewController)
        } else {
            return controller
        }
    }
    
}
