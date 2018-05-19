//
//  DashboardViewController.swift
//  PRSMedical
//
//  Created by Arun Kumar on 12/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import UIKit
import CoreMotion

class DashboardViewController: UIViewController {

    @IBOutlet weak var viewCurrentProgress : GoalProgressView!
    
    @IBOutlet weak var colletionTodayProgress : UICollectionView!
    
    @IBOutlet weak var constraintHeightViewProgress : NSLayoutConstraint!
     @IBOutlet weak var constraintHeightCollection : NSLayoutConstraint!
    @IBOutlet weak var topSpaceCollectionTimeline : NSLayoutConstraint!
    @IBOutlet weak var topSpaceViewTimeline : NSLayoutConstraint!
    @IBOutlet weak var topSpacelabelCurrent : NSLayoutConstraint!
    
    
    @IBOutlet weak var labelCurrent : UILabel!
    @IBOutlet weak var labelChargingStatus: UILabel!
    @IBOutlet weak var labelCurrentTiming : UILabel!
    @IBOutlet weak var labelGoal : UILabel!
    @IBOutlet weak var labelSelectedChartType : UILabel!
    @IBOutlet weak var buttonCushionName : UIButton!
    @IBOutlet weak var buttonNext : UIButton!
    @IBOutlet weak var buttonPrevious : UIButton!
    @IBOutlet weak var viewPickerComponent : UIView!
    @IBOutlet weak var picker  : UIPickerView!
    private var isTimerStarted = false
    private var currentSittingTime = 0.0
    private var totalTiming = 0.0
    private var timeLimit  = 0.0
    @IBOutlet weak var collectionTimeline : UICollectionView!
        {
        didSet{
            collectionTimeline.registerCell(type: TimlineCollectionViewCell.self)
        }
    }
    
    
    private let dashboardVM = DasboardViewModel()
    private let cushionUploadVM = CushionDataUploadViewModel()
    private let cushionTransactionVM = CushionTransactionViewModel()
    private var arrayCushions = [CushionBasic]()
    
     private let pedometer = CMPedometer()
    
    private class TodayProgressData
    {
        let title : String
        var value : String
        init(_ title : String , _ value : String) {
            self.title = title
            self.value = value
        }
        
    }
    
  private  let arrToday = [TodayProgressData.init("Average Sitting Time", ""),
                                TodayProgressData.init("Total Sitting Time", ""),
                                TodayProgressData.init("Steps", "")]
    private var timelineData = [([Double] , TimeInterval)]()
    
    private var currentCushion : CushionBasic?
    
    private var allCushions : [Cushion] = []
    
    private var progressTime : Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard"
        
       if !iPhonX
       {
        constraintHeightViewProgress.constant = aspectRatio * 179
        constraintHeightCollection.constant = aspectRatio * 191
        topSpaceCollectionTimeline.constant = aspectRatio * 20
        topSpaceViewTimeline.constant = aspectRatio * 51
        if iPhoneSE
        {
            topSpacelabelCurrent.constant = 30
            labelSelectedChartType.font = UIFont.systemFont(ofSize: 14.0)
            labelCurrentTiming.font = UIFont.systemFont(ofSize: 16.0)
              labelGoal.font = UIFont.systemFont(ofSize: 12.0)
        }
        }
        
        resetCurrentProgress()
        startUpdatingMotion()
        
        addBLENotification()
        fetchCushionDetails()
   
