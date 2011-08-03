static BOOL lock = YES;

@interface RecentsViewController <UIActionSheetDelegate>
@end

%hook RecentsViewController

- (int)tableView:(id)view numberOfRowsInSection:(int)section
{
	if (lock)
		return 0;
	return %orig;
}

- (void)_filterWasToggled:(id)toggled
{
	if(lock) return;
	%orig;
}

- (void)_clearButtonClicked:(id)clicked
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear All Recents" otherButtonTitles:@"Refresh", nil];
   	sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:[UIWindow keyWindow]];
    [sheet release];
}

- (void)actionSheet:(id)sheet clickedButtonAtIndex:(int)index {
	if (index == 0)
		%orig;
	else if (index == 1)  
		[self refreshList];
}

%new(v@:)
- (void) refreshList {
	lock = !lock;
	[self reloadData];	
}

%end