//
//  CustomSegmentControl.h
//  InterviewCustomControl
//
//  Created by Alexander Devin on 16.06.16.
//  Copyright © 2016 Alexander Devin. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomSegmentControl : UIControl

@property (assign, nonatomic) IBInspectable NSUInteger selectedIndex;
@property (assign, nonatomic) IBInspectable NSUInteger segmentsCount;

-(BOOL)addSegmentWithTitle:(NSString *)segmentTitle;
-(BOOL)insertSegment:(NSString *)segmentTitle atIndex:(NSInteger)segmentIndex;
-(BOOL)removeSegmentAtIndex:(NSInteger)segmentIndex;
-(BOOL)removeAllSegments;

@end
