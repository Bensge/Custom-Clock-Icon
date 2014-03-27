/*
Copyright - Ain't nobody got time for that!

Bensge (c) 2014
*/


/*HEADERS*/

@interface SBClockApplicationIconImageView : /*SBLiveIconImageView*/NSObject {
	CALayer *_seconds;
	CALayer *_minutes;
	CALayer *_hours;
	CALayer *_blackDot;
	CALayer *_redDot;
}
@end

/*
This tweak heavily relies on the order in which the Clock Icon layers get set up, this may break soon!
1. _blackDot
2. _hours
3. _minutes
4. _seconds
5. _redDot
*/


/*CODE*/

#define WINTERBOARD_PLIST_PATH [NSHomeDirectory() stringByAppendingString:@"/Library/Preferences/com.saurik.WinterBoard.plist"]
#define THEME_PATH @"/Library/Themes"


static NSDictionary *settingsCache = nil;
static NSDictionary *getSettings()
{
	if (settingsCache != nil)
		return settingsCache;

	NSDictionary *wbPlist = [NSDictionary dictionaryWithContentsOfFile:WINTERBOARD_PLIST_PATH];
	NSArray *themes = wbPlist[@"Themes"];
	
	for (NSDictionary *theme in themes)
	{
		if ([theme[@"Active"] boolValue])
		{
			NSString *themeName = theme[@"Name"];
			NSString *path = [NSString stringWithFormat:@"%@/%@.theme/Info.plist",THEME_PATH,themeName];
			NSDictionary *themeDict = [NSDictionary dictionaryWithContentsOfFile:path];

			if (themeDict[@"customclockicon"] != nil)
			{
				return themeDict[@"customclockicon"];
			}
		}
	}

	return nil;
}


static UIColor *colorWithHexString(NSString *hexString)
{
    if (hexString.length < 7){
    	NSLog(@"customclockicon: invalid color configuration. Colors must be saved like so: #FFFFFF");
    	return nil;
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // '#'
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}



static BOOL shouldHookClockIcon = NO;
static int counter = 0;


%hook SBClockApplicationIconImageView

- (id)initWithFrame:(CGRect)frame
{
	shouldHookClockIcon = YES;
	id ret = %orig;
	shouldHookClockIcon = NO;
	return ret;
}

%end

/*
1. _blackDot
2. _hours
3. _minutes
4. _seconds
5. _redDot
*/


%hook CALayer
-(void)setBackgroundColor:(CGColorRef)backgroundColor
{
	if (shouldHookClockIcon){
		
		counter++;

		NSDictionary *settings = getSettings();

		if (counter == 1) //_blackDot
		{
			if ([[settings allKeys] containsObject:@"blackDot"]){
				backgroundColor = colorWithHexString(settings[@"blackDot"]).CGColor ?: backgroundColor;
			}
		}
		else if (counter == 2) //_hours
		{
			if ([[settings allKeys] containsObject:@"hours"]){
				backgroundColor = colorWithHexString(settings[@"hours"]).CGColor ?: backgroundColor;
			}
		}
		else if (counter == 3)//_minutes
		{
			if ([[settings allKeys] containsObject:@"minutes"]){
				backgroundColor = colorWithHexString(settings[@"minutes"]).CGColor ?: backgroundColor;
			}
		}
		else if (counter == 4)//_seconds
		{
			if ([[settings allKeys] containsObject:@"seconds"]){
				backgroundColor = colorWithHexString(settings[@"seconds"]).CGColor ?: backgroundColor;
			}
		}
		else if (counter == 5)//_redDot
		{
			if ([[settings allKeys] containsObject:@"redDot"]){
				backgroundColor = colorWithHexString(settings[@"redDot"]).CGColor ?: backgroundColor;
			}
			counter = 0; //This is probably unnecessary, yolo.
		}

	}
	%orig(backgroundColor);
}
%end

/*Yolo*/