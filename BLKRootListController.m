#include "BLKRootListController.h"

#define SBDICTPATH @"/var/mobile/Library/Preferences/com.maximehip.blanka.lock.plist"

@implementation BLKRootListController

+ (NSString *)hb_specifierPlist {
	return @"Root";
}

+ (NSString *)hb_shareText {
	return [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"I use Centurion to lock my apps @maximehip", @"Root", [NSBundle bundleForClass:self.class], @"I use Centurion to new notifications on my lockscreen @maximehip")];
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"https://twitter.com/maximehip"];
}

- (instancetype)init {
	self = [super init];

	if (self) {
		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
		appearanceSettings.tintColor = [UIColor colorWithRed:215.f / 255.f green:83.f / 255.f blue:106.f / 255.f alpha:1];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

-(void)respring {
	pid_t pid;
	int status;
	const char* args[] = {"killall", "-9", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
	waitpid(pid, &status, WEXITED);
}

-(void)resetApps {
	[[NSFileManager defaultManager] removeItemAtPath:SBDICTPATH error:nil];
	NSMutableArray *array = [[NSMutableArray alloc] init];
    [array writeToFile:SBDICTPATH atomically: TRUE];
}

@end
