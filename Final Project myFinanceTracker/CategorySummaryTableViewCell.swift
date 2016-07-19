//
//  CategorySummaryTableViewCell.swift
//  Final Project myFinanceTracker
//
//  Created by Haibei Wu on 2016-07-18.
//  Copyright © 2016 cs2680. All rights reserved.
//

import Foundation
import UIKit
import Charts

class CategorySummaryTableViewCell: UITableViewCell
{
    @IBOutlet weak var barChartView: HorizontalBarChartView!
    
    func loadChart(categories: Array<String>, amounts: Array<Double>) {
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.getAxis(ChartYAxis.AxisDependency.Right).enabled = false
        barChartView.getAxis(ChartYAxis.AxisDependency.Left).enabled = false
        barChartView.descriptionText = ""
        barChartView.legend.enabled = false
        barChartView.getAxis(ChartYAxis.AxisDependency.Left).axisMaxValue = amounts.maxElement()!
        barChartView.getAxis(ChartYAxis.AxisDependency.Left).axisMinValue = 0
        barChartView.drawValueAboveBarEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        
        barChartView.xAxis.xOffset = 10.0
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftYAxisRenderer.yAxis?.drawGridLinesEnabled = false
        barChartView.rightYAxisRenderer.yAxis?.drawGridLinesEnabled = false
        
        // Disable all interaction with the chart
        barChartView.doubleTapToZoomEnabled = false
        barChartView.highlightPerTapEnabled = false
        barChartView.highlightPerDragEnabled = false
        barChartView.drawHighlightArrowEnabled = false
        
        var dataEntries: [BarChartDataEntry] = []
        
        var j = 0;
        for i in (0 ..< categories.count).reverse() {
            let dataEntry = BarChartDataEntry(value: amounts[i], xIndex: j)
            dataEntries.append(dataEntry)
            j = j + 1
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "")
        let test = ["Salary", "Deposits", "Rental", "Other Income"].reverse() as Array<String>
        let chartData = BarChartData(xVals: test, dataSet: chartDataSet)
        
        barChartView.data = chartData
    }
}