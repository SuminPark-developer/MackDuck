//
//  BeerDetailReviewViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/11.
//

import UIKit
import Charts

class BeerDetailReviewViewController: UIViewController {

    var beerDetailReviewDataManager: BeerDetailReviewDataManager = BeerDetailReviewDataManager() // 맥주 리뷰 정보(6개) 가져오는 dataManager
    
    @IBOutlet weak var noReviewLabel: UILabel! // 아직 작성된 리뷰가 없어요 ㅠㅠ
    @IBOutlet weak var noReviewButton: UIButton! // 이 맥주를 마셔보셨다면 영광의 첫 리뷰를....
    
    @IBOutlet weak var reviewStaticsBackground: UIView! // 리뷰 요약본 배경.
    @IBOutlet weak var reviewScore: UILabel! // 총 평점( ex - 0.0)
    @IBOutlet var starImages: [UIImageView]! // 별 이미지들
    
    @IBOutlet weak var allImageStackView: UIStackView! // 리뷰 요악본 밑에 있는 스택뷰.
    @IBOutlet var allImageViews: [UIImageView]! // 리뷰 요약본 밑에 있는 스택뷰 안에 담긴 이미지뷰(4개).
    @IBOutlet weak var seeMoreImageButton: UIButton! // 더보기 버튼.
    @IBOutlet weak var seeMoreImageLabel: UILabel! // 더보기 라벨.
    @IBOutlet weak var introReviewTableView: UITableView! // 리뷰(6개) 테이블뷰
//    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var scorePoints: [String] = ["5점", "4점", "3점", "2점", "1점"]
    var reviewCount: [Int] = [0, 0, 0, 0, 0]
    
    var introReviewList: [IntroReviewModel] = [] // 리뷰(6개) 데이터(모델)들
    
    @IBOutlet weak var reviewCountLabel: UILabel! // 리뷰 개수 라벨.
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noReviewLabel.isHidden = true // 리뷰 없을 때 쓰이는 것 숨겨 놓음.
        noReviewButton.isHidden = true // 리뷰 없을 때 쓰이는 것 숨겨 놓음.
        noReviewButton.isUserInteractionEnabled = false // 리뷰 없을 때 쓰이는 것 숨겨 놓음.
        
        barChartView.noDataText = "아직 작성된 리뷰가 없어요ㅠㅠ"
        barChartView.noDataFont = UIFont(name: "NotoSansKR-Bold", size: 24)!
        barChartView.noDataTextColor = .mainGray
        
        introReviewTableView.rowHeight = UITableView.automaticDimension
        
