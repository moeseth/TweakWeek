// Day-5

#define plusCheck [str rangeOfString:@"+"].location
#define minusCheck [str rangeOfString:@"-"].location 
#define multiplyCheck [str rangeOfString:@"*"].location 
#define divideCheck [str rangeOfString:@"/"].location 

%hook SBSearchController

- (void)searchBarSearchButtonClicked:(UISearchBar *)clicked
{	
	NSString *str = clicked.text;
	if (plusCheck  == NSNotFound && minusCheck == NSNotFound && multiplyCheck == NSNotFound && divideCheck == NSNotFound)
		%orig;
	else {
		if (plusCheck != NSNotFound) {
        	NSArray *pieces = [str componentsSeparatedByString:@"+"];
        	if ([pieces count] >= 2) {
        		double result = [[pieces objectAtIndex:0] doubleValue] + [[pieces objectAtIndex:1] doubleValue];
        		clicked.text = [NSString stringWithFormat:@"%f", result];
        	}
		} else if (minusCheck != NSNotFound) {
        	NSArray *pieces = [str componentsSeparatedByString:@"-"];
        	if ([pieces count] >= 2) {
        		double result = [[pieces objectAtIndex:0] doubleValue] - [[pieces objectAtIndex:1] doubleValue];
        		clicked.text = [NSString stringWithFormat:@"%f", result];
        	}
		} else if (multiplyCheck != NSNotFound) {
        	NSArray *pieces = [str componentsSeparatedByString:@"*"];
        	if ([pieces count] >= 2) {
        		double result = [[pieces objectAtIndex:0] doubleValue] * [[pieces objectAtIndex:1] doubleValue];
        		clicked.text = [NSString stringWithFormat:@"%f", result];
        	}
		} else if (divideCheck != NSNotFound) {
        	NSArray *pieces = [str componentsSeparatedByString:@"/"];
        	if ([pieces count] >= 2) {
        		double result = [[pieces objectAtIndex:0] doubleValue] / [[pieces objectAtIndex:1] doubleValue];
        		clicked.text = [NSString stringWithFormat:@"%f", result];
        	}
		}
	}
}

%end