//
//  YouTubeRecord.m
//  HW3
//
//  Created by david morton on 11/3/13.
//  Copyright (c) 2013 david morton. All rights reserved.
//

#import "YouTubeRecord.h"

@implementation YouTubeRecord



-(void)openLink{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_link]];
}

@end
