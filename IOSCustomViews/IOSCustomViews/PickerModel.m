
//
//  PickerModel.m
//  IOSCustomViews
//
//  Created by Jeevan on 21/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import "PickerModel.h"

@implementation PickerModel

-(instancetype) initWithKey:(NSString *) key andValue:(NSString *) value {
    
    if (self = [super init]) {
        self.key = key;
        self.value = value;
    }
    
    return self;
    
}

@end
