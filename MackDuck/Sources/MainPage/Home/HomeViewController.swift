//
//  HomeViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var tabBar: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        
        mainTitle.text = "맥주 이름이\n무엇인가요?"
        mainTitle.textColor = .mainWhite
        
        
        
        //텍스트 필드 돋보기 표시
//        let magnifyingGlassButton = UIButton()
//        let image = UIImage(named: "mainSearchIcon")
//        magnifyingGlassButton.setBackgroundImage(image, for: .normal)
//        magnifyingGlassButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
//        searchTF.rightView = magnifyingGlassButton
//        searchTF.rightViewMode = UITextField.ViewMode.always
        
        
    }
    
    
    

//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.searchTF.resignFirstResponder()
//    }
    

}

