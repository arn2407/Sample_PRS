//
//  TimlineCollectionViewCell.swift
//  PRSMedical
//
//  Created by Arun Kumar on 13/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import Charts

enum ChartType {
    case line
    case bar
}
class TimlineCollectionViewCell: BaseCollectionViewCell {
    private lazy var lineChart : LineChartView = {
        let chart = LineChartView()
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        chart.chartDescription?.enabled = false
        chart.legend.enabled = false
        
        
        chart.leftAxis.enabled = true
        chart.leftAxis.spaceTop = 0.4
        chart.leftAxis.spaceBottom = 0.4
        chart.leftAxis.axisMinimum = 0
        chart.leftAxis.axisMaximum = 90
        chart.leftAxis.setLabelCount(7, force: true)
        
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = true
        chart.xAxis.granularity = 3600 * 24
        chart.xAxis.valueFormatter = DateValueFormatter()
        chart.xAxis.centerAxisLabelsEnabled = true
        chart.xAxis.labelPosition = .top
        return chart
    }()
    
    private lazy var lineDataSet : LineChartDataSet = {
        let set = LineChartDataSet(values: [], label: "")
        set.lineWidth = 3.0
        set.circleRadius = 4.0
        set.circleHoleRadius = 2.5
        set.setColor(#colorLiteral(red: 0.5019607843, green: 0.7058823529, blue: 0.2549019608, alpha: 1))
        set.setCircleColor(#colorLiteral(red: 0.1960784314, green: 0.3960784314, blue: 0.6862745098, alpha: 1))
        set.highlightColor = .white
        set.drawValuesEnabled = false
        return set
    }()
    var chartType  : ChartType = .line
    {
        didSet
        {
            setupLineChart()
        }
    }
    var chartData = [(Double , TimeInterval)]()
    {
        didSet{
            updateLineDataSet()
        }
    }
    override func setupCell() {
        super.setupCell()
        
    }
    
    private func setupLineChart()
    {
        lineChart.removeConstraints(lineChart.constraints)
        addSubview(lineChart)
        addConstraints("H:|[v0]|", views: lineChart)
        addConstraints("V:|[v0]|", views: lineChart)
    }
    private func updateLineDataSet()
    {
    
        
        if chartData.isEmpty {
            lineChart.noDataText = "No Cushion found"
            return}
    let values = chartData.compactMap{ChartDataEntry(x: $0.1, y: $0.0)}
//        lineDataSet.values = entrySets
//        let data = LineChartData(dataSet: lineDataSet)
//        lineChart.data = data

        
    
    
       lineDataSet.values = values

        
        let data = LineChartData(dataSet: lineDataSet)
       
        
        lineChart.data = data
    }
    
    
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value)).replacingOccurrences(of: " ", with: "\n")
    }
}