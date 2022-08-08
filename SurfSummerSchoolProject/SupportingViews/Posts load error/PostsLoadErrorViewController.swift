//
//  PostsLoadErrorViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 08.08.2022.
//

import UIKit

class PostsLoadErrorViewController: UIViewController {

    var refreshButtonAction: ()->Void = {}
    
    @IBAction func refreshButton(_ sender: Any) {
        refreshButtonAction()
        self.view.alpha = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
