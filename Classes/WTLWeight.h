//
//  WTLWeight.h
//  Weightly
//
//  Created by Yiming Tang on 11/13/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import <SSDataKit/SSManagedObject.h>

@interface WTLWeight : SSManagedObject

@property (nonatomic) float amount;
@property (nonatomic) NSDate *timeStamp;
@property (nonatomic) NSString *sectionIdentifier;
@property (nonatomic) BOOL userGenerated;

@end
