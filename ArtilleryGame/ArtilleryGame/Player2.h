//
//  Player2.h
//  TankArtillery
//
//  Created by default on 4/12/12.
//  Copyright __Thai Vang__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"

@interface Player2 : CCLayer
{
    MyContactListener *contactListener;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    int scoreCount;
    CCLabelTTF *ScoreLabel;
    CCLabelTTF *PlayerLabel;
    NSString *score;
    
    //2nd catapult arm
    b2Fixture *armFixture2;
    b2Body *armBody2;
    b2RevoluteJoint *armJoint2;
    b2MouseJoint *mouseJoint;
    
    b2Body *groundBody;
    
    NSMutableArray *bullets2;
    int currentBullet2;
   
    b2Body *bulletBody2;
    b2WeldJoint *bulletJoint2;
    
    BOOL releasingArm2;
    
    //enemies
    NSMutableSet *targets;
    NSMutableSet *enemies;
    
}

// returns a CCScene
+(CCScene *) scene;

@end
