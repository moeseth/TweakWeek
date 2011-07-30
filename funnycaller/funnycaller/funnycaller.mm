#import <Preferences/Preferences.h>

@interface funnycallerListController: PSListController {
}
@end

@implementation funnycallerListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"funnycaller" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
