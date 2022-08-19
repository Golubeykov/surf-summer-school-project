//
//  ButtonActivityIndicator.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 19.08.2022.
//

import Foundation
import UIKit

struct ButtonActivityIndicator {
    var button: UIButton
    let originalButtonText: String
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showButtonLoading() {
        configureActivityIndicator()
        button.setTitle("", for: .normal)
        
        showSpinning()
    }
    
    func hideButtonLoading() {
        button.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
    private func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        button.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        button.addConstraint(yCenterConstraint)
    }
}
