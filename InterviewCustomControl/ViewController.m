//
//  ViewController.m
//  InterviewCustomControl
//
//  Created by Alexander Devin on 16.06.16.
//  Copyright © 2016 Alexander Devin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CustomSegmentControl *control;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.control removeAllSegments];
    [self.control addSegmentWithTitle:@"10"];
    [self.control insertSegment:@"2" atIndex:1];
    [self.control removeSegmentAtIndex:0];
    [self.control addSegmentWithTitle:@"boOm"];
    [self.control addSegmentWithTitle:@"7"];
    [self.control insertSegment:@"1" atIndex:0];
    [self.control insertSegment:@"2" atIndex:1];
    
}

- (IBAction)changed:(id)sender {
    
    CustomSegmentControl *control = (CustomSegmentControl *)sender;
    NSLog(@"Selected segment index changed: %lu (message from listener)", (unsigned long)control.selectedIndex);
}

@end
