//
//  SettingViewController.swift
//  iArticle
//
//  Created by Mavin on 13/10/21.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 15.0, *) {
            if let presentationController = presentationController as? UISheetPresentationController {
                presentationController.detents = [
                    .medium(),
                    .large()
                ]
                presentationController.prefersGrabberVisible = true
            }
        } else {
            // Fallback on earlier versions
        }
    }
    


}
