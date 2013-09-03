//
//  KBSAppDelegate.h
//  ColorConvert
//
//  Created by Keith Smiley on 8/31/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KBSAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSDictionary *d;
@property (unsafe_unretained) IBOutlet NSWindow *window;

- (IBAction)chooseThemeFile:(id)sender;

@end
