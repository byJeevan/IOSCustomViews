//
//  DependencyFieldViewController.m
//  IOSCustomViews
//
//  Created by Jeevan on 22/02/17.
//  Copyright © 2017 com.byjeevan. All rights reserved.
//
//Country : http://services.groupkt.com/country/get/all
// State : http://services.groupkt.com/state/get/%@/all

#import "DependencyFieldViewController.h"
#import "CustomePickerView.h"
#import "PickerModel.h"

@interface DependencyFieldViewController ()<UITextFieldDelegate, customePickerViewDelegates> {
    CustomePickerView * contryPicker;
    CustomePickerView * statePicker;
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *firstField;
@property (weak, nonatomic) IBOutlet UITextField *secondField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * activityIndicator;
@end

@implementation DependencyFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator stopAnimating];
    
    //Country
    contryPicker = [CustomePickerView new];
    contryPicker.isInputKeyboardEnabled = NO;
    self.firstField.delegate = self;
     contryPicker.delegate = self;
    [self setModelCountryArray];
    [contryPicker createPickerForTextField:self.firstField];
    contryPicker.pickerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    
    
    //State
    statePicker = [CustomePickerView new];
    statePicker.isInputKeyboardEnabled = NO;
    self.secondField.delegate = self;
    self.secondField.enabled  = NO;
//    statePicker.delegate = self;
    
    [statePicker createPickerForTextField:self.secondField];
    statePicker.pickerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9];
    
}

-(void) setModelCountryArray {
    
    contryPicker.loadedPickerModelArray = [[NSMutableArray alloc] initWithObjects:
                                             
                                             [[PickerModel alloc] initWithKey:@"1" andValue:@"USA"],
                                             [[PickerModel alloc] initWithKey:@"2" andValue:@"IND"],
                                             [[PickerModel alloc] initWithKey:@"3" andValue:@"PAK"],
                                             [[PickerModel alloc] initWithKey:@"4" andValue:@"FRA"],
                                             [[PickerModel alloc] initWithKey:@"5" andValue:@"AUS"],
                                             [[PickerModel alloc] initWithKey:@"6" andValue:@"CHN"],
                                             [[PickerModel alloc] initWithKey:@"7" andValue:@"RUS"],
                                             [[PickerModel alloc] initWithKey:@"8" andValue:@"JPN"],
                                             [[PickerModel alloc] initWithKey:@"9" andValue:@"SRL"],
                                             [[PickerModel alloc] initWithKey:@"10" andValue:@""],
                                             
                                             nil];
    
}


-(void) setModelStateArrayForCountryCode:(NSString *) countryCode {
    
    NSString * urlString = [NSString stringWithFormat:@"http://services.groupkt.com/state/get/%@/all",countryCode];
    [self.activityIndicator startAnimating];
    
    self.secondField.text = @"";

    [self getJsonResponse:urlString success:^(NSDictionary *responseDict) {

        NSDictionary * dictionaryRest = [responseDict valueForKey:@"RestResponse"];
        NSDictionary * dictionaryResult = [dictionaryRest valueForKey:@"result"];
        NSArray * arrayOfStateNames = [dictionaryResult valueForKey:@"name"];
        
        
        statePicker.loadedPickerModelArray = [[NSMutableArray alloc] init];
        for(int index=0; index<arrayOfStateNames.count; index++) {
            
            [statePicker.loadedPickerModelArray addObject:[[PickerModel alloc] initWithKey:[NSString stringWithFormat:@"%d",index+1]  andValue:[arrayOfStateNames objectAtIndex:index]]];
            
        }
    
     
            dispatch_async(dispatch_get_main_queue(), ^{
                [statePicker reloadPickerView];
                
                [self.activityIndicator stopAnimating];
            });    
        
  
    } failure:^(NSError *error) {
        // error handling here ...
         [self.activityIndicator stopAnimating];
    }];
    
}

-(void)getJsonResponse:(NSString *)urlStr success:(void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // Asynchronously API is hit here
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                //NSLog(@"%@",data);
                                                if (error)
                                                    failure(error);
                                                else {
                                                    NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                    //NSLog(@"%@",json);
                                                    success(json);
                                                }
                                            }];
    [dataTask resume];    // Executed First
}

-(void) didSelectedValue:(NSString *) value ofKey:(NSString *)key {
    
    [self setModelStateArrayForCountryCode:value];
   
    self.secondField.enabled = YES;
    
}

- (IBAction)exitButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    NSString * newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    [customerPicker searchString:newString];
    
    return YES;
}

@end
