//
//  PickerModel.h
//  IOSCustomViews
//
//  Created by Jeevan on 21/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerModel : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;

-(instancetype) initWithKey:(NSString *) key andValue:(NSString *) value;

@end
