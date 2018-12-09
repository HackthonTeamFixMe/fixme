//
//  Extensions.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

extension UIViewController {
    
    //Add animation to dimView
    func addAnimationToDimView(duration: CGFloat, animationStyle: UIView.AnimationOptions, view: UIView, isHidding: Bool) {
        if isHidding {
            UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: animationStyle, animations: {
                view.alpha = 0
            }) { (success) in
                view.isHidden = true
                view.removeFromSuperview()
            }
        } else {
            view.alpha = 0
            view.isHidden = false
            UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: animationStyle, animations: {
                view.alpha = 0.7
            }) { (success) in
                
            }
        }
    }
    
    //To Show the Alert/Error/Success
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //To show activityIndicator
    func showActivityIndicator(view: UIView) -> DGActivityIndicatorView {
        let activityIndicator = DGActivityIndicatorView(type: .ballClipRotate, tintColor: .white, size: 40)
        activityIndicator?.alpha = 0.699999988079071
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator!)
        activityIndicator?.backgroundColor = UIColor.black
        activityIndicator?.layer.cornerRadius = 5
        activityIndicator?.center = view.center
        activityIndicator?.startAnimating()
        return activityIndicator!
    }
}

extension DGActivityIndicatorView {
    func dismissLoader() {
        self.stopAnimating()
    }
}

