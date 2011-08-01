//Day-6; ToDoNotes

static UIActionSheet *toDoSheet;
static UITextView *noteView;
static UIImageView *imgView;
static BOOL email = NO;

#define plistPath @"/var/mobile/Library/Preferences/com.apple.mobilenotes.plist"

@interface NoteObject
@property(retain) NSString *content;    //There is plain Text property (NSString * contentAsPlainText) I had to use content for line break, etc :/
@end

@interface NotesDisplayController : UIViewController <UIActionSheetDelegate>
@end

%hook NotesDisplayController
- (void)emailButtonClicked
{
	if (email) {
        email = NO;
		%orig;
		return;
	}
	
    toDoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Push to ToDoNotes", nil];
    toDoSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[toDoSheet showInView:self.view];
    [toDoSheet release]; 
}

- (void)actionSheet:(id)sheet clickedButtonAtIndex:(int)index
{
	if(sheet == toDoSheet && index == 0) {
		email = YES;
		[self emailButtonClicked];
		return;
	} else if (sheet == toDoSheet && index == 1) {
		NoteObject *hooked = MSHookIvar <NoteObject *> (self, "_note");
		NSString *string = hooked.content;
 		string = [string stringByReplacingOccurrencesOfString:@"<div>" withString:@"\n"];    
 		string = [string stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
		string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "]; 
 		NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [plistDict setValue:string forKey:@"moesethSaysHi"];
        [plistDict writeToFile:plistPath atomically:YES];
       	[plistDict release];
		return;
	}
	%orig;
}

%end

%hook SBSearchView
- (id)initWithFrame:(CGRect)frame withContent:(id)content onWallpaper:(id)wallpaper {
    if ((self = %orig)) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, [[UIScreen mainScreen] bounds].size.width - 20, [[UIScreen mainScreen] bounds].size.height - 180)];
    	imgView.layer.cornerRadius = 20.0;
    	imgView.layer.masksToBounds = YES;
    	imgView.image = [UIImage imageWithContentsOfFile:@"/Applications/MobileNotes.app/bodyMarginThin.png"];
        imgView.userInteractionEnabled = YES;
        [self addSubview:imgView];
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        	noteView = [[UITextView alloc]initWithFrame:CGRectMake(25, 10, imgView.frame.size.width - 40, imgView.frame.size.height)];
        	noteView.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
        } else {
            noteView = [[UITextView alloc]initWithFrame:CGRectMake(70, 20, imgView.frame.size.width - 120, imgView.frame.size.height)];
        	noteView.font = [UIFont fontWithName:@"Helvetica" size:24.0f];
        }
        noteView.backgroundColor = [UIColor clearColor];
        noteView.editable = NO;
        [imgView addSubview:noteView];
    }
    return self;
}
%end

%hook SBSearchController

%new(B@:)
- (BOOL)showingOriginalTable { 
    return ![[[[self searchView] searchBar] text] isEqualToString:@""]; 
}

- (id)tableView:(id)view cellForRowAtIndexPath:(id)indexPath
{
    if ([self showingOriginalTable]) {
        imgView.hidden = YES;
        return %orig;
    }
    return nil;
}

- (void)_updateTableContents
{
    if ([self showingOriginalTable]) {
        %orig;
        return;
    }
    imgView.hidden = NO;
    %orig;
}

- (void)searchBarTextDidBeginEditing:(id)searchBarText
{
	%orig;
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
	noteView.text = [plistDict objectForKey:@"moesethSaysHi"];
	[plistDict release];
}

%end