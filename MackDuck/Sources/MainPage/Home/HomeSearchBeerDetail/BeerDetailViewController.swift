//
//  BeerDetailViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/05.
//

import UIKit

class BeerDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clickHomeButton(_ sender: UIBarButtonItem) { // 홈 버튼 클릭 시,
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func clickSearchButton(_ sender: UIBarButtonItem) { // 검색 버튼 클릭 시,
        self.navigationController?.popViewController(animated: true)
    }
    
}
