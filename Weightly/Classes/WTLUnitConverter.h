//
//  WTLUnitConverter.h
//  Weightly
//
//  Created by Yiming Tang on 11/12/14.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

@import Foundation;

@interface WTLUnitConverter : NSObject

- (float)convertMassFromKgToLb:(float)amount;
- (float)convertMassFromLbToKg:(float)amount;
- (float)convertLengthFromCmToInch:(float)length;
- (float)convertLengthFromInchToCm:(float)length;

@end
