//
//  ViewController.m
//  Cal
//
//  Created by stay hungry,stay foolish on 14-12-3.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ViewController.h"
#import "CalculationModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) CalculationModel *calculationModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.calculationModel = [[CalculationModel alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateResult:(UIButton *)sender
{
    [self.calculationModel calculateResultWithString:self.textField.text];
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    self.textField.text = [self.textField.text stringByAppendingString:sender.titleLabel.text];
}



@end
