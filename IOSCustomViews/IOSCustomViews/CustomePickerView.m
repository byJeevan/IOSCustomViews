//
//  CustomePickerView.m
//  IOSCustomViews
//
//  Created by Jeevan on 21/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import "CustomePickerView.h"
#import "PickerModel.h"

@interface CustomePickerView ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate> {
    UITextField *pickerTextField;
    UIPickerView  *pickerView;
}

@property (strong) NSMutableArray * filteredArray;

@end

@implementation CustomePickerView

-(void) createPickerForTextField :(UITextField *) field {
    
    pickerTextField = field;
    pickerTextField.delegate = self;
    pickerView =  [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [pickerView addGestureRecognizer:tapToSelect];
    
    self.filteredArray = [NSMutableArray arrayWithArray:self.loadedPickerModelArray];
    
    [self toolBarForPicker];

}

#pragma mark - Actions

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [pickerView rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(pickerView.bounds, 0.0, (CGRectGetHeight(pickerView.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:pickerView]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            [self pickerView:pickerView didSelectRow:selectedRow inComponent:0];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}



-(void)pickerTapped:(id)sender
{
    NSLog(@"Picker tapped");
}

-(void) toolBarForPicker {
    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, 0, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    
    //Done button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done)];
    
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    
    if (self.isInputKeyboardEnabled) {
        pickerTextField.inputView =  UIKeyboardTypeDefault;
       
        [pickerTextField.superview addSubview:pickerView];
        
    }
    else{
        
        pickerTextField.inputView =  pickerView;
        
        pickerTextField.inputAccessoryView = toolBar;
    }
   
}

-(void) done {
    
    NSString *titleYouWant = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
    pickerTextField.text = titleYouWant;
    
    [self exitPickerView];
    
}

-(void) exitPickerView {
    
    if (self.isInputKeyboardEnabled) {
//        [pickerView removeFromSuperview];
        
        pickerView.hidden = YES;
    }
    else{
        
        [pickerTextField endEditing:YES];
    }
    
}


-(void) startPickerView {
    
    pickerView.hidden = NO;
}

-(void) searchString:(NSString *) string {
    
    [self startPickerView];
    
    if ([string isEqualToString:@""]) {
        
        self.filteredArray = [[NSMutableArray alloc] initWithArray:self.loadedPickerModelArray];
        [pickerView reloadAllComponents];
        
        return;
    }
    
    [self.filteredArray removeAllObjects];
    
    NSOperationQueue * queueForAutoComplete = [[NSOperationQueue alloc] init];
    
    [queueForAutoComplete addOperationWithBlock:^{
        
        BOOL isStringEqual  = NO;
        
        for (PickerModel * pickerModelItemAtIndex in self.loadedPickerModelArray) {
            
            NSString *  pickertring = pickerModelItemAtIndex.value;
            
            NSRange subStringRange = [[pickertring lowercaseString] rangeOfString:string.lowercaseString];
            
            if (subStringRange.location == 0) {
                [self.filteredArray addObject:pickerModelItemAtIndex];
            }
            
            //if typed string == picker string,
            if ([string.lowercaseString isEqualToString:pickertring.lowercaseString]) {
                isStringEqual = YES;
            }
            
        }
        
        //Main thread - update pickerview
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if ( self.filteredArray.count < 1) {
                
                [self exitPickerView];
                
            }
            else {
                [pickerView reloadAllComponents];
                
            }
            
            if (isStringEqual) {
                
            }
            
        }];
        
        
    }];
    
}


#pragma mark - Text Field
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
     [pickerTextField endEditing:YES];
    [self exitPickerView];
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    [self startPickerView];
    
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
 
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self searchString:newString];
    return YES;
}


#pragma mark - Picker View
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return  self.filteredArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    PickerModel * model = [self.filteredArray objectAtIndex:row];
    return model.value;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    PickerModel * model = [self.filteredArray objectAtIndex:row];
    pickerTextField.text = model.value;
    
   
}

@end
