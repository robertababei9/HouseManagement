//
//  StatisticsViewController.swift
//  HouseManagement
//
//  Created by Robert Ababei on 11/09/2019.
//  Copyright © 2019 Robert Ababei. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Charts

class StatisticsViewController: UIViewController {
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var perTotalButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var thisWeekButton: UIButton!
    
    let ref = Database.database().reference()
    
    let names = ["Robert", "Cipri", "Claudiu", "Monica"]
    let scores = [22, 18, 15, 19]
    let names2 = ["X", "Y", "Z"]
    let scores2 = [11, 22, 33]
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        perTotalStats()
        
    }
    
    @IBAction func perTotalDidClicked(_ sender: UIButton) {
        perTotalStats()
    }
    
    @IBAction func thisWeekBtnClicked(_ sender: UIButton) {
        perWeekStats()
    }
    
    @IBAction func thisMonthBtnClicked(_ sender: Any) {
        
    }
    
}


extension StatisticsViewController {
    //DESCRIPTION: names.count must pe <= values.count
    func configChart(names: [String], values: [Double]) {
        // 1. Set dataChartEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0 ..< names.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: names[i], data: names[i] as? AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // 2. Set CharDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = [.red, .blue, .green, .gray]
        
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        pieChartView.data = pieChartData
    }

    func perTotalStats() {
        var names = [String]()
        var noWorks = [Int]()
        ref.child("statistics").child("perTotal").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let dict = snapshot.value as? [String: Int] {
                    for (name, number) in dict {
                        names.append(name)
                        noWorks.append(number)
                    }
                }
            }
            DispatchQueue.main.async {
                self.configChart(names: names, values: noWorks.map { Double($0) })
            }
        }
    }
    
    func perWeekStats() {
        var names = [String]()
        var noWorks = [Int]()
        ref.child("statistics").child("thisWeek").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let dict = snapshot.value as? [String: Int] {
                    for(name, number) in dict {
                        names.append(name)
                        noWorks.append(number)
                    }
                }
            }
            DispatchQueue.main.async {
                self.configChart(names: names, values: noWorks.map { Double($0) })
            }
        }
    }
}
