//
//  UIViewController+ATSwizzle.m
//  ApptentiveConnect
//
//  Created by Peter Kamb on 11/3/13.
//  Copyright (c) 2013 Apptentive, Inc. All rights reserved.
//

#import "UIViewController+ATSwizzle.h"
#import "NSObject+ATSwizzle.h"
#import "ATInteractionUpgradeMessageViewController.h"
#import "ATMessagePanelNewUIViewController.h"

@implementation UIViewController (ATSwizzle)

typedef void (*voidIMP) (id, SEL, ...);

void ATSwizzle_UIViewController_Bootstrap() {
	NSLog(@"Loading ATSwizzle_UIViewController_Bootstrap");
}

#pragma mark Upgrade Message

static voidIMP at_originalDidRotate = NULL;

- (void)at_swizzleDidRotateFromInterfaceOrientation {
	if (!at_originalDidRotate) {
		SEL sel = @selector(didRotateFromInterfaceOrientation:);
		at_originalDidRotate = (void *)[self at_swizzleSelector:sel withIMP:(IMP)at_swizzledDidRotateFromInterfaceOrientation];
	}	
}

static void at_swizzledDidRotateFromInterfaceOrientation(id self, SEL _cmd, id  observer, SEL selector, NSString *name, id object) {
	NSAssert(at_originalDidRotate, @"Original `didRotateFromInterfaceOrientation:` method was not found.");
	
	// New implementation
	[[NSNotificationCenter defaultCenter] postNotificationName:ATInteractionUpgradeMessagePresentingViewControllerSwizzledDidRotateNotification object:nil];
	
	// Original implementation
	if (at_originalDidRotate) {
		at_originalDidRotate(self, _cmd, observer, selector, name, object);
	}
}

#pragma mark iOS 7 Message Panel

static voidIMP at_originalMessagePanelDidRotate = NULL;

- (void)at_swizzleMessagePanelDidRotateFromInterfaceOrientation {
	if (!at_originalMessagePanelDidRotate) {
		SEL sel = @selector(didRotateFromInterfaceOrientation:);
		at_originalMessagePanelDidRotate = (void *)[self at_swizzleSelector:sel withIMP:(IMP)at_swizzledMessagePanelDidRotateFromInterfaceOrientation];
	}
}

static void at_swizzledMessagePanelDidRotateFromInterfaceOrientation(id self, SEL _cmd, id  observer, SEL selector, NSString *name, id object) {
	NSAssert(at_originalMessagePanelDidRotate, @"Original `didRotateFromInterfaceOrientation:` method was not found.");
	
	// New implementation
	[[NSNotificationCenter defaultCenter] postNotificationName:ATMessagePanelPresentingViewControllerSwizzledDidRotateNotification object:nil];
	
	// Original implementation
	if (at_originalMessagePanelDidRotate) {
		at_originalMessagePanelDidRotate(self, _cmd, observer, selector, name, object);
	}
}
@end
