//
//  DegailScreenViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/19.
//

import UIKit
import FSCalendar

class DetailScreenViewContorller: UIViewController,FSCalendarDelegateAppearance ,FSCalendarDelegate{
    
    func formattedDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd (E) HH:mm"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }

    
    
    @IBOutlet weak var currentCount: UILabel!
    @IBOutlet weak var todayCountLabel: UILabel!
    @IBOutlet weak var weekCountLabel: UILabel!
    @IBOutlet weak var monthCountLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var detail: UILabel!
    
    var product: Product?
    var productId: Int?
    var productsRepository: ProductsRepository?
    var treasuresRepository: TreasurerRepository?
    
    var treasures: [Treasurer]? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        fetchData()
        //tableView.register(UINib(nibName: "DetailScreenTreasurerTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailScreenTreasurerTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        Task.detached{
            do{
                guard let productId = await self.productId,
                      let product = try await self.productsRepository?.getProduct(id: productId),
                      let treasures = try await self.treasuresRepository?.getTreasurer(productId: product.id)
                else {
                    print("フェッチに失敗しました")
                    return
                }
                let sortedTreasures = treasures.sorted(by: { i, n in
                    i.modifyDate < n.modifyDate
                })
                
                await MainActor.run {
                    self.treasures = sortedTreasures
                    self.product = product

                    print("UpdatingUI... \(String(describing: product))")
                    
                    self.currentCount.text = String(sortedTreasures.getCurrentCount())
                    self.todayCountLabel.text = String(sortedTreasures.getTodayCount())
                    self.weekCountLabel.text = String(sortedTreasures.getThisWeekCount())
                    self.monthCountLabel.text = String(sortedTreasures.getThisMonthCount())
                    self.detail.text = product.memo ?? "この商品にメモはありません"
                    
                    self.calendar.reloadData()
                    self.title = product.name
                }
            }catch{
                print("Error: \(error)")
            }
        }
    }
    
    
    let subViewTag = arc4random()
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if(treasures == nil){
            return
        }
        
        
        var out = 0
        var input = 0
        
        treasures?.forEach { treasurer in
            if areDatesOnSameDay(date1: date, date2: treasurer.modifyDate){
                if(treasurer.count > 0){
                    input += treasurer.count
                }else{
                    out -= treasurer.count
                }
            }
        }
        
        cell.subviews.forEach { view in
            if view is UIStackView && view.tag == Int(subViewTag) {
                view.removeFromSuperview()
            }
        }
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 25, width: cell.frame.width, height: 20))
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.tag = Int(subViewTag)
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(getAmountLabel(amount: out, color: .red, align: .right))
        stackView.addArrangedSubview(getAmountLabel(amount: input, color: .blue, align: .left))

        cell.addSubview(stackView)
    }
    
    func getAmountLabel(amount: Int, color: UIColor, align: NSTextAlignment) -> UILabel {
        let tempLabel = UILabel(frame: CGRect(x: 20, y: 25, width: 20, height: 20))
        tempLabel.font = UIFont.systemFont(ofSize: 8)
        tempLabel.text = String(amount)
        tempLabel.textColor = color
        tempLabel.textAlignment = align
        
        return tempLabel
    }
    
    private func areDatesOnSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        let date1Components = calendar.dateComponents([.year, .month, .day], from: date1)
        let date2Components = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return date1Components.year == date2Components.year &&
               date1Components.month == date2Components.month &&
               date1Components.day == date2Components.day
    }

}
