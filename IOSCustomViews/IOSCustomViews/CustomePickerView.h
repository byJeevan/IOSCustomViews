//
//  CustomePickerView.h
//  IOSCustomViews
//
//  Created by Jeevan on 21/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomePickerView : NSObject

-(void) createPickerForTextField:(UITextField *) field;
-(void) searchString:(NSString *) string;

@property (assign) BOOL isInputKeyboardEnabled;
@property (strong,nonatomic) UIPickerView * pickerView;
 @property (strong,nonatomic) NSMutableArray * loadedPickerModelArray;
@end
