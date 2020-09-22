#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CAMediaTimingFunction+MDCAnimationTiming.h"
#import "MaterialAnimationTiming.h"
#import "UIView+MDCTimingFunction.h"
#import "MaterialAvailability.h"
#import "MDCAvailability.h"
#import "MaterialRipple.h"
#import "MDCRippleTouchController.h"
#import "MDCRippleTouchControllerDelegate.h"
#import "MDCRippleView.h"
#import "MDCRippleViewDelegate.h"
#import "MDCStatefulRippleView.h"
#import "MaterialTabs+TabBarView.h"
#import "MDCTabBarItem.h"
#import "MDCTabBarItemCustomViewing.h"
#import "MDCTabBarView.h"
#import "MDCTabBarViewCustomViewable.h"
#import "MDCTabBarViewDelegate.h"
#import "MDCTabBarViewIndicatorAttributes.h"
#import "MDCTabBarViewIndicatorContext.h"
#import "MDCTabBarViewIndicatorTemplate.h"
#import "MDCTabBarViewUnderlineIndicatorTemplate.h"
#import "MaterialColor.h"
#import "UIColor+MaterialBlending.h"
#import "UIColor+MaterialDynamic.h"
#import "MaterialMath.h"
#import "MDCMath.h"

FOUNDATION_EXPORT double MaterialComponentsVersionNumber;
FOUNDATION_EXPORT const unsigned char MaterialComponentsVersionString[];

