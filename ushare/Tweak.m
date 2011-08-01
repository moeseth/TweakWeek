#include <YouTube/YTVideo.h>

static BOOL emailNow = NO;

@interface YTVideo (tweak)
@end

@interface YTVideoRelatedView
- (void) openTwitterAndComposeWithOption:(int)choice;
@end

%hook YTVideoRelatedView

%new(v@:)
- (void) openTwitterAndComposeWithOption:(int)choice
{
    YTVideo *ytHook = MSHookIvar<YTVideo *>(self, "_video");
    NSURL *url = MSHookIvar<NSURL *>(ytHook, "_infoURL");
    NSString *title = MSHookIvar<NSString *>(ytHook, "_title");
    NSString *finalStr = [NSString stringWithFormat:@"%@ - %@ via #UShare", title, url];
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)finalStr, NULL,  (CFStringRef)@"&=-#", kCFStringEncodingUTF8);
    if (choice == 1 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetie://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@", encodedString]]];
        return;
    } else if (choice == 1 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///post?text=%@", encodedString]]];
    else if (choice == 2)
        [UIPasteboard generalPasteboard].URL = url;
}

-(void)_shareVideo
{
    if (emailNow) {%orig; emailNow = NO; return;}
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Tweet", @"Copy", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self];
    [sheet release]; 
}

%new(v@:@i)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        emailNow = YES;
        [self _shareVideo];
    }
    else if (buttonIndex == 1)
        [self openTwitterAndComposeWithOption:1];
    else if (buttonIndex == 2)
        [self openTwitterAndComposeWithOption:2];
}

%end 