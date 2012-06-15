//
//  emjParallaxLayer.m
//  parallaxTest
//
//  Created by Radif Sharafullin on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "emjCCParallaxNode.h"


@interface emjCGPointObject : NSObject
{
    CGPoint zoomRatio_;
	CGPoint	ratio_;
	CGPoint offset_;
	CCNode *child_;	// weak ref
}
@property (readwrite) CGPoint zoomRatio;
@property (readwrite) CGPoint ratio;
@property (readwrite) CGPoint offset;
@property (readwrite,assign) CCNode *child;
+(id) pointWithCGPoint:(CGPoint)point offset:(CGPoint)offset zoomRatio:(CGPoint)zoomRatio;;
-(id) initWithCGPoint:(CGPoint)point offset:(CGPoint)offset zoomRatio:(CGPoint)zoomRatio;;
@end

@implementation emjCGPointObject
@synthesize zoomRatio = zoomRatio_;
@synthesize ratio = ratio_;
@synthesize offset = offset_;
@synthesize child=child_;

+(id) pointWithCGPoint:(CGPoint)ratio offset:(CGPoint)offset zoomRatio:(CGPoint)zoomRatio; {
	return [[[self alloc] initWithCGPoint:ratio offset:offset zoomRatio:(CGPoint)zoomRatio] autorelease];
}
-(id) initWithCGPoint:(CGPoint)ratio offset:(CGPoint)offset zoomRatio:(CGPoint)zoomRatio{
	if( (self=[super init])) {
		ratio_ = ratio;
		offset_ = offset;
        zoomRatio_=zoomRatio;
	}
	return self;
}
@end

@interface emjCCParallaxNode (private)
-(void)resetScrollViewPosition:(UIScrollView *)scrollView;
@end

@implementation emjCCParallaxNode
@synthesize touchMode,
friction,
contentRect,
delegate;
@synthesize parallaxArray = parallaxArray_;
@synthesize maxXVelocity=_maxXvel;
@synthesize maxYVelocity=_maxYvel;

-(id) init{
	if( (self=[super init]) ) {
		parallaxArray_ = ccArrayNew(5);		
		lastPosition = CGPointMake(-100,-100);
        _isDragging=FALSE;
        friction = 0.95f;
        contentRect=CGRectZero;
        _maxYvel=200;
        _maxXvel=200;
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:FALSE];
	}
	return self;
}

- (void) dealloc{
    // in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
	if( parallaxArray_ ) {
		ccArrayFree(parallaxArray_);
		parallaxArray_ = nil;
	}
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super dealloc];
}

-(void) addChild:(CCNode*)child z:(int)z tag:(int)tag
{
	NSAssert(NO,@"emjCCParallaxNode: use addChild:z:parallaxRatio:positionOffset:zoomRatio instead");
}

-(void) addChild: (CCNode*) child z:(int)z parallaxRatio:(CGPoint)ratio positionOffset:(CGPoint)offset zoomRatio:(CGPoint)zoomRatio{
	NSAssert( child != nil, @"Argument must be non-nil");
	emjCGPointObject *obj = [emjCGPointObject pointWithCGPoint:ratio offset:offset zoomRatio:zoomRatio];
	obj.child = child;
	ccArrayAppendObjectWithResize(parallaxArray_, obj);
	
	CGPoint pos = self.position;
	pos.x = pos.x * ratio.x + offset.x;
	pos.y = pos.y * ratio.y + offset.y;
	child.position = pos;
	
	[super addChild: child z:z tag:child.tag];
}

-(void) removeChild:(CCNode*)node cleanup:(BOOL)cleanup
{
	for( unsigned int i=0;i < parallaxArray_->num;i++) {
		emjCGPointObject *point = parallaxArray_->arr[i];
		if( [point.child isEqual:node] ) {
			ccArrayRemoveObjectAtIndex(parallaxArray_, i);
			break;
		}
	}
	[super removeChild:node cleanup:cleanup];
}

-(void) removeAllChildrenWithCleanup:(BOOL)cleanup
{
	ccArrayRemoveAllObjects(parallaxArray_);
	[super removeAllChildrenWithCleanup:cleanup];
}

-(CGPoint) absolutePosition_
{
	CGPoint ret = position_;
	
	CCNode *cn = self;
	
	while (cn.parent != nil) {
		cn = cn.parent;
		ret = ccpAdd( ret,  cn.position );
	}
	
	return ret;
}

/*
 The positions are updated at visit because:
 - using a timer is not guaranteed that it will called after all the positions were updated
 - overriding "draw" will only precise if the children have a z > 0
 */
-(void) visit
{
    //	CGPoint pos = position_;
    //	CGPoint	pos = [self convertToWorldSpace:CGPointZero];
	CGPoint pos = [self absolutePosition_];
	if( ! CGPointEqualToPoint(pos, lastPosition) ) {
		
		for(unsigned int i=0; i < parallaxArray_->num; i++ ) {
            
			emjCGPointObject *point = parallaxArray_->arr[i];
			float x = -pos.x + pos.x * point.ratio.x + point.offset.x;
			float y = -pos.y + pos.y * point.ratio.y + point.offset.y;			
			point.child.position = ccp(x,y);
            
            //zoom ratio x
            x =(pos.x-lastPosition.x)*point.zoomRatio.x;
            x/=10000;
            point.child.scale+=x;
            
            //zoom ratio y
            y =(pos.y-lastPosition.y)*point.zoomRatio.y;
            y/=10000;
            point.child.scale+=y;
            
        }
    lastPosition = pos;
}

[super visit];
}



