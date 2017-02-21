//
//  ViewController.m
//  IOSCustomViews
//
//  Created by Jeevan on 16/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import "ViewController.h"
#import "PickerModel.h"

@interface ViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate> {
    UIPickerView *pickerView;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong) NSMutableArray * loadedPickerModelArray;
@property (strong) NSMutableArray * filteredArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.delegate = self;
    pickerView =  [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
 
    self.loadedPickerModelArray = [[NSMutableArray alloc] initWithObjects:
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
                          CGRectMake(0, self.view.frame.size.height -
                                     pickerView.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    
    //Done button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done)];
    
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    self.textField.inputView =  pickerView;
    
    self.textField.inputAccessoryView = toolBar;
}

-(void) done {
    
    NSString *titleYouWant = [self pickerView:pickerView titleForRow:[pickerView selectedRowInComponent:0] forComponent:0];
    self.textField.text = titleYouWant;
    
  [self exitPickerInputViewFocused:NO];
    
}


-(void) textChanged:(NSString *) dataChange {
    
}

-(void) exitPickerInputViewFocused:(BOOL) isFocused {
    
    if (isFocused) {
        
      
    }
    else{
        
        [self.view endEditing:YES];
    }
    
}

-(void) searchString:(NSString *) string {
    
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
    if ([textField.text isEqualToString:@""]) {
        [self textChanged:nil];
    }
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
    self.textField.text = model.value;
    
    [self exitPickerInputViewFocused:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
