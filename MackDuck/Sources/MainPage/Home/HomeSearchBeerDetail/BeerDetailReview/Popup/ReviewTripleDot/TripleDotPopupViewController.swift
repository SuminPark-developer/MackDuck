//
//  TripleDotPopupViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/02/06.
//

import UIKit

class TripleDotPopupViewController: UIViewController {
    var reviewTripleDotDeleteButtonDataManager: ReviewTripleDotDeleteButtonDataManager = ReviewTripleDotDeleteButtonDataManager() // 리뷰 점3개 버튼 - 수정or삭제 정보 보내는 dataManager
    var reviewId: Int = 0
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var modifyButton: UIButton! // 수정하기 버튼
    @IBOutlet weak var deleteButton: UIButton! // 삭제하기 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - 여기 뷰컨트롤러는 AllReview뿐만 아니라 IntroReview도 같이 쓰는 신고하기 버튼 팝업임.
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(AllReviewReportPopupViewController.tapBackground)) // 밖 클릭 시 뒤로가기.
        backgroundView.addGestureRecognizer(tapBackground)
        
        // 버튼 일부 코너 Round 처리 : https://swieeft.github.io/2020/03/05/UIViewRoundCorners.html
        modifyButton.clipsToBounds = true
        modifyButton.layer.cornerRadius = 15
        modifyButton.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner) // 수정하기버튼 - 상단 모서리만 둥글게.
        
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 15
        deleteButton.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner) // 삭제하기버튼 - 하단 모서리만 둥글게.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func tapBackground(sender: UITapGestureRecognizer) { // 밖 클릭 시 뒤로가기(dismiss).
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func clickModifyButton(_ sender: UIButton) { // 수정하기 버튼 클릭 시,
        // TODO: - 리뷰 수정하기 페이지 연결 필요.
        print("리뷰 수정하기 버튼 클릭 - 리뷰 수정하기 페이지 연결 작업 필요.")
    }
    
    @IBAction func clickDeleteButton(_ sender: UIButton) { // 삭제하기 버튼 클릭 시,
        print("삭제하기 버튼 클릭.")
        
        let text: String = "리뷰를 삭제할까요?"
        let attributeString = NSMutableAttributedString(string: text) // 텍스트 일부분 색상, 폰트 변경 - https://icksw.tistory.com/152
        let font = UIFont(name: "NotoSansKR-Medium", size: 17)
        attributeString.addAttribute(.font, value: font!, range: (text as NSString).range(of: "\(text)")) // 폰트 적용.
        attributeString.addAttribute(.foregroundColor, value: UIColor.mainWhite, range: (text as NSString).range(of: "\(text)")) // 색상 화이트 변경.
        
        let alertController = UIAlertController(title: text, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.setValue(attributeString, forKey: "attributedTitle") // 폰트 및 색상 적용.
        
        let reviewDelete = UIAlertAction(title: "리뷰 삭제", style: .cancel, handler: {
            action in
            print("리뷰 삭제 버튼 클릭함.")
            let userId = UserDefaults.standard.integer(forKey: "userId") // UserDefaults에서 userId값 불러옴.
            self.reviewTripleDotDeleteButtonDataManager.postReviewDelete(userId: userId, reviewId: self.reviewId, delegate: self) // 삭제 api 호출.
        })
        let cancle = UIAlertAction(title: "아니요", style: .default, handler: nil)
        
        reviewDelete.setValue(UIColor.mainYellow, forKey: "titleTextColor") // 색상 적용.
        cancle.setValue(UIColor.mainYellow, forKey: "titleTextColor") // 색상 적용.
        
        alertController.addAction(reviewDelete)
        alertController.addAction(cancle)
        
        // 배경색 변경
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .subBlack3
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func clickBackButton(_ sender: UIButton) { // 취소 버튼 클릭 시,
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: false)
    }

}

// MARK: - 리뷰cell : 리뷰 삭제 PATCH Api
extension TripleDotPopupViewController {
    
    // MARK: - 리뷰 삭제 PATCH 성공할 때,
    func didSuccessDeleteReview(_ result: ReviewTripleDotDeleteButtonResponse) { // userId, reviewId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 리뷰 ui 작업.
        print("리뷰cell : 리뷰 삭제 PATCH 성공!")
        print("response 내용 : \(result)")
        
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: false)
        
    }

    // MARK: - 리뷰 삭제 PATCH 실패할 때,
    func failedToDeleteReview(message: String, code: Int) { // 신고 정보 POST 실패할 때
        print("리뷰cell : 리뷰 삭제 PATCH 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")

        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 2016 { // 실패 이유 : "유저 아이디값을 확인해주세요."
            
        }
        else if code == 2033 { // 실패 이유 : "reportIndex를 입력해주세요."
            
        }
        else if code == 3018 { // 실패 이유 : "삭제할 리뷰가 존재하지 않습니다."
            
        }
    }
    
}
