//
//  CustomePickerView.h
//  IOSCustomViews
//
//  Created by Jeevan on 21/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PickerModel.h"

@class CustomePickerView;

@protocol customePickerViewDelegates <NSObject>

@optional
 
-(void)customPickerView:(CustomePickerView *)pickerView selectedPickerModel:(PickerModel *) model;

@end

@interface CustomePickerView : NSObject

-(void) createPickerForTextField:(UITextField *) field;

@property (assign) BOOL isInputKeyboardEnabled;

@property (strong, nonatomic) UITextField *pickerTextField;

@property (strong,nonatomic) NSMutableArray * loadedPickerModelArray;

@property (weak) id<customePickerViewDelegates> delegate;

@property (strong,nonatomic) UIPickerView * pickerView;
    
-(void) searchString:(NSString *) string;

-(void) reloadPickerView;
    
@end
