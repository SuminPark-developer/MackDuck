//
//  AllReviewReportPopupViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/02/04.
//

import UIKit

class AllReviewReportPopupViewController: UIViewController {
    var allReviewReportButtonDataManager: AllReviewReportButtonDataManager = AllReviewReportButtonDataManager() // 모든 리뷰 - 신고 리뷰 정보 보내는 dataManager
    var reviewId: Int = 0
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var reportButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 여기 뷰컨트롤러는 AllReview뿐만 아니라 IntroReview도 같이 쓰는 신고하기 버튼 팝업임.
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(AllReviewReportPopupViewController.tapBackground)) // 밖 클릭 시 뒤로가기(dismiss).
        backgroundView.addGestureRecognizer(tapBackground)
        
    }
    
    @objc func tapBackground(sender: UITapGestureRecognizer) { // 밖 클릭 시 뒤로가기(dismiss).
        self.dismiss(animated: true, completion: nil)
    }
    
    // 하나의 func에 버튼 여러개 연결 방법 -  https://stackoverflow.com/questions/37870701/how-to-use-one-ibaction-for-multiple-buttons-in-swift
    @IBAction func clickReportButtons(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }

        let userId = UserDefaults.standard.integer(forKey: "userId") // UserDefaults에서 userId값 불러옴.
        var input: AllReviewReportButtonRequest? // parameters
        
        switch button.tag {
        case 1: // (1) : 광고, 홍보 / 거래 시도
            input = AllReviewReportButtonRequest(reportIndex: 1)
        case 2: // (2) : 과도한 오타, 반복적 표현 사용
            input = AllReviewReportButtonRequest(reportIndex: 2)
        case 3: // (3) : 욕설, 음란어 사용
            input = AllReviewReportButtonRequest(reportIndex: 3)
        case 4: // (4) : 리뷰 내용과 다른 제품 선택
            input = AllReviewReportButtonRequest(reportIndex: 4)
        case 5: // (5) : 리뷰 내용과 무관한 사진 첨부
            input = AllReviewReportButtonRequest(reportIndex: 5)
        case 6: // (6) : 개인 정보 노출
            input = AllReviewReportButtonRequest(reportIndex: 6)
        case 7: // (7) : 명예훼손 / 저작권 침해
            input = AllReviewReportButtonRequest(reportIndex: 7)
        case 8: // (8) : 기타(에티켓 위반 등)
            input = AllReviewReportButtonRequest(reportIndex: 8)
        default:
            print("Unknown 버튼")
            return
        }
        self.allReviewReportButtonDataManager.postAllReviewReport(userId: userId, reviewId: reviewId, parameters: input!, delegate: self) // 모든 리뷰 - 신고 정보 보내는 api 호출.
    }
    

}

// MARK: - 모든 리뷰 : 신고 정보 POST Api
extension AllReviewReportPopupViewController {
    
    // MARK: - 신고 정보 POST 성공할 때,
    func didSuccessPostAllReviewReport(_ result: AllReviewReportButtonResponse) { // userId, reviewId, reportIndex가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 리뷰 ui 작업.
        print("모든 리뷰 : 신고리뷰 서버에 POST 성공!")
        print("response 내용 : \(result)")
        
        // 맥덕 운영진에게 신고가 접수되었어요! alert 창 띄움.
        let text: String = "맥덕 운영진에게 신고가 접수되었어요!"
        let attributeString = NSMutableAttributedString(string: text) // 텍스트 일부분 색상, 폰트 변경 - https://icksw.tistory.com/152
        let font = UIFont(name: "NotoSansKR-Medium", size: 16)
        attributeString.addAttribute(.font, value: font!, range: (text as NSString).range(of: "\(text)")) // 폰트 적용.
        attributeString.addAttribute(.foregroundColor, value: UIColor.mainWhite, range: (text as NSString).range(of: "\(text)")) // 색상 화이트 변경.
        
        let alertController = UIAlertController(title: text, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.setValue(attributeString, forKey: "attributedTitle") // 폰트 및 색상 적용.
        
        let ok = UIAlertAction(title: "확인", style: .cancel, handler: { // 확인버튼 클릭 시,
            action in
            self.dismiss(animated: true, completion: nil) // 뒤로가기.
        })
        ok.setValue(UIColor.mainYellow, forKey: "titleTextColor") // 색상 적용.
        alertController.addAction(ok)
        
        // 배경색 변경
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .subBlack3
        
        present(alertController, animated: true, completion: nil)
        
    }

    // MARK: - 신고 정보 POST 실패할 때,
    func failedToPostAllReviewReport(message: String, code: Int) { // 신고 정보 POST 실패할 때
        print("신고 정보 POST 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")

        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 2016 { // 실패 이유 : "유저 아이디값을 확인해주세요."
            
        }
        else if code == 2033 { // 실패 이유 : "reportIndex를 입력해주세요."
            
        }
        else if code == 3023 { // 실패 이유 : "신고할 리뷰가 존재하지 않습니다."
            
        }
    }
    
}
