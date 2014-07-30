//
//  RLGMyScene.m
//  RhythmLine
//
//  Created by Aneesh Sachdeva on 7/28/14.
//  Copyright (c) 2014 Applos. All rights reserved.
//

#import "RLGMyScene.h"
#import "RLGPath.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation RLGMyScene

// in points
const float play_area_width = 320;
const float play_area_height = 480;
const float player_y_position = 0.42f * play_area_height;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        self.myLabel.text = @"Hello, World!";
        self.myLabel.fontSize = 24;
        self.myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:self.myLabel];
        
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship.png"];
        self.player.position = [self convertPoint:CGPointMake(play_area_width/2, player_y_position)];
        //self.player.position = CGPointMake(play_area_width/2, player_y_position);
        [self.player setScale: 0.25f];
        [self addChild:self.player];
        
//        self.player = [[RLGPath alloc] initWithImageNamed:@"Spaceship.png"];
//        self.player.position = [self convertPoint:CGPointMake(play_area_width/2, player_y_position)];
//        //[self.player setScale: 0.25f];
//        [self addChild:self.player];

        [self initBasicPaths]; // initialize the array that contains all the basic paths
        self.pathStream = [[NSMutableArray alloc] initWithObjects:[self.basicPaths objectAtIndex:[self randomBasicPathIndex]], nil];
        if ([[self.pathStream objectAtIndex:0] parent] != nil)
        {
            //self.myLabel.text = @"has parent";
        }

        appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.umooveEngine enableDirections:YES];
        [appDelegate.umooveEngine setDirectionsSensitivity:85 CenterZone:0 Levels:500 ];
        // set high resolution frame if better accuracy is needed. Uses more CPU.
        [appDelegate.umooveEngine setHighResFrame:YES];
        
        // set this scene as umoove's delegate
        [appDelegate.umooveEngine setUmooveDelegate:self];
        
        [appDelegate.umooveEngine start:YES];

    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:appDelegate.umooveEngine.captureSession];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect]; previewLayer.frame = CGRectMake(self.size.width/2 * .04f, self.size.height * .05f, 352, 288);
    [self.view.layer insertSublayer:previewLayer atIndex:0];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
        [appDelegate.umooveEngine reset];
        //self.player.position = [self convertPoint:CGPointMake(play_area_width/2, player_y_position)];
    }
}

- (void)UMStatesUpdate:(int)state
{
    
}

- (void)UMDirectionsUpdate:(int)x :(int)y
{
    self.player.position = [self convertPoint:CGPointMake(x + play_area_width/2, player_y_position)];
    //self.myLabel.text = [NSString stringWithFormat:@"%@", NSStringFromCGPoint(self.player.position)];
    //self.myLabel.text = [NSString stringWithFormat:@"%d", x];
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    self.dTime = currentTime - self.lastUpdateTime;
    self.lastUpdateTime = currentTime;
    if (self.dTime > 1)
    {
        self.dTime = 1.0/60.0;
        self.lastUpdateTime = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:self.dTime];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLastUpdate
{
    //self.myLabel.text = [NSString stringWithFormat:@"%d", [self.pathStream count]];
    for (int i = 0; i < [self.pathStream count]; i++)
    {
        [[self.pathStream objectAtIndex:i] setPosition:[self convertPoint:CGPointMake(play_area_width/2, play_area_height/2)]];
        
        if ([[self.pathStream objectAtIndex:i] parent] == nil)
        {
            [self addChild:[self.pathStream objectAtIndex:i]];
        }

        
//        RLGPath* path = [self.pathStream objectAtIndex:0];
//        if (path != nil)
//        {
//           [self addChild:path];
//        }
//        else
//        {
//            //self.myLabel.text = @"nil";
//        }
    }
}

- (void)updatePathStream
{
    
}

- (void)initBasicPaths
{
    RLGPath* path1 = [[RLGPath alloc] initWithImageNamed:@"StraightTest.png"];
    if (path1 != nil)
    {
        //self.myLabel.text = @"not nil";
    }
    
    self.basicPaths = @[path1];
}

/// HELPER METHODS ///

- (NSUInteger)randomBasicPathIndex
{
    return arc4random_uniform([self.basicPaths count]);
}

/** Convert points from our 480x320 playable area (iPhone 3.5-inch) to the appropriate points on the ipad,
  * Creates 32pt margins on the left and right of the ipad, and 64pt margins on the top and bottom. 
 */
- (CGPoint)convertPoint:(CGPoint)point
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return CGPointMake(64 + point.x*2, 32 + point.y*2);
    }
    else
    {
        return point;
    }
}

/** Returns the name of the appropriate texture for the decice from the texture atlas */ 
- (SKTextureAtlas *)textureAtlasNamed:(NSString *)fileName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (IS_WIDESCREEN)
        {
            // iPhone Retina 4-inch
            fileName = [NSString stringWithFormat:@"%@-568", fileName];
        }
        else
        {
            // iPhone Retina 3.5-inch
            fileName = fileName;
        }
    }
    else
    {
        fileName = [NSString stringWithFormat:@"%@-ipad", fileName];
    }
    
    SKTextureAtlas* textureAtlas = [SKTextureAtlas atlasNamed:fileName];
    
    return textureAtlas;
}

@end
