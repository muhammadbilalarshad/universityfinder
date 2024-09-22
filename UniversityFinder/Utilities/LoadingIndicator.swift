//
//  LoadingIndicator.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import Foundation
import UIKit

class LoadingIndicator {
    private var containerView: UIView = UIView()
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    static let shared = LoadingIndicator()
    
    private init() {
        
    }
    
    func showLoading(on view: UIView) {
        DispatchQueue.main.async {
            self.containerView.frame = view.bounds
            self.containerView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            
            self.activityIndicator.center = self.containerView.center
            self.activityIndicator.startAnimating()
            
            self.containerView.addSubview(self.activityIndicator)
            view.addSubview(self.containerView)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.containerView.removeFromSuperview()
        }
    }
}