-(void)onExit{
    [super onExit];
    [self unscheduleAllSelectors];
}
#pragma Mark Standard Touches
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL should=TRUE;
    if ([delegate respondsToSelector:@selector(emjCCParallaxNodeShouldRespondToTouchesBegan:)]) 
       should= [delegate emjCCParallaxNodeShouldRespondToTouchesBegan:self];
    
        
    _wasDragged=FALSE;
    if (touchMode==emjCCParallaxNodeTouchModeNone) return NO;
    [self unschedule:@selector(scrollTick:)];        
    
    
    
     if (!should) return NO ;
    
    if(touchMode==emjCCParallaxNodeTouchModeScroll) [self schedule:@selector(scrollTick:) interval:0.02f];
    _isDragging = TRUE;
    _xvel=0;
    _yvel=0;
    
    return TRUE;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{

    BOOL should=TRUE;
    if ([delegate respondsToSelector:@selector(emjCCParallaxNodeShouldRespondToTouchesMoved:)]) 
        should= [delegate emjCCParallaxNodeShouldRespondToTouchesMoved:self];
    if (!should) return;

    _wasDragged=TRUE;
    if (touchMode==emjCCParallaxNodeTouchModeScroll || touchMode==emjCCParallaxNodeTouchModeMove) {
        CGPoint location=[touch locationInView:[touch view]];
        location=[[CCDirector sharedDirector] convertToGL:location];
        
        CGPoint prevLocation=[touch previousLocationInView:[touch view]];
        prevLocation=[[CCDirector sharedDirector] convertToGL:prevLocation];
        
        
        CGPoint offsetPoint=ccpSub(location, prevLocation);
        
        [self setPosition:ccp(self.position.x+offsetPoint.x, self.position.y+offsetPoint.y)];
        
    }
}
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL should=TRUE;
    if ([delegate respondsToSelector:@selector(emjCCParallaxNodeShouldRespondToTouchesEnded:)]) 
        should= [delegate emjCCParallaxNodeShouldRespondToTouchesEnded:self];
    if (!should) return;
    
    if(!_wasDragged && touchMode==emjCCParallaxNodeTouchModeScroll) {
        [self unschedule:@selector(scrollTick:)];
        _xvel=0;
        _yvel=0;
    }
    _isDragging = FALSE;
    _wasDragged=FALSE;
}
-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL should=TRUE;
    if ([delegate respondsToSelector:@selector(emjCCParallaxNodeShouldRespondToTouchesCancelled:)]) 
        should= [delegate emjCCParallaxNodeShouldRespondToTouchesCancelled:self];
    if (!should) return;
    
    if(!_wasDragged && touchMode==emjCCParallaxNodeTouchModeScroll) {
        [self unschedule:@selector(scrollTick:)];
        _xvel=0;
        _yvel=0;
    }
    
    _isDragging = FALSE;
    _wasDragged=FALSE;
    
    [self unschedule:@selector(scrollTick:)];
}
#pragma mark scrolling
- (void) scrollTick: (ccTime)dt {
	if (touchMode!=emjCCParallaxNodeTouchModeScroll) {
        [self unschedule:@selector(scrollTick:)];        
        return;
    }
    
	if ( _isDragging )
	{
        _xvel = ( self.position.x - _lastx ) / 2;
		_lastx = self.position.x;
        
		_yvel = ( self.position.y - _lasty ) / 2;
		_lasty = self.position.y;

        //normalize
        if (_xvel>_maxXvel) 
            _xvel=_maxXvel;

		if (_yvel>_maxYvel) 
            _yvel=_maxYvel;

	}
	else
	{
        // inertion
		_yvel *= friction;
        _xvel *= friction;
        
        if (fabs(_xvel)<.01 && fabs(_yvel)<.01) {
            [self unschedule:@selector(scrollTick:)];
            _xvel=0.0f;
            _yvel=0.0f;
            return;
        }
        
		CGPoint pos = self.position;
		pos.x += _xvel;
        pos.y += _yvel;
		self.position = pos;  
	}
}

#pragma mark contentSize
-(void)setPosition:(CGPoint)position{
    
    if (!CGRectEqualToRect(contentRect, CGRectZero)) {
        if (position.x<contentRect.origin.x) {
            position.x=contentRect.origin.x;
            if(!_isDragging){
                _xvel=0.0f;
                _yvel=0.0f;
            }
        }
        
        if (position.y<contentRect.origin.y) {
            position.y=contentRect.origin.y;
            if(!_isDragging){
                _xvel=0.0f;
                _yvel=0.0f;
            }

        }
        
        
        if (position.x>contentRect.origin.x+contentRect.size.width) {
            position.x=contentRect.origin.x+contentRect.size.width;
            if(!_isDragging){
                _xvel=0.0f;
                _yvel=0.0f;
            }

        }
        
        if (position.y>contentRect.origin.y+contentRect.size.height) {
            position.y=contentRect.origin.y+contentRect.size.height;
            if(!_isDragging){
                _xvel=0.0f;
                _yvel=0.0f;
            }

        }
    }
    
    
    BOOL should=TRUE;
    if ([delegate respondsToSelector:@selector(emjCCParallaxNode:shouldMoveToPosition:)]) 
        should= [delegate emjCCParallaxNode:self shouldMoveToPosition:position];
    if (!should) return;
    
    [super setPosition:position];
    
    
    
    if ([delegate respondsToSelector:@selector(emjCCParallaxNode:didMoveToPosition:)]) 
        [delegate emjCCParallaxNode:self didMoveToPosition:position];
    


}
@end