        introReviewTableView.delegate = self
        introReviewTableView.dataSource = self
        
//        introReviewTableView.separatorStyle = .none // 리뷰테이블뷰 밑줄 없애기
        
//        introReviewTableView.register(IntroReviewTableViewCell.nib(), forCellReuseIdentifier: IntroReviewTableViewCell.identifier) // 리뷰테이블뷰 cell 등록.
        
//        self.tableViewHeight.constant = self.introReviewTableView.contentSize.height
//        print("#############\(self.introReviewTableView.contentSize)")
//        self.tableViewHeight.constant = 1200
//        self.tableViewHeight.constant = CGFloat(Double(6) * 250)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beerDetailReviewDataManager.getBeerReviewInfo(rowNumber: String(0), beerId: BeerData.details.beerId, delegate: self) // 맥주 리뷰 정보(6개) 가져오는 api 호출.
    }
    
        
    
    @IBAction func clickNoReviewWriteButton(_ sender: UIButton) { // 리뷰 없을 때 - 첫 리뷰 남기는 버튼 클릭 시,
        print("리뷰 없을 때 - 리뷰 작성 버튼 클릭.")
        // TODO: - 여기에 리뷰 작성하는 내용 필요.
    }
    
    
    func setChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = [] // 데이터 생성
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "별점")
        // 차트 컬러 변경 부분 시작 //
        let maxValue: Int = values.max()!
        let maxIndex: Int = values.firstIndex(of: maxValue)!
        var uiBarColors: [NSUIColor] = [] // index마다의 bar 컬러 저장할 배열 선언.
        var uiValueColors: [NSUIColor] = [] // index마다의 value label 컬러 저장할 배열 선언.

        for i in 0..<chartDataSet.count {
            if i == maxIndex { // 리뷰가 제일 많은 index일 땐,
                uiBarColors.append(UIColor.mainYellow) // bar 노란색으로.
                uiValueColors.append(UIColor.mainYellow) // value label 노란색으로.
            }
            else { // 그 외일 땐,
                uiBarColors.append(UIColor.mainGray) // bar 회색으로.
                uiValueColors.append(UIColor.subBlack2) // 배경색과 같은 색으로. (사용자에게 안 보이게)
            }
        }
        chartDataSet.colors = uiBarColors // 차트 bar 컬러 변경.
        chartDataSet.valueColors = uiValueColors // 차트 value label 컬러 변경.
        // 차트 컬러 변경 부분 끝 //
        
        chartDataSet.valueFont = UIFont(name: "Montserrat-Bold", size: 10) ?? UIFont.systemFont(ofSize: 10)
        chartDataSet.highlightEnabled = false // 차트 선택 안되게.
        barChartView.doubleTapToZoomEnabled = false // 차트 줌 안되게.
        
        let chartData = BarChartData(dataSet: chartDataSet) // 데이터 삽입
        barChartView.data = chartData
        
        chartData.barWidth = Double(0.15)
        
        // double형표시 -> Int형표시로 전환 - https://stackoverflow.com/questions/44786924/swift-charts-chart-value-int-instead-of-double
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        barChartView.xAxis.labelPosition = .bottom // X축 레이블 위치 조정
        barChartView.xAxis.labelTextColor = .mainGray
        barChartView.xAxis.labelFont = UIFont(name: "NotoSansKR-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        barChartView.xAxis.axisLineColor = UIColor.clear // 하단 라인 제거
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: scorePoints) // X축 레이블 포맷 지정
        barChartView.rightAxis.enabled = false // 오른쪽 레이블 제거
        barChartView.leftAxis.enabled = false // 왼쪽 레이블 제거
        barChartView.legend.enabled = false // 범례 제거
        
        barChartView.xAxis.yOffset = -5 // 차트(bar)와 xAxis 거리 좁힘.
        
        barChartView.animate(xAxisDuration: 5.0, yAxisDuration: 5.0) //기본 애니메이션
        
        barChartView.xAxis.gridColor = .clear // 세로축 grid라인 제거
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
    }
    
    @IBAction func clickMoreImageButton(_ sender: UIButton) { // 더보기 버튼 클릭 시,
        print("더보기 버튼 클릭.")
        let seeReviewMoreImageVC = (self.storyboard?.instantiateViewController(withIdentifier: "SeeReviewMoreImageVC"))
        self.navigationController?.pushViewController(seeReviewMoreImageVC!, animated: true)
    }
    

}

// MARK: - 맥주 리뷰 정보(6개) GET Api
extension BeerDetailReviewViewController {
    
