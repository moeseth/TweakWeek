//Day-3; MailKeyboardHide

%hook MFMailComposeView

- (void)scrollViewDidEndDragging:(id)arg1 willDecelerate:(BOOL)arg2
{
	%orig;
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
	[firstResponder resignFirstResponder];
}

%end
