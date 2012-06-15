//
//  HelloWorldLayer.m
//  parallaxTest
//
//  Created by Radif Sharafullin on 6/2/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "emjCCParallaxNode.h"
// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		emjCCParallaxNode *pLayer=[emjCCParallaxNode node];
		
        CCSprite *clouds=[CCSprite spriteWithFile:@"clouds.png"];
        clouds.anchorPoint = ccp(0,0);
        [pLayer addChild:clouds z:0 parallaxRatio:CGPointZero positionOffset:CGPointZero zoomRatio:CGPointZero];
        
        
        
        CCSprite *mountain=[CCSprite spriteWithFile:@"mountain.png"];
        mountain.anchorPoint = ccp(0,0);
        [pLayer addChild:mountain z:0 parallaxRatio:ccp(0.05f,0.0f) positionOffset:ccp(200,200) zoomRatio:ccp(.3,0)];

        
        CCTexture2D *grassTexture=[[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"grass.png"] ] autorelease];
        
        CCSprite *grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        grass.scale=.5;
        [pLayer addChild:grass z:1 parallaxRatio:ccp(0.1f,0.0f) positionOffset:ccp(-20,204) zoomRatio:ccp(0,0)];
        
        grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        grass.scale=.5;
        [pLayer addChild:grass z:1 parallaxRatio:ccp(0.1f,0.0f) positionOffset:ccp(1024-20,204) zoomRatio:ccp(0,0)];
        grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        grass.scale=.5;
        [pLayer addChild:grass z:1 parallaxRatio:ccp(0.1f,0.0f) positionOffset:ccp(2048-20,204) zoomRatio:ccp(0,0)];
        
        
        grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        grass.scale=.5;
        [pLayer addChild:grass z:1 parallaxRatio:ccp(0.1f,0.0f) positionOffset:ccp(-1024-20,204) zoomRatio:ccp(0,0)];
        
        
        grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        grass.scale=.5;
        [pLayer addChild:grass z:1 parallaxRatio:ccp(0.1f,0.0f) positionOffset:ccp(-2048-20,204) zoomRatio:ccp(0,0)];
        
        
        
        
        
        CCTexture2D *groundTexture=[[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"ground.png"] ] autorelease];

        
        CCSprite *ground = [CCSprite spriteWithTexture:groundTexture];
        ground.anchorPoint = ccp(0,0);
        // ground.position=ccp(0,-100);
        [pLayer addChild:ground z:2 parallaxRatio:ccp(0.2f,0.0f) positionOffset:ccp(-20,0) zoomRatio:CGPointZero];
        
        ground = [CCSprite spriteWithTexture:groundTexture];
        ground.anchorPoint = ccp(0,0);
        // ground.position=ccp(0,-100);
        [pLayer addChild:ground z:2 parallaxRatio:ccp(0.2f,0.0f) positionOffset:ccp(2048-20,0) zoomRatio:ccp(0,0)];
        ground = [CCSprite spriteWithTexture:groundTexture];
        ground.anchorPoint = ccp(0,0);
        // ground.position=ccp(0,-100);
        [pLayer addChild:ground z:2 parallaxRatio:ccp(0.2f,0.0f) positionOffset:ccp(-2048-20,0) zoomRatio:ccp(0,0)];
        
        
        
        
        grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        
        [pLayer addChild:grass z:3 parallaxRatio:ccp(0.6f,0.0f) positionOffset:ccp(-20,-120) zoomRatio:ccp(0,0)];
        
        
        grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        
        [pLayer addChild:grass z:3 parallaxRatio:ccp(0.6f,0.0f) positionOffset:ccp(2048-20,-120) zoomRatio:ccp(0,0)];
        
        grass = [CCSprite spriteWithTexture:grassTexture];
        grass.anchorPoint = ccp(0,0);
        
        [pLayer addChild:grass z:3 parallaxRatio:ccp(0.6f,0.0f) positionOffset:ccp(-2048-20,-120) zoomRatio:ccp(0,0)];

        pLayer.touchMode=emjCCParallaxNodeTouchModeScroll;
       // pLayer.friction=1.0;
        pLayer.contentRect=CGRectMake(-3500, 0, 8000, 0);
        pLayer.delegate=self;
        
        [self addChild: pLayer];
        
	}
	return self;
}

// uncomment this code to get the position:
/*
-(BOOL)emjCCParallaxNode:(emjCCParallaxNode *)parallaxNode shouldMoveToPosition:(CGPoint)position{
    NSLog(@"position: %@",NSStringFromCGPoint(position));
    return TRUE;
}
*/

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
