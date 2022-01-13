//
//  BeerDetailTasteViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/11.
//

import UIKit

class BeerDetailTasteViewController: UIViewController {

    var beerDetailTasteDataManager: BeerDetailTasteDataManager = BeerDetailTasteDataManager() // 맥주 맛/향 정보 가져오는 dataManager
    // MARK: - 맛 Label들
    @IBOutlet var balanceLabelList: [UILabel]! // 밸런스 라벨들
    @IBOutlet var weightLabelList: [UILabel]! // 무게감 라벨들
    @IBOutlet var carbonationLabelList: [UILabel]! // 탄산감 라벨들
    // MARK: - 향 Label들
    @IBOutlet var fruitLabelList: [UILabel]! // 과일향 라벨들
    @IBOutlet var etcLabelList: [UILabel]! // 그 외 라벨들
    @IBOutlet var maltLabelList: [UILabel]! // 맥아 라벨들
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beerDetailTasteDataManager.getBeerTasteSmellInfo(beerId: BeerData.details.beerId, delegate: self) // 맥주 맛/향 가져오는 api 호출.
    }

    // 선택 풀릴 때,
    func changeLabelBackground(label: UILabel){
        label.clipsToBounds = true
        label.layer.cornerRadius = 13
        label.layer.borderColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1).cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1)
        label.font = UIFont(name:"NotoSansKR-Bold", size: 12.0)
        label.textColor = .mainBlack
    }
    
}



// MARK: - 맥주정보 맛/향 GET Api
extension BeerDetailTasteViewController {
    
    // beerId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 맥주 맛/향 설정.
    func didSuccessGetBeerTasteSmellInfo(_ result: BeerDetailTasteResponse) {
        print("서버로부터 맥주 맛/향 GET 성공!")
        print("response 내용 : \(result)")
        
        
        print(result.result.favorList)
        
        // 맥주 정보 - 맛 ui 작업
        for favor in result.result.favorList {
            
            // 맛 - 밸런스 ui 작업
            for balanceLabel in balanceLabelList { // 밸런스 라벨 중,
                if favor.favor == balanceLabel.text! { // 서버에서 가져온 맛(밸런스) 내용과 일치한다면,
                    changeLabelBackground(label: balanceLabel) // balanceLabel 뒷배경 노랑색으로 변경.
                }
            }
            
            // 맛 - 무게감 ui 작업
            for weightLabel in weightLabelList { // 무게감 라벨 중,
                if favor.favor == weightLabel.text! { // 서버에서 가져온 맛(무게감) 내용과 일치한다면,
                    changeLabelBackground(label: weightLabel) // weightLabel 뒷배경 노랑색으로 변경.
                }
            }
            
            // 맛 - 탄산감 ui 작업
            for carbonationLabel in carbonationLabelList { // 탄산감 라벨 중,
                if favor.favor == carbonationLabel.text! { // 서버에서 가져온 맛(탄산감) 내용과 일치한다면,
                    changeLabelBackground(label: carbonationLabel) // carbonationLabel 뒷배경 노랑색으로 변경.
                }
            }
            
        }

        print(result.result.smellList)
        // 맥주 정보 - 향 ui 작업
        for favor in result.result.smellList {
            
            // 향 - 과일향 ui 작업
            for fruitLabel in fruitLabelList { // 과일향 라벨 중,
                if favor.smell == fruitLabel.text! { // 서버에서 가져온 향(과일향) 내용과 일치한다면,
                    changeLabelBackground(label: fruitLabel) // fruitLabel 뒷배경 노랑색으로 변경.
                }
            }
            
            // 향 - 그 외 ui 작업
            for etcLabel in etcLabelList { // 그 외 라벨 중,
                if favor.smell == etcLabel.text! { // 서버에서 가져온 향(그 외) 내용과 일치한다면,
                    changeLabelBackground(label: etcLabel) // etcLabel 뒷배경 노랑색으로 변경.
                }
            }

            // 향 - 맥아 ui 작업
            for maltLabel in maltLabelList { // 맥아 라벨 중,
                if favor.smell == maltLabel.text! { // 서버에서 가져온 향(맥아) 내용과 일치한다면,
                    changeLabelBackground(label: maltLabel) // maltLabel 뒷배경 노랑색으로 변경.
                }
            }
            
        }
        
        
        
    }

    func failedToGetBeerTasteSmellInfo(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 2016 { // 실패 이유 : "맥주 beerId 값 확인해주세요."
            
        }
    }
    
}

