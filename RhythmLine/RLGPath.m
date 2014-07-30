//
//  RLGPath.m
//  RhythmLine
//
//  Created by Aneesh Sachdeva on 7/29/14.
//  Copyright (c) 2014 Applos. All rights reserved.
//

#import "RLGPath.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation RLGPath

- (instancetype)initWithImageNamed:(NSString *)imageName
{
    self = [super init];
    if (self)
    {
        self = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self setScale:0.5f];
        }
    }
    
    return self;
}

@end
