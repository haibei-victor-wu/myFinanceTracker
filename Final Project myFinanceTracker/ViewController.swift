//
//  ViewController.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-10.
//  Copyright © 2016 cs2680. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var barChartView: HorizontalBarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var months:Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        months = ["Mortgage", "Taxes", "Education", "Utilities", "Insurance", "Groceries", "Restaruant"]
        let unitsSold = [200.0, 400.0, 600.0, 300.0, 100.0, 50.0, 101.1]
        
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.getAxis(ChartYAxis.AxisDependency.Right).enabled = false
        barChartView.getAxis(ChartYAxis.AxisDependency.Left).enabled = false
        barChartView.descriptionText = ""
        barChartView.legend.enabled = false
        barChartView.getAxis(ChartYAxis.AxisDependency.Left).axisMaxValue = 600
        barChartView.getAxis(ChartYAxis.AxisDependency.Left).axisMinValue = 0
        barChartView.drawValueAboveBarEnabled = false
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

