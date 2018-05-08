//
//  RKPeripheral.h
//  ble-utility
//
//  Created by 北京锐和信科技有限公司 on 10/30/13.
//  Copyright (c) 2013 北京锐和信科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class RKPeripheral;
// central manager
typedef void(^RKCharacteristicChangedBlock)(CBCharacteristic * characteristic, NSError * error);
typedef void(^RKDescriptorChangedBlock)(CBDescriptor * descriptor, NSError * error);
typedef void(^RKSpecifiedServiceUpdatedBlock)(CBService * service,NSError * error);
typedef void(^RKObjectChangedBlock)(NSError * error);
typedef void(^RKServicesUpdated)(NSArray * services);
typedef void(^RKPeripheralUpdatedBlock)(RKPeripheral * peripheral);
typedef void(^RKPeripheralConnectionBlock)(RKPeripheral * peripheral,NSError * error);

//peripheral manager
typedef void(^RKPeripheralManagerStatedChnagedBlock)(NSDictionary * state);
typedef void(^RKCentralSubscriptionBlock)(CBCentral * central,CBCharacteristic * characteristic);
typedef void(^RKCentralReadRequestBlock)(CBATTRequest * readRequest);
typedef void(^RKCentralWriteRequestBlock)(NSArray * writeRequests);

@interface RKPeripheral : NSObject
@property (nonatomic,strong,readonly) CBPeripheral * peripheral;
@property (nonatomic,weak) NSArray * services;
@property(nonatomic,strong) NSUUID *identifier;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *RSSI;
@property (readonly) CBPeripheralState state;
@property (nonatomic,copy) RKServicesUpdated onServiceModified;
@property (nonatomic,copy) RKObjectChangedBlock onNameUpdated;
@property (nonatomic,copy) RKCharacteristicChangedBlock notificationStateChanged;
@property (nonatomic,copy)RKPeripheralConnectionBlock onConnectionFinished;
@property (nonatomic,copy)RKPeripheralConnectionBlock onDisconnected;
- (instancetype)initWithPeripheral:(CBPeripheral *) peripheral;

#pragma mark discovery services

- (void)discoverServices:(NSArray *)serviceUUIDs onFinish:(RKObjectChangedBlock) discoverFinished;
- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service onFinish:(RKSpecifiedServiceUpdatedBlock) finished;

#pragma mark Discovering Characteristics and Characteristic Descriptors

- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service onFinish:(RKSpecifiedServiceUpdatedBlock) onfinish;
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic onFinish:(RKCharacteristicChangedBlock) onfinish;

#pragma mark Reading Characteristic and Characteristic Descriptor Values

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic onFinish:(RKCharacteristicChangedBlock) onUpdate;
- (void)readValueForDescriptor:(CBDescriptor *)descriptor onFinish:(RKDescriptorChangedBlock) onUpdate;

#pragma mark Writing Characteristic and Characteristic Descriptor Values
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type onFinish:(RKCharacteristicChangedBlock) onfinish;
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor onFinish:(RKDescriptorChangedBlock) onfinish;

#pragma mark Setting Notifications for a Characteristic’s Value

- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic onUpdated:(RKCharacteristicChangedBlock) onUpdated;

#pragma mark ReadRSSI

- (void)readRSSIOnFinish:(RKObjectChangedBlock) onUpdated;
@end
