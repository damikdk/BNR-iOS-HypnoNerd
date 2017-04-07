#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;

@end

@implementation BNRHypnosisViewController



- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Hypnotize";
        
        UIImage *image = [UIImage imageNamed:@"minimal background"];
        
        self.tabBarItem.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"BNRHypnosisViewController loaded its view");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.25 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect frame = CGRectMake(40, 70, 240, 30);
        self.textField.frame = frame;
    } completion:NULL];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] initWithFrame:frame];
    
    CGRect textFieldRect = CGRectMake(40, -30, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me";
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.delegate = self;
    
    [backgroundView addSubview:textField];
    
    self.textField = textField;
    self.view = backgroundView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self drawHypnoticMessage:textField.text];
    
    textField.text = @"";
    [textField resignFirstResponder];
    
    return YES;
}

- (void) drawHypnoticMessage:(NSString *)message
{
    for (int i = 0; i < 100; i++) {
        
        // Create many UILabels
        UILabel *messageLabel = [[UILabel alloc] init];
        
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.text = message;
        
        [messageLabel sizeToFit];
        
        int width = self.view.bounds.size.width - messageLabel.bounds.size.width;
        int x = arc4random() % width;
        
        int height = self.view.bounds.size.height - messageLabel.bounds.size.height;
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        [self.view addSubview:messageLabel];
        
        
        // configure animations
        messageLabel.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            messageLabel.alpha = 1.0;
        } completion:NULL];
        
        [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.6 animations:^{
                messageLabel.center = self.view.center;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:.4 animations:^{
                int x = arc4random() % [@(self.view.frame.size.width) integerValue];
                int y = arc4random() % [@(self.view.frame.size.height) integerValue];
                messageLabel.center = CGPointMake(x, y);
            }];
        } completion:^(BOOL finished) {
            NSLog(@"Animations complete");
        }];
    
        
        // configure motion effect
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                            type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @-25;
        motionEffect.maximumRelativeValue = @25;
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @-25;
        motionEffect.maximumRelativeValue = @25;
        [messageLabel addMotionEffect:motionEffect];
    }
}

@end
