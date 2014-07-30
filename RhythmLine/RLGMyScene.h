//
//  RLGMyScene.h
//  RhythmLine
//

//  Copyright (c) 2014 Applos. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "RLGAppDelegate.h"

@interface RLGMyScene : SKScene <umooveDelegate>
{
    RLGAppDelegate *appDelegate;
}

@property (nonatomic) CFTimeInterval dTime;
@property (nonatomic) NSTimeInterval lastUpdateTime;

@property SKLabelNode* myLabel;
@property SKSpriteNode* player;

@property NSArray* basicPaths;
@property NSMutableArray* pathStream;
@property NSMutableArray* pathsPendingStream;

@end
