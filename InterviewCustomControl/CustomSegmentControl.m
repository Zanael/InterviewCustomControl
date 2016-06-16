//
//  CustomSegmentControl.m
//  InterviewCustomControl
//
//  Created by Alexander Devin on 16.06.16.
//  Copyright © 2016 Alexander Devin. All rights reserved.
//

#import "CustomSegmentControl.h"

IB_DESIGNABLE
@interface CustomSegmentControl ()

//MARK: IBInspectable

@property (assign, nonatomic) IBInspectable NSUInteger fontSize;
@property (strong, nonatomic) IBInspectable UIColor *textColor;
@property (strong, nonatomic) IBInspectable UIColor *backgroundColor;

//MARK: Layout stuff declaration

@property (strong, nonatomic) NSMutableArray<NSString *> *titles;
@property (strong, nonatomic) NSMutableArray<UILabel *> *labels;
@property (weak, nonatomic) IBOutlet UIView *labelsContainer;
@property (strong, nonatomic) UIView *solidLine;
@property (strong, nonatomic) NSMutableArray<NSLayoutConstraint *> *widthConstraints;

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSLayoutConstraint *containerWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *containerHeightConstraint;

@end

IB_DESIGNABLE
@implementation CustomSegmentControl

//MARK: Propery custom setters

-(NSUInteger)segmentsCount {
    return self.titles.count;
}

-(void)setSegmentsCount:(NSUInteger)segmentsCount {
    @synchronized (self) {
        
        [self.titles removeAllObjects];
        
        for (int i = 0; i < segmentsCount; i++) {
            [self.titles addObject:[NSString stringWithFormat:@"%d", i + 1]];
        }
        [self setupLabels];
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self displaySelectedItem];
}

//MARK: initializers

- (instancetype)init {
    
    if (self == [super init]) {
        [self initializeAllStuff];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeAllStuff];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initializeAllStuff];
    }
    
    return self;
}

- (void)initializeAllStuff {
    
    self.titles = [NSMutableArray<NSString *> new];
    self.labels = [NSMutableArray<UILabel *> new];
    self.widthConstraints = [NSMutableArray<NSLayoutConstraint *> new];
    [self addTarget:self action:@selector(internalEventValueChangedProcessor) forControlEvents:UIControlEventValueChanged];
    [self load];
}

//MARK: Build layout methods

- (void)load {
    
    [self setNeedsLayout];
    [self.labelsContainer setNeedsLayout];
    
    [self.titles addObject:@"1"];
    [self.titles addObject:@"3"];
    [self.titles addObject:@"6"];
    
    self.container = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"CustomSegmentControl" owner:self options:nil] firstObject];
    [self addSubview:self.container];
    self.container.frame = self.bounds;
    self.container.userInteractionEnabled = NO;
    
    [CustomSegmentControl removeAllConstraintsFromView:self.container];
    
    NSLayoutConstraint *horizontalCenterConstraint = [NSLayoutConstraint constraintWithItem:self.labelsContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *verticalCenterConstraint = [NSLayoutConstraint constraintWithItem:self.labelsContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.container attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    self.containerWidthConstraint = [NSLayoutConstraint constraintWithItem:self.labelsContainer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:200];
    
    self.containerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.labelsContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:100];
    
    [self.container addConstraint:horizontalCenterConstraint];
    [self.container addConstraint:verticalCenterConstraint];
    [self.container addConstraint:self.containerWidthConstraint];
    [self.container addConstraint:self.containerHeightConstraint];
    
    [self setupLabels];
}

- (void)setupLabels {
    
    for (int i = 0; i < self.labels.count; i++) {
        [self.labels[i] removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
    [self.widthConstraints removeAllObjects];
    
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = self.titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        [self.labelsContainer addSubview:label];
        [self.labels addObject:label];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    for (int i = 0; i < self.labels.count; i++)
    {
        CGRect textRect = [self.titles[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]}
                                                       context:nil];
        
        UILabel *label = self.labels[i];
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *widthConstraint = nil;
        if (textRect.size.width < textRect.size.height) {

            widthConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:textRect.size.height + 10];
            
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:textRect.size.height + 10];
            
            [label addConstraint:widthConstraint];
            [label addConstraint:heightConstraint];
            
        } else {

            widthConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:textRect.size.width + 20];
            
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:textRect.size.height + 10];
            
            [label addConstraint:widthConstraint];
            [label addConstraint:heightConstraint];
            
        }
        [self.widthConstraints addObject:widthConstraint];
        
        NSLayoutConstraint *verticalCenterConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.labelsContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.labelsContainer addConstraint:verticalCenterConstraint];
        
        if (i > 0) {
            NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.labels[i - 1] attribute:NSLayoutAttributeRight multiplier:1 constant:10];
            [self.labelsContainer addConstraint:leadingConstraint];
        } else {
            NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.labelsContainer attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
            [self.labelsContainer addConstraint:leadingConstraint];
        }
        
        label.frame = CGRectIntegral(label.frame);
        label.font = [label.font fontWithSize:(self.fontSize)];
        label.textColor = self.textColor;
        label.backgroundColor = self.backgroundColor;
        label.layer.cornerRadius = (textRect.size.height + 10) / 2;
        label.clipsToBounds = YES;
    }
    
    if (self.labels.count > 1) {
        
        self.solidLine = [[UIView alloc] initWithFrame:CGRectZero];
        self.solidLine.backgroundColor = self.backgroundColor;
        [self.solidLine setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.labelsContainer addSubview:self.solidLine];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.solidLine attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.labels[0] attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraint:leadingConstraint];
        [self.labelsContainer addConstraint:leadingConstraint];
        
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.solidLine attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.labels[self.labels.count - 1] attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        [self.labelsContainer addConstraint:trailingConstraint];
        
        NSLayoutConstraint *verticalCenterConstraint = [NSLayoutConstraint constraintWithItem:self.solidLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.labels[0] attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self.labelsContainer addConstraint:verticalCenterConstraint];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.solidLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:5];
        [self.solidLine addConstraint:heightConstraint];
        
        [self.labelsContainer sendSubviewToBack:self.solidLine];
    }
    
    if (self.titles.count > 0) {
        CGRect textRect = [self.titles.firstObject boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]}
                                                       context:nil];
        
        self.containerHeightConstraint.constant = textRect.size.height + 10;
    }
    
    [self displaySelectedItem];
    
}

