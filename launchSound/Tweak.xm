#import <AudioToolbox/AudioToolbox.h>
#import <SpringBoard/SBApplicationController.h>

#define tweetbotID @"com.tapbots.Tweetbot"

static SystemSoundID sound;
static BOOL loaded = NO;

@interface SBApplicationController (launch)
+ (id) sharedInstance;
@end

@interface SBApplication
- (void) playNow;
@end

%hook SBApplication

%new(v@:)
- (void) playNow
{
    if (!loaded) {
        SBApplicationController *SBAppConroller = (SBApplicationController *)[%c(SBApplicationController) sharedInstance];
        NSArray *array = [SBAppConroller applicationsWithBundleIdentifier:tweetbotID];
        if ([array count] < 1) return;
        
        NSBundle *TBbundle = (NSBundle*)[[array objectAtIndex:0] bundle];
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[TBbundle pathForResource:@"button_click" ofType:@"caf"]], &sound);
        loaded = YES;
    }
    AudioServicesPlaySystemSound(sound);
}

-(void)activate {
    [self playNow];
    %orig;
}

%end