         isNotCharging = true
        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allCushions = Cushion.getAllCushions()
        if allCushions.isEmpty
        {
            buttonCushionName.setTitle("No Cushion", for: .normal)
        }
        else
        {
            self.allCushions.forEach({ (cushion) in
                if !self.arrayCushions.contains(where: {$0.identifier == cushion.cushionUUID})
                {
                    self.arrayCushions += [CushionBasic(name: cushion.name!, identifier: cushion.cushionUUID!)]
                }
            })
            currentCushion = self.arrayCushions.first
            loadTimeLineData()
        }
       

    }

    private var isNotCharging : Bool = false
    {
        didSet{
            labelGoal.isHidden = !isNotCharging
            labelCurrent.isHidden = !isNotCharging
            labelCurrentTiming.isHidden = !isNotCharging
            labelChargingStatus.isHidden = isNotCharging
        }
    }
    
    private func resetCurrentProgress()
    {
        viewCurrentProgress.progress = 0
        labelCurrentTiming.text = "0 min"
        labelGoal.text = "0 min"
        viewCurrentProgress.goalHour = 1
        
        self.progressTime?.invalidate()
        self.progressTime = nil
    }
    
 
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startUpdatingMotion() {
        
        
        if CMPedometer.isStepCountingAvailable() {
         
            
            let calender = Calendar.current
            var components = calender.dateComponents([.day , .month , .year], from: Date())
            components.hour = 0
            components.minute = 0
            components.second = 0
            
            
            if let midnightDate = calender.date(from: components)
            {
                debugPrint(midnightDate)
                
                pedometer.startUpdates(from: midnightDate) {
                    [weak self] pedometerData, error in
                    guard let pedometerData = pedometerData, error == nil else { return }
                    
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        stepCount = pedometerData.numberOfSteps.stringValue
                        self.arrToday[2].value = stepCount
                        self.colletionTodayProgress.reloadItems(at: [IndexPath.init(item: 2, section: 0)])
                    }
                }

            }
            
            
        }
    }
    
    @IBAction func actionShowCushions(_ sender : Any)
    {
        if isTimerStarted {
            let actionOK : AlertAction = ("OK" , .default , nil)
            self.showAlert(withTitle: "Alert", msg: "your current progress is still goin on. Please complete it to see other cushions", actions: actionOK)
            return
        }
        showPickerView()
    }

    @IBAction func actionPickerDone(_ sender : Any)
    {
        closePickerView()
        let pickerSelectedIndex = picker.selectedRow(inComponent: 0)
        if let index = self.arrayCushions.index(where: {$0.identifier == self.currentCushion?.identifier})
        {
            if index == pickerSelectedIndex {return}
        }
        currentCushion = self.arrayCushions[pickerSelectedIndex]
        
        loadTimeLineData()
    }
    
    @IBAction func actionTimelinePageChange(_ sender : UIButton)
    {
        labelSelectedChartType.text = sender.tag == 0 ? "Average Sitting Time" : "Total Sitting Time"
        buttonNext.isEnabled = sender.tag == 0
        buttonPrevious.isEnabled = sender.tag == 1
       let indexpath = IndexPath.init(item: sender.tag, section: 0)
        collectionTimeline.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: false)
        collectionTimeline.reloadItems(at: [indexpath])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        self.progressTime?.invalidate()
        self.progressTime = nil
        removeBLENotification()
    }

}
extension DashboardViewController : CollectionViewDelegates
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionTimeline:
            return 2
        default:
            return  arrToday.count
        }
        
    }
 

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case collectionTimeline:
            let cell = collectionView.dequeReusableCell(for: indexPath) as TimlineCollectionViewCell
            cell.chartType = indexPath.item == 0 ? .line : .bar
            cell.chartData = self.timelineData
            cell.limit = 15.0
            return cell
        default:
            let cell = collectionView.dequeReusableCell(for: indexPath) as TodayStatusCollectionViewCell
            let progress = arrToday[indexPath.item]
            cell.textLabel.text = progress.title
            cell.detailTextLabel.text = progress.value
//            switch indexPath.item  {
//            case 2:
//                cell.detailTextLabel.text = progress.value
//            default:
//                cell.detailTextLabel.attributedText = setAttributeText(for: progress.value)
//            }
            
            return cell
        }
        
      
    }
    private func setAttributeText(for text : String) -> NSAttributedString
    {
        if text.isEmpty {return NSAttributedString()}
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
            .foregroundColor: #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1),
            .kern: 0.17
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 18.0, weight: .medium), range: NSRange(location: 0, length: 1))
        return attributedString
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case collectionTimeline:
            return 0
        default:
            return  aspectRatio * 8
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionTimeline:
            return collectionView.bounds.size
        default:
            return CGSize(width: collectionView.bounds.width, height: aspectRatio * 54)
        }
    }
}

extension DashboardViewController
{
    