    // MARK: - 리뷰 있을 때,
    func didSuccessGetBeerReviewInfo(_ result: BeerDetailReviewResponse) { // beerId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 리뷰 ui 작업.
        print("서버로부터 맥주 리뷰 정보(6개) GET 성공!")
        print("response 내용 : \(result)")
        
        
        // api 데이터 가져온거로 리뷰 ui 구성.
        reviewCountLabel.text = String(result.result.reviewStatics.reviewCount)
        reviewScore.text = result.result.reviewStatics.reviewAverage
        
        // 소수점 score를 정수로 바꾸고 그 점수까지 스타 yellow이미지로 바꾸게 함.
        let score: Int = Int(floor(Double(result.result.reviewStatics.reviewAverage)!))
        
        for i in 0..<score {
            starImages[i].image = UIImage(named: "searchResultStarYellow.png")
        }
        
        reviewCount[0] = result.result.reviewStatics.five
        reviewCount[1] = result.result.reviewStatics.four
        reviewCount[2] = result.result.reviewStatics.three
        reviewCount[3] = result.result.reviewStatics.two
        reviewCount[4] = result.result.reviewStatics.one
        
        setChart(dataPoints: scorePoints, values: reviewCount)

        // 리뷰 요약본 밑에 있는 이미지뷰(4개) 세팅.
        for (i, imageUrl) in result.result.reviewImageList.enumerated() { // enumberated()는 열거형
            let url = URL(string: imageUrl.reviewImgUrl)
            DispatchQueue.global(qos: .background).async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.allImageViews[i].image = UIImage(data: data!)
                    self.allImageViews[i].contentMode = .scaleAspectFill
                }
            }
        }
        
        if result.result.reviewImageList.count == 4 { // 이미지가 4개일 땐,
            self.seeMoreImageLabel.isHidden = false // 더보기 라벨 띄움.
            self.seeMoreImageButton.isHidden = false // 더보기 버튼 띄움.
            self.seeMoreImageButton.backgroundColor = UIColor.mainBlack
            self.seeMoreImageButton.alpha = 0.6
        } else { // 이미지가 0개 ~ 3개일 땐,
            self.seeMoreImageLabel.isHidden = true // 더보기 라벨 숨김.
            self.seeMoreImageButton.isHidden = true // 더보기 버튼 숨김.
        }
        
        introReviewList.removeAll() // 리뷰(최대 6개) - 담는 리스트의 모든 element들을 지워줘야 함. (안 지우면 계속 데이터 남아있어서 결과가 쌓임)
        // 가져온 값들을 introReviewList에 데이터 넣음.
//        DispatchQueue.main.async {
        for reviewData in result.result.reviewList {
            self.introReviewList.append(IntroReviewModel(userCheck: reviewData.userCheck, reviewId: reviewData.reviewId, nickname: reviewData.nickname, age: reviewData.age, gender: reviewData.gender, beerKindId: reviewData.beerKindId, score: reviewData.score, updatedAt: reviewData.updatedAt, description: reviewData.description, reviewLikeCount: reviewData.reviewLikeCount, rowNumber: reviewData.rowNumber, reviewImgUrlList: reviewData.reviewImgUrlList))
        }
        self.introReviewTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
//        }
        
        print("##########HAHA##################################################################")
        print(introReviewList)
        for test in introReviewList {
            print(test.description)
        }
        
        
        
    }

    // MARK: - 리뷰 없을 때,
    func failedToGetBeerReviewInfo(message: String, code: Int) { // 해당 상품에 관한 리뷰가 없을 때
        print("리뷰 정보 GET 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        // TODO: - 나머지 view들 다 없애는 코드 계속 추가 필요함.
        reviewStaticsBackground.removeFromSuperview() // 리뷰 상태 삭제.
        allImageStackView.removeFromSuperview() // 이미지뷰 4개 담은 스택뷰 삭제.
        seeMoreImageLabel.removeFromSuperview() // 더보기 라벨 삭제.
        seeMoreImageButton.removeFromSuperview() // 더보기 버튼 삭제.
        
        
        noReviewLabel.isHidden = false // 리뷰 없을 때 안내 문구 보이게.
        noReviewButton.isHidden = false // 리뷰 없을 때 안내 버튼 보이게.
        noReviewButton.isUserInteractionEnabled = true
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3010 { // 실패 이유 : "해당 상품에 관한 리뷰가 없습니다."
            
        }
    }
    
}

