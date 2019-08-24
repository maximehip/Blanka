#import "springboard.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Cephei/HBPreferences.h>
#define SBDICTPATH @"/var/mobile/Library/Preferences/com.maximehip.blanka.lock.plist"

NSString *alertTitle;
NSString *alertText;
BOOL scrolle;
BOOL openSwitch;
BOOL deleted;
NSString *passcode;
BOOL codee;

%ctor {
	HBPreferences *preferences;
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.maximehip.blanka"];

    [preferences registerObject:&alertTitle default:nil forKey:@"AlertTitle"];
    [preferences registerObject:&alertText default:nil forKey:@"AlertText"];
    [preferences registerBool:&scrolle default:TRUE forKey:@"scrolle"];
    [preferences registerBool:&openSwitch default:FALSE forKey:@"openSwitch"];
    [preferences registerBool:&deleted default:FALSE forKey:@"deleted"];
    [preferences registerBool:&codee default:FALSE forKey:@"codee"];
    [preferences registerObject:&passcode default:nil forKey:@"passcode"];

  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:SBDICTPATH]) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array writeToFile:SBDICTPATH atomically: TRUE];
  }
}



%hook SBIconView
%property (assign,nonatomic)  UIImageView *lock;
%property (assign,nonatomic) BOOL isEditing;


-(void)layoutSubviews {
	SBIcon *ico = self.icon;
	SBApplication *app = ico.application;
	NSString *bundleID = [app bundleIdentifier];
  self.lock = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 40, 35, 35)];
  self.lock.image = [UIImage imageNamed:@"/Library/Application Support/blanka/lock.png"];
  NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
  if (bundleID != NULL && [dicts objectForKey:bundleID]) {
      self.lock.hidden = false;
  } else {
    self.lock.hidden = true;
  }
 	[self addSubview:self.lock];
  %orig;
}

%new
-(void)lockapp {
	SBIcon *ico = self.icon;
	SBApplication *app = ico.application;

	NSString *bundleID = [app bundleIdentifier];

	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
	if (!dict)
		dict = [NSMutableDictionary dictionary];
	[dict setObject:bundleID forKey:[NSString stringWithFormat:@"%@", bundleID]];
	[dict writeToFile:SBDICTPATH atomically:YES];

}

-(void)touchesBegan:(id)arg1 withEvent:(id)arg2 {
	BOOL getted = NO;
	if (self.isEditing == YES) {
		SBIcon *ico = self.icon;
		SBApplication *app = ico.application;
		NSString *bundleID = [app bundleIdentifier];
    if (bundleID != NULL) {
  		NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
      if ([dicts objectForKey:bundleID]) { 
        getted = true;
      }
   		if (getted == true) {
   			self.lock.hidden = false;
   		} else {
   			[self lockapp];
   			self.lock.hidden = false;
   		}
    } else {
      %orig(arg1, arg2);
    }
	} else {
    %orig(arg1, arg2);
  }
}

-(BOOL)_canDisplayCloseBox {
  if (deleted == TRUE) {
    SBIcon *ico = self.icon;
    SBApplication *app = ico.application;
    NSString *bundleID = [app bundleIdentifier];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
    if (![dicts objectForKey:bundleID]) {
      return true;
    } else {
      return false;
    }
  } else {
    return %orig;
  }
}

%end

%hook SBUIController

-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
  	SBApplication* app = arg1;
  	NSString *bundleID = [app bundleIdentifier];
  	BOOL getted = NO;
  	__block BOOL unlock = false;
  	NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
    if ([dicts objectForKey:bundleID]) {
      getted = true;
    }
  	 if (getted == true) {
      if (codee == false) {
  		LAContext *context = [[LAContext alloc] init];
      	NSError *error = nil;
      	NSString *reason = @"Please authenticate using TouchID/FaceID.";

      if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
        localizedReason:reason
        reply:^(BOOL success, NSError *error)
        {
          dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
          {
            dispatch_async(dispatch_get_main_queue(), ^(void)
            {
              if (success) {
                %orig();
              } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:alertTitle
                message:alertText
                delegate:self
                cancelButtonTitle:@"Okay"
                otherButtonTitles:nil];

                [alert show];
              }
            });
          });
        }];
    	} else {
          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                message:@"Please active FaceID/TouchID"
                delegate:self
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];

                [alert show];
      }
    } else {
      UIAlertView * alertTextField = [[UIAlertView alloc] initWithTitle:@"Post To Facebook" message:@"What would you like the post to say?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
      [alertTextField setAlertViewStyle:UIAlertViewStylePlainTextInput];
      alertTextField.delegate = self; // you forget to add this line 
      alertTextField.tag = 2;
      [alertTextField show];
      NSLog(@"ak");
    }
  	} else {
  		%orig(arg1, arg2, arg3, arg4, arg5);
  	}
  	if (unlock == true) {
  		%orig(arg1, arg2, arg3, arg4, arg5);
  	}
}
%new
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
      NSLog(@"OK");
 }

%new 
- (BOOL)canBecomeFirstResponder 
{ 
  return YES;
}

%end

@interface SBAppLayout : NSObject
- (void)getAppId;
@end

NSString *swipeAppId;
 BOOL getted = NO;

%hook SBAppLayout
%new
- (void)getAppId {
      NSDictionary *roles =  [self valueForKey:@"rolesToLayoutItemsMap"];
      NSArray *jsonArray = [roles allValues];
      NSDictionary *firstObjectDict = [jsonArray objectAtIndex:0];
      swipeAppId = [firstObjectDict valueForKey:@"displayIdentifier"];
  }
%end
%hook SBFluidSwitcherItemContainer
SBAppLayout *lay;

- (void)layoutSubviews {
  %orig;
  lay = MSHookIvar <SBAppLayout*> (self,"_appLayout");
  [lay getAppId];
  NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
  if (scrolle == true) {
    if ([dicts objectForKey:swipeAppId]) {
      MSHookIvar <UIScrollView*> (self,"_verticalScrollView").scrollEnabled = NO;
    } else {
      MSHookIvar <UIScrollView*> (self,"_verticalScrollView").scrollEnabled = YES;
    }
  }
}

-(void)_handlePageViewTap:(id)arg1 {
    lay = MSHookIvar <SBAppLayout*> (self,"_appLayout");
    [lay getAppId];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
    if (openSwitch == false) {
      if (![dicts objectForKey:swipeAppId]) {
        %orig(arg1);
      }
    } else {
      %orig(arg1);
    }
}
%end

@interface SBFluidSwitcherItemContainerHeaderView : UIView
@end

%hook SBFluidSwitcherItemContainerHeaderView

-(void)layoutSubviews {
  %orig;
  lay = MSHookIvar <SBAppLayout*> (self,"_appLayout");
    [lay getAppId];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithContentsOfFile:SBDICTPATH];
    if ([dicts objectForKey:swipeAppId]) {
      UIImageView *lockname =[[UIImageView alloc] initWithFrame:CGRectMake(50,50,35,35)];
      lockname.image=[UIImage imageNamed:@"/Library/Application Support/blanka/lock.png"];
      [self addSubview:lockname];
    }
}
%end
