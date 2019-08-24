#import <UIKit/UIKit.h>

@interface SBIcon : NSObject
-(id)application;
@end

@interface SBIconView : UIView <UIAlertViewDelegate>
@property (nonatomic,retain) SBIcon * icon;
-(void)setIconImageAlpha:(double)arg1;
-(void)setIconAccessoryAlpha:(double)arg1;
-(void)_applyIconImageAlpha:(double)arg1;
-(void)lockapp;
@property (assign,nonatomic)  UIImageView *lock;
@property (assign,nonatomic) BOOL isEditing;
@end

@interface SBApplication : NSObject
-(NSString *)bundleIdentifier;
@end