//
//  KKKeychainSampleItemViewController.m
//  KeychainKitSample
//
//  Created by david on 17/02/15.
//

#import "KKSItemViewController.h"
#import "KKSVisualizerViewController.h"
#import "KKSDataModel.h"
#import "KKKeychainSampleUIDataAdapter.h"
#import "KKSKeychainHandler.h"

static const CGFloat kPadding = 8.0f;
static const CGFloat kSpacing = 4.0f;

@interface KKSItemViewController () <KKSKeychainHandlerDataSource>

@property (nonatomic) KKSDataModel *model;
@property (nonatomic) UITextField *itemLabelTextField;
@property (nonatomic) UITextField *keychainItemServiceTextField;
@property (nonatomic) UIButton *actionButton;
@property (nonatomic) UIView *itemContentView;
@property (nonatomic) KKSKeychainHandler *keychainHandler;
@property (nonatomic) KKKeychainSampleUIDataAdapter *dataUIAdapter;
@property (nonatomic) id<KKKeychainSampleItemDataVisualizer> dataVisualizer;
@property (nonatomic) UILabel *screenOverlay;

@end

@implementation KKSItemViewController

#pragma mark - Life Cycle

- (instancetype)initWithModel:(KKSDataModel *)model {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.model = model;
    }
    
    return self;
}

#pragma mark - UI Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.dataUIAdapter = [[KKKeychainSampleUIDataAdapter alloc] init];
    [self customizeViewAndNavigationBar];
    [self addSubviews];
    [self customizeSubviews];
    self.keychainHandler = [[KKSKeychainHandler alloc] initWithDataModel:self.model dataSource:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutActionButton];
    [self layoutItemLabelTextField];
    [self layoutKeychainItemServiceTextField];
    [self layoutItemContentView];
    [self layoutScreenOverlayIfExists];
}

#pragma mark - Layout Subviews

- (void)layoutActionButton {
    static const CGSize buttonRecommendedSize = {44.0f, 44.0f};
    
    [self.actionButton sizeToFit];
    CGRect actionButtonFrame = self.actionButton.frame;
    actionButtonFrame.size.width = MAX(CGRectGetWidth(actionButtonFrame), buttonRecommendedSize.width);
    actionButtonFrame.size.height = MAX(CGRectGetHeight(actionButtonFrame), buttonRecommendedSize.height);
    actionButtonFrame.origin.x = (CGRectGetWidth(self.view.bounds) -
                                  CGRectGetWidth(actionButtonFrame) -
                                  kPadding);
    actionButtonFrame.origin.y = kPadding;
    self.actionButton.frame = actionButtonFrame;
}

- (void)layoutItemLabelTextField {
    CGRect itemLabelFrame = self.itemLabelTextField.frame;
    itemLabelFrame.origin.x = kPadding;
    itemLabelFrame.origin.y = kPadding;
    itemLabelFrame.size.width = (CGRectGetMinX(self.actionButton.frame) - kSpacing -
                                 CGRectGetMinX(itemLabelFrame));
    itemLabelFrame.size.height = 44.0f;
    self.itemLabelTextField.frame = itemLabelFrame;
}

- (void)layoutKeychainItemServiceTextField {
    CGRect keychainItemServiceTextFieldFrame = self.keychainItemServiceTextField.frame;
    keychainItemServiceTextFieldFrame.origin.x = kPadding;
    keychainItemServiceTextFieldFrame.origin.y = CGRectGetMaxY(self.itemLabelTextField.frame) + kSpacing;
    keychainItemServiceTextFieldFrame.size.width = CGRectGetWidth(self.view.bounds) - kPadding * 2;
    keychainItemServiceTextFieldFrame.size.height = 44.0f;
    self.keychainItemServiceTextField.frame = keychainItemServiceTextFieldFrame;
}

