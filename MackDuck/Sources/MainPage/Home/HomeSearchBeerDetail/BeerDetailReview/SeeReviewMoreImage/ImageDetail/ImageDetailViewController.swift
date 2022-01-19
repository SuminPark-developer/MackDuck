//
//  ImageDetailViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/18.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var navTitle: String = ""
    var imageUrlString: String = ""
    
    @IBOutlet weak var navigationBarItem: UINavigationItem! // 상단 네비게이션바 아이템
    @IBOutlet weak var detailImageView: UIImageView! // 중상단 큰 이미지뷰
    @IBOutlet weak var goReviewButton: UIButton! // 리뷰 보러가기 버튼
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarItem.title = navTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.mainWhite]

        self.view.backgroundColor = .mainBlack
        self.navigationController?.navigationBar.backgroundColor = .mainBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .mainBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // 이미지 ui 작업함.
        super.viewWillAppear(animated)
        
        let url = URL(string: imageUrlString)
        // DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        DispatchQueue.global(qos: .background).async { // DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.detailImageView.image = UIImage(data: data!) // 만약 url이 없다면(안 들어온다면) try-catch로 확인해줘야 함.
                self.detailImageView.contentMode = .scaleAspectFit
            }
        }
    }

    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clickGoReviewButton(_ sender: UIButton) { // 리뷰 보러가기 버튼 클릭시,
        print("리뷰 보러가기 버튼 클릭됨.")
        // TODO: - 리뷰 보러가기 페이지 연동 및 api 필요.
    }
    
    

}
