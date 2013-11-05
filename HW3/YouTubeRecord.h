//
//  YouTubeRecord.h
//  HW3
//
//  Created by david morton on 11/3/13.
//  Copyright (c) 2013 david morton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouTubeRecord : NSObject

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *description;
@property (nonatomic) NSInteger viewCount;


@property (strong,nonatomic) UIImage *thumbnailImage;
@property (strong,nonatomic) NSString *link;

-(void)openLink;

@end
