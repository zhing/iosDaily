//
//  CoreViewController.m
//  Tarbar
//
//  Created by zhing on 16/5/8.
//  Copyright © 2016年 zhing. All rights reserved.
//

#import "CoreViewController.h"

@implementation CoreViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
                                
    CFStringRef string = CFSTR("Hello");
    CFShow(string);
    CFShowStr(string);
    
    CFArrayRef array = CFArrayCreate(NULL, (const void **)&string, 1, &kCFTypeArrayCallBacks);
    CFShow(array);
    
    const char *cstring = "Hello World!";
    CFStringRef cfstring = CFStringCreateWithCString(NULL, cstring, kCFStringEncodingUTF8);
    CFShow(cfstring);
    CFRelease(cfstring);
    
    const char *cgstring = CFStringGetCStringPtr(cfstring, kCFStringEncodingUTF8);
    printf("%s\n", cgstring);
    
    /*
     __bridge架起了core Foundation与cocoa之间的桥梁
    */
    printf("%ld\n", [(__bridge NSArray *)array count]);
    NSLog(@"%@", [self firstName]);
}

- (NSString *)firstName{
    CFStringRef cfstring = CFSTR("zhang");
    return (__bridge NSString *)cfstring;
}

@end
