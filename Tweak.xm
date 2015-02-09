#import <UIKit/UIKit.h>


@interface SBAwayLockBar : UIView
-(UIView *)knob;
-(void)unlock;
-(void)setLabel:(id)label;
@end

@interface SBWiFiManager : NSObject
+(id)sharedInstance;
-(void)setWiFiEnabled:(BOOL)enabled;
-(BOOL)wiFiEnabled;
@end


static BOOL togg;
static float slide;
static BOOL wen;


%hook SBAwayLockBar

-(void)slideBack:(BOOL)back {
	if (slide != 0.0f && slide != 1.0f) {
		[[self knob] setTransform:CGAffineTransformMakeScale(1,1)];
		togg=NO;
	} else {
		togg=NO;
	}
	%orig(back);
}

-(void)knobDragged:(float)dragged {
	slide=dragged;

	if (dragged == 1.0f) {
		togg=YES;
	}
	
	if (dragged < 1.0f && togg) {
		[[self knob] setTransform:CGAffineTransformMakeScale(-1,1)];
	}
	
	if (dragged == 0.0f) {
		if (togg) {
			[[self knob] setTransform:CGAffineTransformMakeScale(1,1)];
			
			wen = [[%c(SBWiFiManager) sharedInstance] wiFiEnabled];
			
			[[%c(SBWiFiManager) sharedInstance] setWiFiEnabled:!wen];
			
			if ((!wen) == NO) {
				[self performSelector:@selector(setLabel:) withObject:@"WiFi disabled"];
			}
			
			togg=NO;
		} else {
			if ([[%c(SBWiFiManager) sharedInstance] wiFiEnabled] == YES) {
				[self performSelector:@selector(setLabel:) withObject:@"WiFi enabled!"];
			}
		}
	}
	
	%orig(dragged);
}

%end