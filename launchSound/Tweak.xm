#import <AudioToolbox/AudioToolbox.h>
#import <SpringBoard/SBApplicationController.h>

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
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:@"/Applications/YouTube.app/button_click.caf"], &sound);
        loaded = YES;
    }
    AudioServicesPlaySystemSound(sound);
}

-(void)activate {
    [self playNow];
    %orig;
}

%end


//require to have button_click.caf inside YouTube.app