//MARK: Tracking changes

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [touch locationInView:self.labelsContainer];
    NSInteger calculatedIndex = -1;
    for (int i = 0; i < self.labels.count; i++) {

        if (CGRectContainsPoint(self.labels[i].frame, location)) {
            calculatedIndex = i;
        }
    }
    
    if (calculatedIndex >= 0) {
        self.selectedIndex = calculatedIndex;
    }
    
    return false;
}

-(void)displaySelectedItem {
    
    if (self.labels.count < self.selectedIndex + 1 || self.labels.count == 0)
        return;

    for (int i = 0; i < self.labels.count; i++) {
        
        self.labels[i].text = self.titles[i];
        self.labels[i].backgroundColor = self.backgroundColor;
        self.labels[i].textColor = self.textColor;
    }
    
    self.labels[self.selectedIndex].backgroundColor = self.textColor;
    self.labels[self.selectedIndex].textColor = self.backgroundColor;
    
    if ([self.titles[self.selectedIndex] intValue] > 0) {
        self.labels[self.selectedIndex].text = [self daysCountDescription:[self.titles[self.selectedIndex] intValue]];
    }

    [self updateWidthConstraints];
}

-(void)updateWidthConstraints {
    
    if (self.labels.count < self.selectedIndex + 1 || self.labels.count == 0)
        return;
    
    CGFloat containerWidth = 0;
    for (int i = 0; i < self.titles.count; i++) {
        
        CGRect textRect;
        
        if (i == self.selectedIndex) {
            
            NSString *title = self.titles[i];

            if ([self.titles[self.selectedIndex] intValue] > 0) {
                title = [self daysCountDescription:[self.titles[self.selectedIndex] intValue]];
            }
            
            textRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]}
                                                           context:nil];
        } else {
            
            textRect = [self.titles[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]}
                                                           context:nil];
        }
        
        if (textRect.size.width < textRect.size.height) {
            
            self.widthConstraints[i].constant = textRect.size.height + 10;
        } else {
            
            self.widthConstraints[i].constant = textRect.size.width + 20;
        }

        if (i > 0) {
            containerWidth += self.widthConstraints[i].constant + 10;
        } else {
            containerWidth += self.widthConstraints[i].constant;
        }
        
    }
    
    self.containerWidthConstraint.constant = containerWidth;

}

//MARK: Events processors

-(void)internalEventValueChangedProcessor {
    
    NSLog(@"Selected segment index changed: %lu (message from control)", (unsigned long)self.selectedIndex);
}

//MARK: Some useful methods

+ (void)removeAllConstraintsFromView:(UIView *)view
{
    UIView *superview = view.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == view || c.secondItem == view) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [view removeConstraints:view.constraints];
    view.translatesAutoresizingMaskIntoConstraints = YES;
}

- (NSString *)daysCountDescription:(NSInteger) days {
    
    if (days == 1) {
        return [NSString stringWithFormat:@"%ld день", (long)days];
    } else if (2 <= days && days <= 4) {
        return [NSString stringWithFormat:@"%ld дня", (long)days];
    } else {
        return [NSString stringWithFormat:@"%ld дней", (long)days];
    }
}

//MARK: Public interface methods

-(BOOL)addSegmentWithTitle:(NSString *)segmentTitle {
    
    if (segmentTitle.length <= 0)
        return false;
    
    @synchronized (self) {
        
        [self.titles addObject:segmentTitle];
        [self setupLabels];
    }
    
    return true;
}

-(BOOL)insertSegment:(NSString *)segmentTitle atIndex:(NSInteger)segmentIndex {
    
    if (segmentIndex < 0 || self.titles.count - 1 < segmentIndex )
        return false;
    
    if (segmentTitle.length <= 0)
        return false;
    
    @synchronized (self) {
        
        [self.titles insertObject:segmentTitle atIndex:segmentIndex];
        [self setupLabels];
    }
    
    return true;
}

-(BOOL)removeSegmentAtIndex:(NSInteger)segmentIndex {
    
    if (segmentIndex < 0 || self.titles.count - 1 < segmentIndex )
        return false;
    
    @synchronized (self) {
        
        [self.titles removeObjectAtIndex:segmentIndex];
        [self setupLabels];
        self.selectedIndex = 0;
    }
    
    return true;
}

-(BOOL)removeAllSegments {
    
    @synchronized (self) {
        
        [self.titles removeAllObjects];
        [self setupLabels];
        self.selectedIndex = 0;
    }
    
    return true;
}

@end