- (void)layoutItemContentView {
    CGRect itemContentViewFrame = self.itemContentView.frame;
    itemContentViewFrame.origin.y = CGRectGetMaxY(self.keychainItemServiceTextField.frame) + kSpacing;
    itemContentViewFrame.size.width = CGRectGetWidth(self.view.bounds);
    itemContentViewFrame.size.height = (CGRectGetHeight(self.view.bounds) -
                                        CGRectGetMinY(itemContentViewFrame));
    self.itemContentView.frame = itemContentViewFrame;
}

- (void)layoutScreenOverlayIfExists {
    if ([self isScreenOverlayAdded]) {
        self.screenOverlay.frame = self.view.bounds;
    }
}

#pragma mark - View Setup

- (void)customizeViewAndNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [self.dataUIAdapter fullStringForModel:self.model];
}

- (void)addSubviews {
    self.itemLabelTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.itemLabelTextField];
    self.keychainItemServiceTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.keychainItemServiceTextField];
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.actionButton];
    self.itemContentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.itemContentView];
    [self addItemContentChildViewController];
    [self addScreenOverlaySubviewIfNecessary];
}

- (void)addItemContentChildViewController {
    KKSVisualizerViewController *visualizerViewController =
    [KKSVisualizerViewController visualizerViewControllerFromDataType:self.model.dataType];
    [self addChildViewController:visualizerViewController];
    [self.itemContentView addSubview:visualizerViewController.view];
    visualizerViewController.view.frame = self.itemContentView.bounds;
    [visualizerViewController didMoveToParentViewController:self];
    self.dataVisualizer = visualizerViewController;
}

- (void)addScreenOverlaySubviewIfNecessary {
    if (self.model.operationType == KKKeychainOperationTypeUpdate) {
        self.screenOverlay = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.screenOverlay];
    }
}

- (void)customizeSubviews {
    self.itemLabelTextField.placeholder = @"Keychain Item's Label";
    self.itemLabelTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.keychainItemServiceTextField.placeholder = @"Keychain Item's Service Name";
    self.keychainItemServiceTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.actionButton setTitle:[self.dataUIAdapter buttonTitleForModel:self.model]
                       forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.actionButton addTarget:self action:@selector(performActionForActionButton:)
                forControlEvents:UIControlEventTouchUpInside];
    [self customizeScreenOverlayIfAdded];
}

- (void)customizeScreenOverlayIfAdded {
    if ([self isScreenOverlayAdded]) {
        self.screenOverlay.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7f];
        self.screenOverlay.textAlignment = NSTextAlignmentCenter;
        self.screenOverlay.text = @"This screen is buggy or doesn't work properly! "
                                   "This is the reason why you're seeing this overlay!";
        self.screenOverlay.numberOfLines = 0;
        self.screenOverlay.userInteractionEnabled = YES; // don't allow touches below overlay
    }
}

#pragma mark - Action Handling

- (void)performActionForActionButton:(UIButton *)actionButton {
    [self.keychainHandler performKeychainOperation];
}

#pragma mark - Data Handling

- (BOOL)isScreenOverlayAdded {
    return self.screenOverlay != nil;
}

#pragma mark - KKSKeychainHandler Data Source

- (NSString *)keychainItemLabel {
    return self.itemLabelTextField.text;
}

- (NSString *)keychainItemServiceName {
    return self.keychainItemServiceTextField.text;
}

- (NSData *)dataFromView {
    return [self.dataVisualizer dataFromView];
}

- (void)previewData:(NSData *)data {
    [self.dataVisualizer previewData:data];
}

- (NSString *)accountStringFromView {
    if ([self.dataVisualizer respondsToSelector:@selector(accountStringFromView)]) {
        return [self.dataVisualizer accountStringFromView];
    } else {
        return nil;
    }
}

- (void)previewAccountString:(NSString *)accountString {
    if ([self.dataVisualizer respondsToSelector:@selector(previewAccountString:)]) {
        [self.dataVisualizer previewAccountString:accountString];
    }
}

- (KKKeychainSearchLimit)searchLimit {
    if ([self.dataVisualizer respondsToSelector:@selector(searchLimit)]) {
        return [self.dataVisualizer searchLimit];
    } else {
        return KKKeychainSearchLimitOne;
    }
}

@end
