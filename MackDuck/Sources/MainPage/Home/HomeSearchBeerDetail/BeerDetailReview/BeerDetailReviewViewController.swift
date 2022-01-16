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
    
    @IBOutlet weak var reviewScore: UILabel! // 총 평점( ex - 0.0)
    @IBOutlet var starImages: [UIImageView]! // 별 이미지들
    
    var scorePoints: [String] = ["5점", "4점", "3점", "2점", "1점"]
    var reviewCount: [Int] = [0, 0, 0, 0, 0]
    
    @IBOutlet weak var reviewCountLabel: UILabel! // 리뷰 개수 라벨.
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        barChartView.noDataText = "아직 작성된 리뷰가 없어요ㅠㅠ"
        barChartView.noDataFont = UIFont(name: "NotoSansKR-Bold", size: 24)!
        barChartView.noDataTextColor = .mainGray
        
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
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beerDetailReviewDataManager.getBeerReviewInfo(rowNumber: BeerData.details.rowNumber, beerId: BeerData.details.beerId, delegate: self) // 맥주 리뷰 정보(6개) 가져오는 api 호출.
    }
    
    

}

// MARK: - 맥주 리뷰 정보(6개) GET Api
extension BeerDetailReviewViewController {
    
    // beerId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 맥주 맛/향 설정.
    func didSuccessGetBeerReviewInfo(_ result: BeerDetailReviewResponse) {
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
        
    }

    func failedToGetBeerReviewInfo(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3010 { // 실패 이유 : "해당 상품에 관한 리뷰가 없습니다."
            
        }
    }
    
}

