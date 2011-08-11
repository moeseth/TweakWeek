//Day-3; MailKeyboardHide

static BOOL isActive = YES;
static void hideNow()
{
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
	[firstResponder resignFirstResponder];
}

%hook MFMailComposeView

- (void)scrollViewDidEndDragging:(id)arg1 willDecelerate:(BOOL)arg2
{
	if (!isActive) hideNow();
	%orig;
}

- (void)composeRecipientViewDidResignFirstResponder:(id)arg1
{
	isActive = NO;
	%orig;
}

- (void)composeRecipientViewDidBecomeFirstResponder:(id)arg1
{
	isActive = YES;
	%orig;
}

%end

%hook CKBalloonView

- (void)touchesEnded:(id)touch withEvent:(id)event
{
	hideNow();
	%orig;
}

%end

%hook NotesDisplayController
- (void)scrollView:(id)view setContentOffset:(CGPoint)offset
{
	if(offset.y <= -50) hideNow();
	%orig;
}
%end



