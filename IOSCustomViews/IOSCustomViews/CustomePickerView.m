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

}

@property (strong) NSMutableArray * filteredArray;

@end

@implementation CustomePickerView

-(void) createPickerForTextField :(UITextField *) field {
    
    pickerTextField = field;
    pickerTextField.delegate = self;
    self.pickerView =  [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [self.pickerView addGestureRecognizer:tapToSelect];
    self.filteredArray = [NSMutableArray arrayWithArray:self.loadedPickerModelArray];
    self.pickerView.hidden = YES;
    [self toolBarForPicker];

}

#pragma mark - Actions

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [self.pickerView rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(self.pickerView.bounds, 0.0, (CGRectGetHeight(self.pickerView.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:self.pickerView]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
            [self pickerView:self.pickerView didSelectRow:selectedRow inComponent:0];
            [self exitPickerView];
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
       
        [pickerTextField.superview addSubview:self.pickerView];
        
    }
    else{
        
        pickerTextField.inputView =  self.pickerView;
        
        pickerTextField.inputAccessoryView = toolBar;
    }
   
}

-(void) done {
    
    [self exitPickerView];
}

-(void) exitPickerView {
    
    if (self.isInputKeyboardEnabled) {
        
        self.pickerView.hidden = YES;
    }
    else{
        
        [pickerTextField endEditing:YES];
    }
    
}


-(void) startPickerView {
    
    self.pickerView.hidden = NO;
}

-(void) searchString:(NSString *) string {
    
    [self startPickerView];
    
    if ([string isEqualToString:@""]) {
        
        self.filteredArray = [[NSMutableArray alloc] initWithArray:self.loadedPickerModelArray];
        [self.pickerView reloadAllComponents];
        
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
                [self.pickerView reloadAllComponents];
                
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
    
    if (self.filteredArray.count > 0) {
        
        PickerModel * model = [self.filteredArray objectAtIndex:row];
        
        return model.value;
        
    }
 
    return @"";
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.filteredArray.count > 0) {
        
        PickerModel * model = [self.filteredArray objectAtIndex:row];
        
        pickerTextField.text = model.value;
    }
    else {
        pickerTextField.text =  @"";
        
    }
   
}

@end
