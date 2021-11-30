//
//  HomeSearchViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/23.
//

import UIKit

class HomeSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField! // 검색창
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mainBlack
        
        
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(textFieldDidchange(textField:)), for: UIControl.Event.editingChanged)
        
        searchBar.returnKeyType = .search
        searchBarCustom()
        
//        // 검색창 애니메이션
//        UIView.animate(withDuration: 0.3, animations: ({
//            self.searchBar.transform = CGAffineTransform(translationX: 0, y: -94)
//        }))
        
    }
    
    func searchBarCustom(){
        searchBar.addLeftPadding()
        searchBar.tintColor = .mainYellow // 커서 색상 변경.
        searchBar.backgroundColor = .subBlack
        searchBar.attributedPlaceholder = NSAttributedString(string:"입력해주세요.", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1), NSAttributedString.Key.font :UIFont(name: "NotoSansKR-Regular", size: 14)!])
        searchBar.borderWidth = 2.5
        searchBar.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.borderColor = .mainYellow
        
        // https://zeddios.tistory.com/1291
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(imageLiteralResourceName: "magnifyingGlassYellow")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 30
        configuration.baseBackgroundColor = .subBlack
//        configuration.baseForegroundColor = .mainBlack
        
        let searchButton = UIButton(configuration: configuration, primaryAction: nil)
        searchButton.backgroundColor = .mainBlack
        searchBar.rightView = searchButton
        searchBar.rightViewMode = .always
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    // 뷰 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
//    @objc func searchFinish(_ sender: UIButton){
//        print("searchFinish() called")
//        infoSendButton.isEnabled = true
//        infoSendButton.layer.cornerRadius = 20
//        infoSendButton.layer.borderColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1).cgColor
//        infoSendButton.backgroundColor = UIColor.clear
//        infoSendButton.layer.borderWidth = 1
//        tableView.isHidden = false
//        searchState = 2
//        tableView.reloadData()
//    }

    
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension HomeSearchViewController: UITextFieldDelegate {
    
    @objc func textFieldDidchange(textField: UITextField){
        if textField.text!.count > 0 {
            print(textField.text)
        } else {
            print("입력 없는상태.")
        }
//        infoSendButton.isEnabled = true
//        infoSendButton.layer.cornerRadius = 20
//        infoSendButton.layer.borderColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1).cgColor
//        infoSendButton.layer.borderWidth = 1
//        infoSendButton.backgroundColor = UIColor.clear
//        tableView.isHidden = false
//        if textField.text?.count == 0 {
//            print("검색 중이 아닙니다")
//            searchState = 0
//            tableView.reloadData()
//        }else{
//            print("검색 중")
//            searchState = 1
//            tableView.reloadData()
//        }
    }
    
    // 키보드 Return(앤터) 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return 엔터 클릭")
//        searchState = 2
//        tableView.reloadData()
//        tableView.isHidden = true
//
//        noinfoLabel.text = "'\(textField.text!)' 맥주에 대한 정보가 없어요..!"
//        let attributedString = NSMutableAttributedString(string: noinfoLabel.text!)
//
//        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1), range: (noinfoLabel.text! as NSString).range(of:"'\(textField.text!)'"))
//
//        noinfoLabel.attributedText = attributedString
//
//
//        noinfoLabel.isHidden = false
//        infoSendButton.isHidden = false
        return true
    }
}
