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
        
        // 데이터 생성
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "별점")

        chartDataSet.colors = [.mainYellow] // 차트 컬러
        chartDataSet.highlightEnabled = false // 선택 안되게
        barChartView.doubleTapToZoomEnabled = false // 줌 안되게

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        // double형표시 -> Int형표시로 전환 - https://stackoverflow.com/questions/44786924/swift-charts-chart-value-int-instead-of-double
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        chartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        barChartView.xAxis.labelPosition = .bottom // X축 레이블 위치 조정
        barChartView.xAxis.labelTextColor = .mainGray
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: scorePoints) // X축 레이블 포맷 지정
        barChartView.rightAxis.enabled = false // 오른쪽 레이블 제거
        barChartView.leftAxis.enabled = false // 왼쪽 레이블 제거
        
        barChartView.legend.enabled = false // 범례 제거
        
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

