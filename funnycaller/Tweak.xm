#define PATH @"/var/mobile/Library/Preferences/com.w00tylab.funnycaller.plist"

%hook SBCallAlertDisplay
- (void)updateLCDWithName:(id)name label:(id)label breakPoint:(unsigned)point
{
	NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:PATH];
	BOOL enableTweak = plist == nil ? YES : ([plist objectForKey:@"enable"] == nil ? YES : [[plist objectForKey:@"enable"] boolValue]);
	if (enableTweak) {
		NSString *changedTxt = [plist objectForKey:@"text"];
		if (changedTxt != nil && ![changedTxt isEqualToString:@""] && ![changedTxt isEqualToString:@" "] && ![changedTxt isEqualToString:@"  "] )     // don't allow empty strings
		name = changedTxt; 
	}

	%orig;
	[plist release];
}
%end