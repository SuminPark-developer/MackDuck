//
//  PrivacySettingViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/17.
//

import UIKit

class PrivacySettingViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var sexBtn1: UIButton!
    @IBOutlet weak var sexBtn2: UIButton!
    
    @IBOutlet weak var ageBtn1: UIButton!
    @IBOutlet weak var ageBtn2: UIButton!
    @IBOutlet weak var ageBtn3: UIButton!
    @IBOutlet weak var ageBtn4: UIButton!
    @IBOutlet weak var ageBtn5: UIButton!
    @IBOutlet weak var ageBtn6: UIButton!
    
    @IBOutlet weak var tasteBtn1: UIButton!
    @IBOutlet weak var tasteBtn2: UIButton!
    @IBOutlet weak var tasteBtn3: UIButton!
    @IBOutlet weak var tasteBtn4: UIButton!
    @IBOutlet weak var tasteBtn5: UIButton!
    @IBOutlet weak var tasteBtn6: UIButton!
    @IBOutlet weak var tasteBtn7: UIButton!
    @IBOutlet weak var tasteBtn8: UIButton!
    
    var sexBtnArray = [UIButton]()
    var ageBtnArray = [UIButton]()
    var tasteBtnArray = [UIButton]()
    
    var kakaoID: Int = 0
    var nickName: String = ""
    var sexBtn: String = ""
    var ageBtn: String = ""
    var beerTasteBtn: Int = 0
    
    var tasteDict = ["라거": 1,"필스너": 2,"둔켈": 3,"에일": 4,"IPA": 5,"밀맥주": 6,"스타우트": 7,"포터": 8]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        
        mainTitle.text = "개인 정보를\n선택하면 끝!"
        mainTitle.textColor = .mainWhite
        
        navigationBar.barTintColor = .mainBlack
        navigationBar?.isTranslucent = false // 네비게이션바 반투명 제거
        
        signUpButton.isUserInteractionEnabled = false // 가입완료 버튼 비활성화.
        signUpButton.layer.cornerRadius = 10
        
        sexBtnArray.append(sexBtn1)
        sexBtnArray.append(sexBtn2)
        
        ageBtnArray.append(ageBtn1)
        ageBtnArray.append(ageBtn2)
        ageBtnArray.append(ageBtn3)
        ageBtnArray.append(ageBtn4)
        ageBtnArray.append(ageBtn5)
        ageBtnArray.append(ageBtn6)
        
        tasteBtnArray.append(tasteBtn1)
        tasteBtnArray.append(tasteBtn2)
        tasteBtnArray.append(tasteBtn3)
        tasteBtnArray.append(tasteBtn4)
        tasteBtnArray.append(tasteBtn5)
        tasteBtnArray.append(tasteBtn6)
        tasteBtnArray.append(tasteBtn7)
        tasteBtnArray.append(tasteBtn8)
        
        
    }
    
    // 선택 풀릴 때,
    func unselectedButtonCustom(btn: UIButton){
        btn.layer.cornerRadius = 15
        btn.layer.borderColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 136/255).cgColor
        btn.layer.borderWidth = 1
        btn.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
//        btn.setTitleColor(.mainGray, for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 13)

    }
    
    // 성별
    @IBAction func selectedSexOptionBtnAction(_ sender: UIButton){
        for Btn in sexBtnArray {
            if Btn == sender {
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1)
                Btn.titleLabel!.font = UIFont(name: "NotoSansKR-Bold", size: 13)
                print(Btn.titleLabel!.text!)
                sexBtn = Btn.titleLabel!.text!
            } else {
                Btn.isSelected = false
                unselectedButtonCustom(btn: Btn)
            }
        }
    }
    
    // 나이
    @IBAction func selectedAgeOptionBtnAction(_ sender: UIButton){
        for Btn in ageBtnArray {
            if Btn == sender {
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1)
                Btn.titleLabel!.font = UIFont(name: "NotoSansKR-Bold", size: 13)
                print(Btn.titleLabel!.text!)
                ageBtn = Btn.titleLabel!.text!
            } else {
                Btn.isSelected = false
                unselectedButtonCustom(btn: Btn)
            }
        }
    }
    
    // 취향
    @IBAction func selectedTasteOptionBtnAction(_ sender: UIButton){
        for Btn in tasteBtnArray {
            if Btn == sender {
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1)
                Btn.titleLabel!.font = UIFont(name: "NotoSansKR-Bold", size: 13)
                print(tasteDict["\(Btn.titleLabel!.text ?? "")"]!)
                beerTasteBtn = tasteDict["\(Btn.titleLabel!.text ?? "")"]!
            } else {
                Btn.isSelected = false
                unselectedButtonCustom(btn: Btn)
            }
        }
    }

    
    @IBAction func didTabBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
