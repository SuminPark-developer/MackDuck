//
//  TripleDotPopupViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/02/06.
//

import UIKit

class TripleDotPopupViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - 여기 뷰컨트롤러는 AllReview뿐만 아니라 IntroReview도 같이 쓰는 신고하기 버튼 팝업임.
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(AllReviewReportPopupViewController.tapBackground)) // 밖 클릭 시 뒤로가기(dismiss).
        backgroundView.addGestureRecognizer(tapBackground)
    }
    
    @objc func tapBackground(sender: UITapGestureRecognizer) { // 밖 클릭 시 뒤로가기(dismiss).
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
