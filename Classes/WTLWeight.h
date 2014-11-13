//
//  WTLWeight.h
//  Weightly
//
//  Created by Yiming Tang on 11/13/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import CoreData;
@import Foundation;

@interface WTLWeight : NSManagedObject

@property (nonatomic) NSNumber *amount;
@property (nonatomic) NSDate *timeStamp;
@property (nonatomic) NSString *sectionIdentifier;

@end
