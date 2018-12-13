//
//  AlertView.swift
//  PopularRepositories
//
//  Created by Syed Haris Hussain on 13/12/2018.
//  Copyright © 2018 UMI Urban Mobility International GmbH. All rights reserved.
//

import UIKit

class AlertView {
    
    let alert: UIAlertController
    let presentingController: UIViewController
    
    init(presentingController: UIViewController,
         title: String,
         message: String,
         primaryActionTitle: String = "OK",
         secondaryActionTitle: String? = nil,
         primaryAction: ((UIAlertAction) -> Void)? = nil,
         secondaryAction: ((UIAlertAction) -> Void)? = nil) {
        
        self.presentingController = presentingController
        
        self.alert = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
        
        self.alert.addAction(UIAlertAction(title: primaryActionTitle,
                                           style: .default,
                                           handler: primaryAction))
        
        if let _secondaryActionTitle = secondaryActionTitle {
            
            self.alert.addAction(UIAlertAction(title: _secondaryActionTitle,
                                               style: .cancel,
                                               handler: secondaryAction))
        }
    }
    
    func show(completion: (() -> Void)? = nil) {
        self.presentingController
            .present(alert,
                     animated: true,
                     completion: completion)
    }
}
