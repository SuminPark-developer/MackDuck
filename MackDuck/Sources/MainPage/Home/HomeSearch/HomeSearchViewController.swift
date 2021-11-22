//
//  HomeSearchViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/23.
//

import UIKit

class HomeSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
