//
//  HelloWorldLayer.h
//  parallaxTest
//
//  Created by Radif Sharafullin on 6/2/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "emjCCParallaxNode.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <emjCCParallaxNodeScrollDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