// MARK: - 최하단 인기검색어 테이블뷰 부분 & 상단 검색어 입력시 검색결과 테이블뷰 부분
extension BeerDetailReviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("리뷰 개수 테스트 : \(introReviewList.count)")
        print("리뷰 개수 테스트 : \(BeerData.details.introReviewCount)")
        return introReviewList.count // 리뷰 개수(최대6개)만큼
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
//        let cell = tableView.dequeueReusableCell(withIdentifier: IntroReviewTableViewCell.identifier, for: indexPath) as! IntroReviewTableViewCell

        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IntroReviewTableViewCell
        let introReviewModel: IntroReviewModel = introReviewList[indexPath.row]


        // TODO: - 이미지쪽은 컬렉션뷰로 작업해줘야 함. (introReviewModel.reviewImgUrlList.count가 0이면 컬렉션뷰 숨김. / 아니면 작업들어감.)
//            let url = URL(string: introReviewModel.reviewImgUrlList[0].reviewImageUrl)

        // DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
//            DispatchQueue.global(qos: .background).async { // DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
//                let data = try? Data(contentsOf: url!)
//                DispatchQueue.main.async {
//                    cell.beerImage.image = UIImage(data: data!) // 만약 url이 없다면(안 들어온다면) try-catch로 확인해줘야 함.
//                    cell.beerImage.contentMode = .scaleAspectFit
//                }
//            }

        let beerKindDict: [Int: String] = [1: "라거", 2: "필스너", 3: "둔켈", 4: "에일", 5: "IPA", 6: "밀맥주", 7: "스타우트", 8: "포터"]
        let beerKindString: String = beerKindDict[introReviewModel.beerKindId]!
        
        cell.reviewName.text = introReviewModel.nickname // ex) 박수민
        cell.reviewUserInfo.text = "\(introReviewModel.age)/\(introReviewModel.gender)/\(beerKindString)"
        
        if introReviewModel.userCheck == "Y" { // 본인의 리뷰라면,
            cell.reviewTripleDot.isHidden = false // (우측상단) 점 3개 보이게.
            cell.reviewReportButton.isHidden = true // (우측중단) 신고하기 버튼 안보이게.
        }
        else { // 본인의 리뷰가 아니라면,
            cell.reviewTripleDot.isHidden = true // (우측상단) 점 3개 안보이게.
            cell.reviewReportButton.isHidden = false // (우측중단) 신고하기 버튼 보이게.
        }

        cell.starScore.text = String(introReviewModel.score) // ex) 4(리뷰 점수)
        

        // 소수점 score를 정수로 바꾸고 그 점수까지 스타 yellow이미지로 바꾸게 함. - 여기선 score가 이미 Int라서 안해도 되긴 함.
        let score: Int = Int(floor(Double(introReviewModel.score)))
        for i in 0..<score {
            cell.starImages[i].image = UIImage(named: "searchResultStarYellow.png")
        }

        cell.reviewDescription.text = introReviewModel.description // 리뷰 내용 - ex) 생각보다 에일의 쓴맛이 덜합니다
        cell.reviewDate.text = introReviewModel.updatedAt // 날짜 - 2022.03.06
        

        cell.selectionStyle = .none // 테이블뷰 cell 선택시 배경색상 없애기 : https://gonslab.tistory.com/41 | https://sweetdev.tistory.com/105

        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == introReviewTableView {
            print(introReviewList[indexPath.row].description)
            
//            BeerData.details.beerId = SearchResultList[indexPath.row].beerId // 맥주 beerId 저장. -> 맛향 VC에서 사용함.
            
            // 맥주 상세 설명 페이지로 연결.
//            let beerDetailVC = (self.storyboard?.instantiateViewController(withIdentifier: "BeerDetailVC")) as! BeerDetailViewController
//            beerDetailVC.beerId = SearchResultList[indexPath.row].beerId
//            self.navigationController?.pushViewController(beerDetailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == introReviewTableView {
        return 300
//        }
//        return tableView.rowHeight
    }
    
}

