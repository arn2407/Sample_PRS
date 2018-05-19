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
    
    var limit = 4.0
    
    private lazy var lineChart : LineChartView = {
        let chart = LineChartView()
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        chart.chartDescription?.enabled = false
        chart.legend.enabled = false
        chart.maxVisibleCount = 7
        
        chart.leftAxis.enabled = true
        chart.leftAxis.spaceTop = 0.4
        chart.leftAxis.spaceBottom = 0.4
        chart.leftAxis.axisMinimum = 0
        chart.leftAxis.axisMaximum = 90
        chart.leftAxis.setLabelCount(7, force: true)
        
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = true
//        chart.xAxis.granularity = 3600 * 24
        chart.xAxis.valueFormatter = DateValueFormatter()
        chart.xAxis.centerAxisLabelsEnabled = true
        chart.xAxis.labelPosition = .top
        chart.fitScreen()
        return chart
    }()
    
    private lazy var barChart : BarChartView = {
        let chart = BarChartView()
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
        chart.chartDescription?.enabled = false
        chart.legend.enabled = false
        chart.maxVisibleCount = 7
        
        chart.leftAxis.enabled = true
        chart.leftAxis.spaceTop = 0.4
        chart.leftAxis.spaceBottom = 0.4
        chart.leftAxis.axisMinimum = 0
        chart.leftAxis.axisMaximum = 90
        chart.leftAxis.setLabelCount(7, force: true)
        chart.leftAxis.labelTextColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        
        chart.rightAxis.enabled = false
        chart.xAxis.enabled = true
        chart.xAxis.labelTextColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
//        chart.xAxis.granularity = 3600 * 24
       chart.xAxis.valueFormatter = DateValueFormatter()
        chart.xAxis.centerAxisLabelsEnabled = true
        chart.xAxis.labelPosition = .top
        chart.fitBars = true
        return chart
    }()
    
    private lazy var lineDataSet : LineChartDataSet = {
        let set = LineChartDataSet(values: [], label: "")
        set.lineWidth = 3.0
        set.circleRadius = 4.0
        set.circleHoleRadius = 2.5
        set.setColor(#colorLiteral(red: 0.1960784314, green: 0.3960784314, blue: 0.6862745098, alpha: 1))
        set.setCircleColor(#colorLiteral(red: 0.5019607843, green: 0.7058823529, blue: 0.2549019608, alpha: 1))
        set.highlightColor = .white
        set.drawValuesEnabled = false
        return set
    }()
    var chartType  : ChartType = .line
    {
        didSet
        {
            
            chartType == .line ?  setupLineChart() : setupBarChart()
        }
    }
    var chartData = [([Double] , TimeInterval)]()
    {
        didSet{
            
            chartType == .line ?  updateLineDataSet() : updateBarDataSet()
        }
    }
    override func setupCell() {
        super.setupCell()
        
    }
    
    private func setupLineChart()
    {
        barChart.removeFromSuperview()
        lineChart.removeConstraints(lineChart.constraints)
        addSubview(lineChart)
        addConstraints("H:|[v0]|", views: lineChart)
        addConstraints("V:|[v0]|", views: lineChart)
    }
    private func setupBarChart()
    {
        lineChart.removeFromSuperview()
        barChart.removeConstraints(barChart.constraints)
        addSubview(barChart)
        addConstraints("H:|[v0]|", views: barChart)
        addConstraints("V:|[v0]|", views: barChart)
    }
    private func updateLineDataSet()
    {
    
        if chartData.isEmpty {
            lineChart.noDataText = "No Cushion found"
            return}
        lineChart.xAxis.setLabelCount(chartData.count, force: true)

    let values = chartData.compactMap{ChartDataEntry(x: $0.1, y: $0.0.reduce(0, +)/Double($0.0.count))}

       lineDataSet.values = values

        
        let data = LineChartData(dataSet: lineDataSet)
       
        
        lineChart.data = data
    }
    
    private func updateBarDataSet()
    {
        
        
        if chartData.isEmpty {
            barChart.noDataText = "No Cushion found"
            return}
        barChart.xAxis.setLabelCount(chartData.count, force: true)
//        let yVals = chartData.enumerated().map { (value) -> BarChartDataEntry in
//
//            return BarChartDataEntry(x: Double(value.element.1), yValues: value.element.0)
//        }
        
        let dataSets = chartData.map { (value) -> BarChartDataSet in
            
            
            let colors : [NSUIColor] = value.0.map{$0 > self.limit ? #colorLiteral(red: 0.8784313725, green: 0.3411764706, blue: 0.4117647059, alpha: 1) : #colorLiteral(red: 0.1960784314, green: 0.3960784314, blue: 0.6862745098, alpha: 1)}
            let entries = BarChartDataEntry(x: value.1, yValues: value.0)
            
            let set = BarChartDataSet(values: [entries], label: "")
            set.drawIconsEnabled = false
            set.drawValuesEnabled = false
            set.colors = colors
            return set
        }

      
     
        
        let data = BarChartData(dataSets: dataSets)
        
        barChart.data = data
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
