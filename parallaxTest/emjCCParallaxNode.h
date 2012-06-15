//
//  emjParallaxLayer.h
//  parallaxTest
//
//  Created by Radif Sharafullin on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
    emjCCParallaxNodeTouchModeNone=0,
    emjCCParallaxNodeTouchModeMove,
    emjCCParallaxNodeTouchModeScroll,
}emjCCParallaxNodeTouchMode;

@class emjCCParallaxNode;
@protocol emjCCParallaxNodeScrollDelegate <NSObject>
@optional
-(BOOL)emjCCParallaxNodeShouldRespondToTouchesBegan:(emjCCParallaxNode *)parallaxNode;
-(BOOL)emjCCParallaxNodeShouldRespondToTouchesMoved:(emjCCParallaxNode *)parallaxNode;
-(BOOL)emjCCParallaxNodeShouldRespondToTouchesEnded:(emjCCParallaxNode *)parallaxNode;
-(BOOL)emjCCParallaxNodeShouldRespondToTouchesCancelled:(emjCCParallaxNode *)parallaxNode;

-(BOOL)emjCCParallaxNode:(emjCCParallaxNode *)parallaxNode shouldMoveToPosition:(CGPoint)position;
-(void)emjCCParallaxNode:(emjCCParallaxNode *)parallaxNode didMoveToPosition:(CGPoint)position;

@end

@interface emjCCParallaxNode : CCNode <CCTargetedTouchDelegate>{
    emjCCParallaxNodeTouchMode touchMode;
    float friction;
     CGRect contentRect;
    id<emjCCParallaxNodeScrollDelegate> delegate;
@private
    BOOL _isDragging;
    float _lasty, _yvel, _lastx, _xvel;
    ccArray	*parallaxArray_;
    CGPoint	lastPosition;
    BOOL _wasDragged;
    float _maxXvel,_maxYvel;
}
@property (nonatomic, assign) id<emjCCParallaxNodeScrollDelegate> delegate;
@property(nonatomic, assign) float maxXVelocity;
@property(nonatomic, assign) float maxYVelocity;
@property (nonatomic,readwrite) ccArray * parallaxArray;
@property(nonatomic, assign) float friction;
@property(nonatomic, assign) emjCCParallaxNodeTouchMode touchMode;// default is:emjCCParallaxNodeTouchModeNone
@property(nonatomic, assign) CGRect contentRect; // defines the bounds of the content. CGRectZero is default, boundless
-(void) addChild: (CCNode*) child z:(int)z parallaxRatio:(CGPoint)ratio positionOffset:(CGPoint)offset zoomRatio:(CGPoint)zoomRatio;
@end
