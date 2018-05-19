//
//  BluetoothManager.swift
//  PRSMedical
//
//  Created by Arun Kumar on 21/04/18.
//  Copyright © 2018 Arun Kumar. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth


@objc
protocol BluetoothManagerDelegate : NSObjectProtocol {
  
  @objc optional  func foundCushion(_ peripheral : RKPeripheral)
    @objc optional func updateState(_ state : CBManagerState)
    @objc optional func didCushionConnect(_ cushion : CushionServer)
   @objc optional func didCushionDisconnect(_ cushion : CushionServer)
    

}

class BluetoothManager : NSObject
{
    
    struct Device {
        
        static let cushionUDID = CBUUID(string: "FFF0")
        static  let UUID_LOG_DATA = CBUUID(string: "FFF1")
        static  let UUID_EVENT_ORIENTED = CBUUID(string: "FFF2")
        static  let UUID_REQUEST = CBUUID(string: "FFF3")
        static  let UUID_DEVICE_ID = CBUUID(string: "FFF4")
        static  let UUID_RTC = CBUUID(string: "FFF5")
        
        
        static let GATT_SERVICE = CBUUID(string: "F000F1E0-0451-4000-B000-000000000000")
        static let LOG_UDID = CBUUID(string: "F000B1F9-0451-4000-B000-000000000000")
         static let EVENT_ORIENTED_UDID = CBUUID(string: "F0009B73-0451-4000-B000-000000000000")
         static let REQUEST_CHAR_UDID = CBUUID(string: "F0008BC3-0451-4000-B000-000000000000")
         static let DEVICE_CONFIG_UDID = CBUUID(string: "F000FF97-0451-4000-B000-000000000000")
         static let RTC_UPDATE_UDID = CBUUID(string: "F0006424-0451-4000-B000-000000000000")
        
      
        
        
    }
    
    private var cushionService : CBService?
    
     var eventOrientedCharacteristic : CBCharacteristic?
     var requestDataCharacteristic : CBCharacteristic?
     var logDataCharacteristic : CBCharacteristic?
     var deviceConfCharacteristic : CBCharacteristic?
     var rtcCharacteristic : CBCharacteristic?
    
    
    
    private var cushionCharacterstics = [CBCharacteristic]()
    
    
    private var   logSize : Int = 0
    private var  logCountSize : Int = 0
    
    weak var delegate : BluetoothManagerDelegate?
    
    override init() {
        super.init()
    let options = [CBCentralManagerOptionShowPowerAlertKey : true ]
    let queue = DispatchQueue.init(label: "BLEThread")
    self.myCentral = RKCentralManager(queue : queue , options : options)
    }
    private var myCentral : RKCentralManager!
    
    var cushionList : [CushionServer] = []
    
