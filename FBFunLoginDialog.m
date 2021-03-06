#import "FBFunLoginDialog.h"

@implementation FBFunLoginDialog

@synthesize webView = _webView;
@synthesize apiKey = _apiKey;
@synthesize requestedPermissions = _requestedPermissions;
@synthesize delegate = _delegate;

- (id)initWithAppId:(NSString *)apiKey
requestedPermissions:(NSString *)requestedPermissions
           delegate:(id<FBFunLoginDialogDelegate>)delegate {
    
  /* UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FBFunLoginDialogSB" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FBFunLoginDialog"]; */
    
    if ((self = [super initWithNibName:@"FBFunLoginDialog"
                                bundle:[NSBundle mainBundle]])) {
//    if ((self = [super initWithNibName:vc bundle:[NSBundle mainBundle]])) {
//    if (self = [super initWithCoder:aDecoder]) {
        
        self.apiKey = apiKey;
        self.requestedPermissions = requestedPermissions;
        self.delegate = delegate;
    }
    
    return self;
}

-(void)viewDidLoad {
     self.webView.delegate = self;
}

- (void)login {
    
    [_webView loadRequest:
     [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    NSString *redirectUrlString =
    @"http://www.facebook.com/connect/login_success.html";
    
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
    
    NSString *urlString = [NSString stringWithFormat:authFormatString,
                           _apiKey, redirectUrlString, _requestedPermissions];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(void)logout {
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in
         [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {       
    
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"urlString : %@",urlString);
    
    [self checkForAccessToken:urlString];
    [self checkLoginRequired:urlString];
    
    return TRUE;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error : %@",[error description]);
}

-(void)checkForAccessToken:(NSString *)urlString {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"access_token=(.*)&"
                                  options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch =
        [regex firstMatchInString:urlString
                          options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken
                           stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_delegate accessTokenFound:accessToken];
        }
    }
}

-(void)checkLoginRequired:(NSString *)urlString {
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound) {
        [_delegate displayRequired];
    }
}

- (IBAction)closeTapped:(id)sender {
    [_delegate closeTapped];
}

- (void)dealloc {
    self.webView = nil;
    self.webView.delegate = nil;
    self.apiKey = nil;
    self.requestedPermissions = nil;
    //[super dealloc];
}

@end