    private func addBLENotification()
    {
        addNotification(notification: .connectCushion, selector: #selector(cushionConnectedNotification(_:)))
        addNotification(notification: .disconnectCushion, selector: #selector(cushionDisConnectedNotification(_:)))
        addNotification(notification: .updateCushion, selector: #selector(cushionUpdatedNotification(_:)))
        addNotification(notification: .cushionTimerStart, selector: #selector(cushionTimerStartedNotification(_:)))
        addNotification(notification: .cushionTimerStopped, selector: #selector(cushionTimerStoppedNotification(_:)))
        addNotification(notification: .cushionChargingStatusChanged, selector: #selector(cushionTimerStoppedNotification(_:)))
        
        
    }
    private func removeBLENotification()
    {
        removeNotification(notification: .connectCushion)
        removeNotification(notification: .disconnectCushion)
        removeNotification(notification: .updateCushion)
        removeNotification(notification: .cushionTimerStart)
        removeNotification(notification: .cushionTimerStopped)
        
    }
    
    @objc func cushionConnectedNotification(_ noti : Notification)
    {
        if let cushion = noti.object as? CushionServer
        {
            if let current = currentCushion , current.identifier == cushion.identifier
            {
                //cushion.delegate = self
            }
        }
    }
    
    @objc func cushionDisConnectedNotification(_ noti : Notification)
    {
        if let _ = noti.object as? CushionServer
        {
            
        }
    }
    
    @objc func cushionUpdatedNotification(_ noti : Notification)
    {
        if let cushion = noti.object as? CushionServer
        {
            if let current = currentCushion , current.identifier == cushion.identifier
            {
               self.isNotCharging =  cushion.chargerFlag == 0
              
            }
        }
    }
    @objc func cushionTimerStartedNotification(_ noti : Notification)
    {
        if let server = noti.object as? CushionServer
        {
        if let current = currentCushion , current.identifier == server.identifier
        {
            isTimerStarted = true
            timeLimit = Double(server.alerttime)
            labelGoal.text = "Goal: \(server.alerttime > 60 ? server.alerttime.formattedTime : "\(server.alerttime) mins")"
            
            viewCurrentProgress.goalHour = CGFloat(server.alerttime ) / 60
            
            startTimer()
            updateServerFor(server)
        }
    }
    }
    
     private func startTimer()
    {
        var startingTime  = 0
        
        func setProgress(_ progress : Int)
        {
            if progress < 60 {
               labelCurrentTiming.text = "\(progress) \(progress > 1 ? "mins" : "min")"
            }
            else
            {
                labelCurrentTiming.text = "\(progress/60) hr \(progress%60) mins"
            }
            viewCurrentProgress.progress = CGFloat(progress)
            startingTime = progress
        }
        
        setProgress(startingTime)
        
        self.progressTime?.invalidate()
        self.progressTime = nil
        
      self.progressTime =  Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {[weak self] (timer) in
            guard let `self` = self else {return}
            if !self.isTimerStarted {timer.invalidate(); return}
            setProgress(startingTime + 1)
        }
    }

    @objc func cushionTimerStoppedNotification(_ noti : Notification)
    {
        if let server = noti.object as? CushionServer
        {
            if let current = currentCushion , current.identifier == server.identifier
            {
                isTimerStarted = false
                resetCurrentProgress()
                  updateServerFor(server)
                loadTimeLineData()
                updateTransactionData(server)
            }
        }
    }
    
    private func updateServerFor(_ cushion : CushionServer)
    {
        let requestModel = CushionData(userid: userEmailID, cushionid: cushion.identifier, activestate: "\(cushion.chargerFlag)", occupiedstate: "\(cushion.cushionStatus)", currentTimeSetting: "\(cushion.alerttime)", vibrationstate: "\(cushion.vibration ? 1 : 0)", cushionBaseTime: "\(cushion.rtcTimeStamp)", batteryPercentage: "\(cushion.battery)", batteryvoltage: "", faulty: "\(cushion.motorFault)")
        cushionUploadVM.fetchCushionData(requestModel) {[weak self] (success, msg) in
            guard let `self` = self else {return}
            debugPrint(success ? self.cushionUploadVM.messgae : (msg ?? "Update failed"))
        }
        
    }
    
    private func updateTransactionData(_ cushion : CushionServer)
    {
        let requestModel = CushionTransaction(userid: userEmailID, cid: cushion.identifier, cushionname: currentCushion!.name, date: Date().getString(for: "dd/MM/yyyy"), averagesittingtime: "\(currentSittingTime)", stepcount: arrToday[2].value , totaltime : "\(totalTiming)" , alerttime : "\(self.timeLimit)")
        cushionTransactionVM.fetchCushionData(requestModel) {[weak self] (success, msg) in
            guard let `self` = self else {return}
            debugPrint(success ? self.cushionTransactionVM.messgae : (msg ?? "Update failed"))
        }
    }
    
   
    
    

}

extension DashboardViewController
{
    struct CushionBasic {
        let name : String
        let identifier : String
    }
    
    private func fetchCushionDetails()
    {
        
        let input = CushionRquest(userid: userEmailID)
        sharedApp.loader.showLoader()
        dashboardVM.fetchCushionData(input) {[weak self] (success, msg) in
            sharedApp.loader.hideLoader()
            guard let `self` = self else{return}
            self.dashboardVM.getAllServerCushion().forEach({ (serverData) in
                if !self.arrayCushions.contains(where: {$0.identifier == serverData.cushionid})
                {
                    self.arrayCushions += [CushionBasic(name: serverData.cushionname, identifier: serverData.cushionid)]
                }
            })
            self.allCushions.forEach({ (cushion) in
                if !self.arrayCushions.contains(where: {$0.identifier == cushion.cushionUUID})
                {
                  self.arrayCushions += [CushionBasic(name: cushion.name!, identifier: cushion.cushionUUID!)]
                }
            })
            
            if self.currentCushion == nil
            {
                self.currentCushion = self.arrayCushions.first
                self.buttonCushionName.setTitle(self.currentCushion?.name, for: .normal)
                self.loadTimeLineData()
            }
            
            
        }
        
        
    }
    
    private func loadTimeLineData()
    {
        title = "You Met Your Goal 0 Times Today!"
        
        if let cushion = currentCushion , let savedCushion = Cushion.getCushion(for: cushion.identifier) , let info =  savedCushion.sittingInfo
        {
            buttonCushionName.setTitle(cushion.name, for: .normal)
            self.timelineData = info.compactMap({ (sittingInfo) -> ([Double] , TimeInterval)? in
            
                return (sittingInfo.timeIntervals , sittingInfo.updateTime!.timeIntervalSince1970)
            })
            
            collectionTimeline.reloadData()
            
            if  let info = savedCushion.getSittingInfo(of: Date())
            {
                let count = !info.timeIntervals.isEmpty ?  info.timeIntervals.count : 1
                currentSittingTime = info.timeIntervals.last ?? 0.0
                 totalTiming = info.timeIntervals.reduce(0, +)
               let  avgTiming = totalTiming/Double(count)
                let hour = Int(avgTiming/60)
                let minute = Int(avgTiming) % 60
                arrToday[0].value =  "\(hour) hr \(minute) min"
                arrToday[1].value = "\(Int(totalTiming/60)) hr \(Int(totalTiming)%60) min"
                
                colletionTodayProgress.reloadData()
                if self.timeLimit > 0
                {
                let filteredArray = info.timeIntervals.compactMap{$0 > self.timeLimit ? nil : $0}
                title = "You Met Your Goal \(filteredArray.count) Times Today!"
                }
                
            }
            
        }
        else if  let cushion = currentCushion
        {
            let arr = dashboardVM.getAllServerCushion().filter{$0.cushionid == cushion.identifier}
            let dates = Set(arr.map{$0.date})
            self.timelineData = dates.compactMap { (date) -> ([Double] , TimeInterval)? in
               return ( arr.filter{$0.date == date}.map{Double($0.averagesittingtime) ?? 0.0} , date.getDate(for : "dd/MM/yyyy")?.timeIntervalSince1970 ?? 0.0)
            }
         
            let todayArray = arr.filter{$0.date == Date().getString(for: "dd/MM/yyyy")}
            if !todayArray.isEmpty
            {
           let totalTime = todayArray.compactMap{Double($0.averagesittingtime)}.reduce(0.0, +)
            let avgTime =  totalTime / Double(todayArray.count)
          
                self.arrToday[0].value =  "\(avgTime) min"
                self.arrToday[1].value = "\(totalTime) min"
            }
            else
            {
                self.arrToday[0].value =  "0 min"
                self.arrToday[1].value = "0 min"
            }
            if self.timeLimit > 0
            {
            let filteredArray = todayArray.compactMap{(Double($0.averagesittingtime) ?? 0.0) > self.timeLimit ? nil : Double($0.averagesittingtime)}
            title = "You Met Your Goal \(filteredArray.count) Times Today!"
            }
            self.colletionTodayProgress.reloadItems(at: [IndexPath.init(item: 0, section: 0) , IndexPath.init(item: 1, section: 0)])

            collectionTimeline.reloadData()
        }
        
        
        
        
    }
    
}

extension DashboardViewController : UIPickerViewDataSource , UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayCushions.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let basicCushion = arrayCushions[row]
        return basicCushion.name
    }
    
    
    private func showPickerView()
    {
        if viewPickerComponent.isDescendant(of: view) {return}
        let originFrame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 235.0)
        viewPickerComponent.frame = originFrame
        view.addSubview(viewPickerComponent)
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseIn], animations: { [weak self] in
            guard let `self` = self else {return}
            var rect = self.viewPickerComponent.frame
            rect.origin.y = self.view.bounds.height - rect.height
            self.viewPickerComponent.frame = rect
            }, completion: nil)
    }
    
    private func closePickerView()
    {
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            [weak self ] in
            guard let `self` = self else {return}
            
            var rect = self.viewPickerComponent.frame
            rect.origin.y = self.view.bounds.height
            self.viewPickerComponent.frame = rect
            
        }) {[weak self ] (isFinished) in
            guard let `self` = self else {return}
            self.viewPickerComponent.removeFromSuperview()
        }
    }
    
}
