//
//  ViewController.m
//  IOSCustomViews
//
//  Created by Jeevan on 16/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import "ViewController.h"
#import "CustomePickerView.h"
#import "PickerModel.h"

@interface ViewController () <UITextFieldDelegate> {
    CustomePickerView * customerPicker;
    NSMutableArray * inputArray;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    customerPicker = [CustomePickerView new];
    customerPicker.isInputKeyboardEnabled = NO;
    self.textField.delegate = self;

    customerPicker.loadedPickerModelArray = [[NSMutableArray alloc] initWithObjects:
                                   [[PickerModel alloc] initWithKey:@"1" andValue:@"One"],
                                   [[PickerModel alloc] initWithKey:@"2" andValue:@"Two"],
                                   [[PickerModel alloc] initWithKey:@"3" andValue:@"Three"],
                                   [[PickerModel alloc] initWithKey:@"4" andValue:@"Four"],
                                   [[PickerModel alloc] initWithKey:@"5" andValue:@"Five"],
                                   [[PickerModel alloc] initWithKey:@"6" andValue:@"Six"],
                                   [[PickerModel alloc] initWithKey:@"7" andValue:@"Seven"],
                                   [[PickerModel alloc] initWithKey:@"8" andValue:@"Eight"],
                                   [[PickerModel alloc] initWithKey:@"9" andValue:@"Nine"],
                                   nil];
    
    
    [customerPicker createPickerForTextField:self.textField];
    
}


#pragma mark - Text Field
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
 
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
 
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [customerPicker searchString:newString];
    return YES;
}


 
@end