      func start(_ connect : Bool = false)
    {
         if self.myCentral.state == .poweredOn {
            self.scanPeripheral(connect)
        }
        else
        {
            
            
        self.myCentral.onStateChanged = { [weak self](error) in
            guard let `self` = self else {return}
            if self.myCentral.state == .poweredOn {
                self.scanPeripheral(connect)
            }
            else
            {
                mainQueue.sync {
                    ToastView.toast.showToast(with : "Make sure device blutooth is on.")
                }
                self.cushionList.forEach{
                    $0.connected = 0
                }
            }
            
            if let target = self.delegate , target.responds(to: #selector(BluetoothManagerDelegate.updateState(_:)))
            {
                mainQueue.async {
                    target.updateState!(self.myCentral.state)
                }
                
            }
            
        }
        }
    }
    
    func setup()   {
        self.cushionList = Cushion.getAllCushions().map{CushionServer.init(name: $0.name, identifier: $0.cushionUUID)}
    }
    
    
    private var  savedCushionsIDs : [String] {return Cushion.getAllCushions().compactMap{$0.cushionUUID}}
    func scanPeripheral(_ connect : Bool) {
        stopScanning()
        
        (myCentral.peripherals as? [RKPeripheral])?.forEach { (cushion : RKPeripheral) in
            if savedCushionsIDs.contains(cushion.identifier.uuidString)
            {
                self.myCentral.cancelPeripheralConnection(cushion, onFinished: {[weak self] (peripheral, error) in
                    guard let `self` = self else {return}
                    self.myCentral.peripherals.remove(cushion)
                })
            }
        }
        
        if myCentral.state == .poweredOn
        {
            
            let options =  [CBCentralManagerScanOptionAllowDuplicatesKey : false]
            let services = [Device.cushionUDID]
            
            myCentral.scanForPeripherals(withServices: services, options: options) {[weak self] (peripheral) in
                mainQueue.sync {
                    LoaderView.shared.hideLoader()
                }
                guard let `self` = self , let cushion = peripheral else {return}
                if cushion.state == .disconnected
                {
                    if self.savedCushionsIDs.contains(cushion.identifier.uuidString) && connect
                    {
                        self.connectCushion(cushion)
                    }
                
                    if let target = self.delegate , target.responds(to: #selector(BluetoothManagerDelegate.foundCushion(_:)))
                    {
                        mainQueue.async {
                            target.foundCushion!(cushion)
                        }
                        
                    }
                }
            }
        }
        
    }
    
    func stopScanning()  {
        self.myCentral.stopScan()
    }
    
   @objc  func connectCushion(_ cushion : RKPeripheral)
    {
        if cushion.state == .connected {return}
        myCentral.connectPeripheral(cushion, options: [:], onFinished: {[weak self] (peripheral, error) in
            guard let `self` = self else {return}
            self.connectService(for: peripheral!)
        }) {[weak self] (peripheral, error) in
            
            guard let `self` = self ,  let index = self.savedCushionsIDs.index(of: peripheral?.identifier.uuidString ?? "") else {return}
            
            self.perform(#selector(self.connectCushion(_:)), with: peripheral, afterDelay: 0.5)
            
            if let target = self.delegate , target.responds(to: #selector(BluetoothManagerDelegate.didCushionDisconnect(_:)))
            {
                mainQueue.async {
                    [weak self] in
                    guard let `self` = self else {return}
                target.didCushionDisconnect!(self.cushionList[index])
                }
            }
            
        }
        
    }
   
    private func connectService(for peripheral : RKPeripheral)
    {
       
        peripheral.discoverServices(nil) {[weak self] (error) in
            guard let `self` = self else {return}
            
            self.connectCharacteristics(for: peripheral)
        }
    }
    
    private func connectCharacteristics(for peripheral : RKPeripheral)
    {
       if let service = peripheral.peripheral.service(with: Device.GATT_SERVICE)
       {
        self.cushionService = service
        peripheral.discoverCharacteristics(nil, for: service) {[weak self] (service, error) in
            guard let `self` = self else {return}
           
            self.requestDataCharacteristic = self.cushionService?.characteristic(with: Device.REQUEST_CHAR_UDID)
            self.eventOrientedCharacteristic = self.cushionService?.characteristic(with: Device.EVENT_ORIENTED_UDID)
            self.logDataCharacteristic = self.cushionService?.characteristic(with: Device.LOG_UDID)
            self.rtcCharacteristic = self.cushionService?.characteristic(with: Device.RTC_UPDATE_UDID)
            self.deviceConfCharacteristic = self.cushionService?.characteristic(with: Device.DEVICE_CONFIG_UDID)
            
            service?.characteristics?.forEach({ (charac) in
                self.cushionCharacterstics += [charac]
                
                if charac.properties.contains(.read)
                {
                    peripheral.readValue(for: charac, onFinish: {[weak self]   (character, error) in
                        guard let `self` = self else {return}
                        self.getValueFromDevice(for: character , peripheral: peripheral)
                    })
                }
                
                if charac.properties.contains(.notify)
                {
                    peripheral.setNotifyValue(true, for: charac, onUpdated: {[weak self] (character, error) in
                        guard let `self` = self else {return}
                        self.getValueFromDevice(for: character , peripheral: peripheral)
                    })
                }
               
                
               
            })
            
            
        }
        

        
    }
    }
    
    
    private func getValueFromDevice(for characteristic : CBCharacteristic? , peripheral : RKPeripheral)
    {
        guard let character = characteristic else {return}
        
        let foundCushionsIDs = self.cushionList.compactMap{$0.identifier}
        
        let cushion : CushionServer
        if let index = foundCushionsIDs.index(of: peripheral.identifier.uuidString)
        {
            cushion = self.cushionList[index]
        }
        else
        {
            cushion = CushionServer()
        }
        cushion.peripheral = peripheral
        cushion.charaterstics = character
        
        switch character.uuid {
        case Device.DEVICE_CONFIG_UDID:
            cushion.getDeviceID()
            
            cushion.charaterstics = self.requestDataCharacteristic
            cushion.getSettings {[weak self] (success) in
                guard let `self` = self else {return}
                if success { self.updateCushion(cushion)}
            }
            
        case Device.REQUEST_CHAR_UDID: break
        case Device.EVENT_ORIENTED_UDID:
            cushion.parseSettings(character.value)
            
            cushion.charaterstics = self.rtcCharacteristic
            cushion.updateRTC()
            
        case Device.LOG_UDID :
            if let value = character.value
            {
                let bytes = [UInt8](value)
                if logSize == 0
                {
                    logSize = Int(bytes[1])
                }
                if logCountSize < logSize
                {
                    logCountSize += 1
                    cushion.charaterstics = self.requestDataCharacteristic
                    cushion.readLogsData()
                }
             
            }
            
            
        case Device.RTC_UPDATE_UDID : break
        default:
            break
        }
        updateCushion(cushion)
        
    }
    
    
    func updateCushion(_ cushion : CushionServer)  {
        if let target = self.delegate , target.responds(to: #selector(BluetoothManagerDelegate.didCushionConnect(_:)))
        {
            mainQueue.sync {
                 target.didCushionConnect!(cushion)
            }
           
        }
    }

    
}

//MARK: A Cushion Device Class

import Alamofire

@objc
protocol CushionServerDelegate : NSObjectProtocol {
    @objc optional func connectedDidChange(_ server : CushionServer)
    @objc optional func cushionTimerStarted(_ server : CushionServer)
    @objc optional func cushionTimerStopped(_ server : CushionServer)
}



var stepCount = ""
typealias FlagBlock = (Int)->()
typealias DictBlock = ([String : Any])->()
typealias CommandBlock = (Data?)->()
class CushionServer: NSObject {
    private var flagclosure : FlagBlock?
    private var dictClosure : DictBlock?
    private var commandClosure : CommandBlock?
    
    
    
    
    var deviceID = ""
    var deviceName = ""
    var identifier = ""
    var state : Int = 0
    var vibration : Bool = false
    var notified : Int = 0
    var  battery : Int = 0
    var  chargerFlag : Int = 0
  
    var rtcTimeStamp : TimeInterval = 0.0
    var sittingInterVal : Double = 0.0
    
    var  cushionStatus : Int = 0
    {
        didSet{
            
            
            if cushionStatus == 1
            {
                updateTime = Date()
                
                mainQueue.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.cushionTimerStarted(true)
                }
            }
            if cushionStatus == 0 && updateTime != nil
            {
                  self.sittingInterVal = Double(Calendar.current.dateComponents([.minute], from: updateTime!, to: Date()).minute ?? 0)
                removeNotification(notification: .forgroundUpdate)
                addNotification(notification: .forgroundUpdate, selector: #selector(updateCushionUsageDataInBackGround(_:)))
//                mainQueue.async {
//                    [weak self] in
//                    guard let `self` = self else {return}
//                    self.cushionTimerStarted(false)
//                }
                
               
                
                if let currentCushion = Cushion.getCushion(for: self.identifier)
                {
                    mainQueue.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        currentCushion.addSittingTime(for: Date(), sittingTime: self.sittingInterVal)
                        self.cushionTimerStarted(false)
                    }
                }
                updateTime = nil
            }
            
            debugLogs()
        }
    }
    var  motorFault : Int = 0
    var  powerFlag : Int = 0
    var  alertFlag : Int = 0
    {
        didSet {
            self.vibration = alertFlag == 0 ? false : true
        }
    }
    var  alerttime : Int = 0
    var peripheral : RKPeripheral?
    {
        didSet{
            if let cushion = peripheral
            {
                if self.deviceName.isEmpty {self.deviceName = cushion.name}
                
                self.identifier = cushion.identifier.uuidString
            }
        }
    }
    init(name : String? , identifier : String?)
    {
        self.identifier = identifier ?? ""
        self.deviceName = name ?? ""
        
    }
    convenience override init() {
        self.init(name: nil, identifier: nil)
    }
    var charaterstics : CBCharacteristic?
   weak var delegate : CushionServerDelegate?
    
   
    
  private  func sendCommand(_ input : Data , _ closure : @escaping CommandBlock)  {
        commandClosure = nil
        commandClosure = closure
        
        guard let cushion = self.peripheral , cushion.state == .connected , let characterstic = self.charaterstics else {return}
        cushion.writeValue(input, for: characterstic, type: .withResponse) { (characte, error) in
          debugPrint(error?.localizedDescription ?? "No error" )
            
            closure(characte?.value)
        }
        
    }
    
    func updateRTC()  {
        let timestamp = Int64(Date().timeIntervalSince1970 * 1000)
       
        let bytes = [UInt64(timestamp >>> 32) , UInt64(timestamp >>> 16) , UInt64(timestamp >>> 8) , UInt64(timestamp)]
      self.rtcTimeStamp = Double(timestamp)
        let command = Data(bytes: bytes, count: bytes.count)
        sendCommand(command) { (data) in

        }
    }
    
    func startReadingLogSize(_  flag : @escaping FlagBlock)
    {
        let bytes : [UInt8] = [0x04]
        let commandData = Data(bytes: bytes, count: bytes.count)
        sendCommand(commandData) { (data) in
            
        }
    }
    
    func getDeviceID()
    {
        let bytes : [UInt8] = [0x02]
        let commandData = Data(bytes: bytes, count: bytes.count)
        sendCommand(commandData) {[weak self] (data) in
            guard let `self` = self , let value = data else {return}
           let bytes = [UInt8](value)
            let valueInString = bytes.map{String.localizedStringWithFormat("%d", $0)}.joined(separator: "")
            self.deviceID = valueInString
        }
    }
    
    func readLogsData()  {
        let bytes : [UInt8] = [0x05]
        let commandData = Data(bytes: bytes, count: bytes.count)
        sendCommand(commandData) { (data) in
            if let data = data
            {
                let bytes = [UInt8](data)
                debugPrint(bytes)
            }
        }
    }
    func getSettings(_ flag : @escaping (Bool)->())
    {
        let bytes : [UInt8] = [0x03]
        let commandData = Data(bytes: bytes, count: bytes.count)
        sendCommand(commandData) {[weak self] (data) in
            guard let `self` = self else {flag(false) ; return}
            self.connected = 1
            flag(true)
        }
    }
    func setViberation(_ on : Bool , _ flag : @escaping FlagBlock)
    {
        guard let character = self.charaterstics else {return}
        
        var commandData = Data()
        var bytes  = [UInt8](character.value ?? Data())
        
        let vibState = (bytes[0] >> 7) & 1
        let newState : UInt8 = on ? 1 : 0
        
        if vibState != newState
        {
            bytes[0] = newState == 1 ?  (bytes[0] | (1 << 7)) : (bytes[0]  &  ~(1 << 7))
        }
        
        commandData.append(bytes, count: bytes.count)
      
        sendCommand(commandData) { [weak self](data) in
            guard let `self` = self else {return}
            guard let output = data  else {flag(0) ; return}
            let commandBytes = [UInt8](output)
            self.vibration = Int((commandBytes[0] >> 7) & 1) == 0 ?  false : true
            flag(Int((commandBytes[0] >> 7) & 1))
          
        }
        
    }
    
    func setAdvInterval(_ interval : Int , _ flag : @escaping FlagBlock)  {
         guard let character = self.charaterstics else {return}
        
        if let data = character.value
        {
             var commandData = Data()
            var bytes = [UInt8](data)
            bytes[1] = UInt8(interval)
             commandData.append(bytes, count: bytes.count)
            sendCommand(commandData) { (output) in
                guard let output = output else {
                    flag(0)
                    return
                }
                let bytes = [UInt8](output)
                flag( Int(bytes[1]))
            }
        }
        
    }
    
    // need to implement charging status
    func parseSettings( _ data : Data?)  {
        if let recievedData = data
        {
            let bytes = [UInt8](recievedData)
             chargerFlag  = Int((bytes[0] >> 0) & 1)
            
              motorFault  = Int((bytes[0] >> 2) & 1)
              powerFlag  = Int((bytes[0] >> 6) & 1)
              alertFlag  = Int((bytes[0] >> 7) & 1)
            
             alerttime = Int(bytes[1])
            self.battery = Int(bytes[2])
             cushionStatus  = Int((bytes[0] >> 1) & 1)
            self.updateCushionData()
        }
    }
    
    private func debugLogs()
    {
        mainQueue.async {
             debugPrint(UIApplication.shared.applicationState == .background ? "Background mode" : "Forground mode")
        }
        debugPrint("charger is connected  \(chargerFlag == 0 ? "Not charging" : "Charging")")
        debugPrint("Cushion Status is  \(cushionStatus == 0 ? "Not occupied" : "occupied")")
        debugPrint("Motor fault is  \(motorFault == 0 ? "Motor fine" : "Motor Fault Occured")")
        debugPrint("Power status is  \(powerFlag == 0 ? "Power on" : "Going to sleep")")
        debugPrint("Device alert status is  \(alertFlag == 0 ? "Viberation Off" : "Viberation On")")
        debugPrint("Alert time is  \(alerttime) minutes")
        debugPrint("Battery is   \(battery) %")
        debugPrint("Device ID is   \(deviceID)")
    }

    
   
    
    var connected : Int? = nil

    private func updateCushionData()
    {
        if let target = self.delegate , target.responds(to: #selector(CushionServerDelegate.connectedDidChange(_:)))
        {
            mainQueue.async {
                target.connectedDidChange!(self)
            }
            
        }
    }
    
    private func cushionTimerStarted(_ isStarted : Bool)
    {
        if let target = self.delegate , target.responds(to: #selector(CushionServerDelegate.cushionTimerStarted(_:))) , target.responds(to: #selector(CushionServerDelegate.cushionTimerStopped(_:)))
        {
            mainQueue.async {
                isStarted ?  target.cushionTimerStarted!(self) :   target.cushionTimerStopped!(self)
            }
            
        }
    }
     var updateTime : Date?
    
    
    @objc func updateCushionUsageDataInBackGround(_ noti : Notification)
    {
        removeNotification(notification: .forgroundUpdate)
        if let completionHandele = noti.object as? (UIBackgroundFetchResult) -> Void
        {
          
            let cushion = Cushion.getCushion(for: self.identifier)
          let  totalTime = cushion?.getSittingInfo(of: Date())?.timeIntervals.reduce(0, +) ?? self.sittingInterVal
            
            let requestModel = CushionTransaction(userid: userEmailID, cid: self.identifier, cushionname: self.deviceName, date: Date().getString(for: "dd/MM/yyyy"), averagesittingtime: "\(self.sittingInterVal)", stepcount: stepCount , totaltime : "\(totalTime)" , alerttime : "\(alerttime)")
            do {
                let data =   try JSONEncoder().encode(requestModel)
                let parameters = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String : Any]
                Alamofire.request(CUSHION_TRANSACTION_UPDATE.getFullURL, method: .post, parameters: parameters).validate().responseJSON { (response) in
                    completionHandele(.newData)
                }
            }
            catch
            {
                 completionHandele(.failed)
            }
          
        }
    }
    
}
extension CBPeripheral {
    
    /// Find a service on a peripheral by CBUUID.
    public func service(with uuid: CBUUID) -> CBService? {
        return services?.first(where: { $0.uuid == uuid })
    }
    
}

extension CBService {
    
    /// Find a characteristic on a service by CBUUID.
    public func characteristic(with uuid: CBUUID) -> CBCharacteristic? {
        return characteristics?.first(where: { $0.uuid == uuid })
    }
    
}
