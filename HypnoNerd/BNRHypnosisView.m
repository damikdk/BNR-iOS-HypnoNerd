#import "BNRHypnosisView.h"

@interface BNRHypnosisView ()

@property (strong, nonatomic) UIColor *circleColor;
@property (nonatomic) BOOL needCircles;
@property (nonatomic) float currentRadius;
@property (nonatomic) UISegmentedControl *segmentedControl;

@end

@implementation BNRHypnosisView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.needCircles = YES;
        self.currentRadius = 0;
        _circleColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.2];
        
        // Create a UISegmentedControl
        NSArray *mySegments = [[NSArray alloc] initWithObjects:@"Red", @"Green", @"Blue", nil];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:mySegments];
        [self addSubview:_segmentedControl];
        
        [_segmentedControl addTarget:self action:@selector(whichColor:) forControlEvents:UIControlEventValueChanged];
        
        _segmentedControl.center = CGPointMake(self.frame.size.width / 2, 50);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    
    // Add a circle
    for (float currentRadius = 0; currentRadius < self.currentRadius; currentRadius += 20) {
        UIBezierPath *path = [[UIBezierPath alloc] init];

        [path addArcWithCenter:center radius:currentRadius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
        
        path.lineWidth = 10;
        [self.circleColor setStroke];

        [path stroke];
    }
    
    if (self.currentRadius > maxRadius) {
        self.needCircles = NO;
        NSLog(@"Thats all");
    } else {
        self.currentRadius += 20;
    }
    
    // Create a context and save its state
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    
    // Make gradient
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0.0, 1.0, 0.0, 1.0,
                                1.0, 1.0, 0.0, 1.0};
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(center.x, center.y - 200);
    CGPoint endPoint = CGPointMake(center.x, center.y + 150);
    
    // Make triangle
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y - 200);
    CGPathAddLineToPoint(path, NULL, center.x + 100, center.y + 150);
    CGPathAddLineToPoint(path, NULL, center.x - 100, center.y +150);
    CGPathAddLineToPoint(path, NULL, center.x, center.y - 200);
    CGContextAddPath(currentContext, path);
    CGContextClip(currentContext);
    
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    
    CGPathRelease(path);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    
    CGContextRestoreGState(currentContext);
    
    // Add an image with shadow
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);

    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    
    CGRect rectForImage = CGRectMake(center.x - (logoImage.size.width/2.0) / 2.0,
                                     center.y - (logoImage.size.height/2.0) / 2.0,
                                     logoImage.size.width / 2.0,
                                     logoImage.size.height / 2.0);
    
    [logoImage drawInRect:rectForImage];

    if (self.needCircles) {
        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:.04];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    float red = (arc4random() % 100 / 100.0);
    float green = (arc4random() % 100 / 100.0);
    float blue = (arc4random() % 100 / 100.0);
    
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:.4];
    self.circleColor = randomColor;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

- (void)whichColor:(UISegmentedControl *)paramSender
{
    switch (paramSender.selectedSegmentIndex) {
        case 0:
            [self setCircleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.4]];
            break;
        case 1:
            [self setCircleColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:.4]];
            break;
        case 2:
            [self setCircleColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:.4]];
            break;
        default:
            break;
    }
}

@end
