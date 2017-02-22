//
//  DependencyFieldViewController.m
//  IOSCustomViews
//
//  Created by Jeevan on 22/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//

#import "DependencyFieldViewController.h"
#import "CustomePickerView.h"

@interface DependencyFieldViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstField;
@property (weak, nonatomic) IBOutlet UITextField *secondField;

@end

@implementation DependencyFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstField.delegate = self;
    self.secondField.delegate = self;
    
    
   
}

- (IBAction)exitButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
