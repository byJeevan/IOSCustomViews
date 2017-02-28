//
//  CustomePickerView.h
//  IOSCustomViews
//
//  Created by Jeevan on 21/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol customePickerViewDelegates <NSObject>

@optional
-(void) didSelectedValue:(NSString *) value ofKey:(NSString *)key;

//-(BOOL) isTextEntred;


@end


@interface CustomePickerView : NSObject

-(void) createPickerForTextField:(UITextField *) field;
-(void) searchString:(NSString *) string;
-(void) reloadPickerView;
@property (assign) BOOL isInputKeyboardEnabled;

@property (strong,nonatomic) UIPickerView * pickerView;

@property (strong,nonatomic) NSMutableArray * loadedPickerModelArray;

@property (weak) id<customePickerViewDelegates> delegate;

@end
