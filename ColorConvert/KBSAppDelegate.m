//
//  KBSAppDelegate.m
//  ColorConvert
//
//  Created by Keith Smiley on 8/31/13.
//  Copyright (c) 2013 Keith Smiley. All rights reserved.
//

#import "KBSAppDelegate.h"

@implementation KBSAppDelegate

- (NSString *)commandWithName:(NSString *)name dictionary:(NSDictionary *)dictionary {
    float r = [[dictionary valueForKey:@"Red Component"] floatValue] * 65535;
    float g = [[dictionary valueForKey:@"Green Component"] floatValue] * 65535;
    float b = [[dictionary valueForKey:@"Blue Component"] floatValue] * 65535;
    
    return [NSString stringWithFormat:@"set %@ to {%.10f, %.10f, %.10f}", name, r, g, b];
}

- (NSString *)cleanName:(NSString *)name {
    if (!self.d) {
        self.d = @{
            @"Ansi 0 Color": @"ansiBlackColor",
            @"Ansi 1 Color": @"ansiRedColor",
            @"Ansi 2 Color": @"ansiGreenColor",
            @"Ansi 3 Color": @"ansiYellowColor",
            @"Ansi 4 Color": @"ansiBlueColor",
            @"Ansi 5 Color": @"ansiMagentaColor",
            @"Ansi 6 Color": @"ansiCyanColor",
            @"Ansi 7 Color": @"ansiWhiteColor",
            @"Ansi 8 Color": @"ansiBrightBlackColor",
            @"Ansi 9 Color": @"ansiBrightRedColor",
            @"Ansi 10 Color": @"ansiBrightGreenColor",
            @"Ansi 11 Color": @"ansiBrightYellowColor",
            @"Ansi 12 Color": @"ansiBrightBlueColor",
            @"Ansi 13 Color": @"ansiBrightMagentaColor",
            @"Ansi 14 Color": @"ansiBrightCyanColor",
            @"Ansi 15 Color": @"ansiBrightWhiteColor",
            @"Cursor Text Color": @"cursor_text color"
        };
    }
    
    if ([self.d objectForKey:name]) {
        return [self.d objectForKey:name];
    }
    
    return [name lowercaseString];
}

- (IBAction)chooseThemeFile:(id)sender {
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setAllowsMultipleSelection:false];
    [panel setCanChooseDirectories:false];
    [panel setCanChooseFiles:true];
    [panel setCanCreateDirectories:false];
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        NSURL *fileURL = [panel URL];
        if (!fileURL) {
            [[NSAlert alertWithMessageText:@"No file URL chosen" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"You must choose a theme file in the format of a plist for conversion."] runModal];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self convertAndCopyTheme:[NSDictionary dictionaryWithContentsOfURL:fileURL]];
        });
    }];
}

- (void)convertAndCopyTheme:(NSDictionary *)d {
    __block NSString *cmd = @"";
    [d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *name = [self cleanName:key];
        NSString *c = [self commandWithName:name dictionary:obj];
        cmd = [NSString stringWithFormat:@"%@\n%@", cmd, c];
    }];
    
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [pb clearContents];
    [pb writeObjects:@[cmd]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSAlert alertWithMessageText:@"Done" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Converted theme copied to pasteboard."] runModal];
    });
}

@end
