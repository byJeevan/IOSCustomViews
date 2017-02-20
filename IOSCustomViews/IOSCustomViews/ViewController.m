//
//  ViewController.m
//  IOSCustomViews
//
//  Created by Jeevan on 16/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
     UIPickerView *pickerView;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong) NSArray * arrayOfElements;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.delegate = self;
    pickerView =  [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.hidden = YES;
    
     self.arrayOfElements =[[NSArray alloc] initWithObjects:@"One", @"Two", @"Three", @"Four",  @"Five",  @"Six",  @"Seven",  @"eight",  @"nine",  @"ten",  @"eleven",  @"twele",  @"gdfgdfg",  nil];
 
    pickerView.showsSelectionIndicator = YES;

    [self toolBarForPicker];
    
    
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
    
    pickerView.hidden = YES;
    [self.view endEditing:YES];
}

-(void) dateChanged:(NSString *) dataChange {
    
}

#pragma mark - Text Field
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    pickerView.hidden = NO;
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    pickerView.hidden = YES;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        [self dateChanged:nil];
    }
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
}


#pragma mark - Picker View
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return  self.arrayOfElements.count;
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title;
    title=[self.arrayOfElements objectAtIndex:row];
    return title;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *resultString = self.arrayOfElements[row];
    
    self.textField.text = resultString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
