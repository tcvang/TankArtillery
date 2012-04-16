//
//  Player2.mm
//  TankArtillery
//
//  Created by default on 4/12/12.
//  Copyright __Thai Vang__ 2012. All rights reserved.
//
//USED FOLLOWING TUTORIAL: 
//http://www.raywenderlich.com/4756/how-to-make-a-catapult-shooting-game-with-cocos2d-and-box2d-part-1

// Import the interfaces

#import "Player2.h"
#import "Player1.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define FLOOR_HEIGHT 40.0f

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


@implementation Player2

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Player2 *layer = [Player2 node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


//following function creates bullets for second catapult
- (void)createBullets2:(int)count
{
    currentBullet2 = 0;
    CGFloat pos = 800.0f;
    
    if (count > 0)
    {
        // delta is the spacing between bullets
        // 800 is the position of the screen where we want the bullets to start appearing
        // 900 is the position on the screen where we want the bullets to stop appearing
        // 30 is the size of the bullet
        CGFloat delta = (count > 1)?((900.0f - 800.0f - 30.0f) / (count - 1)):0.0f;
        
        bullets2 = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i=0; i<count; i++, pos+=delta)
        {
            // Create the bullet
            //
            CCSprite *sprite = [CCSprite spriteWithFile:@"bullet.png"];
            [self addChild:sprite z:1];
            
            b2BodyDef bulletBodyDef2;
            bulletBodyDef2.type = b2_dynamicBody;
            bulletBodyDef2.bullet = true;
            bulletBodyDef2.position.Set(pos/PTM_RATIO,(FLOOR_HEIGHT+15.0f)/PTM_RATIO);
            bulletBodyDef2.userData = sprite;
            b2Body *bullet2 = world->CreateBody(&bulletBodyDef2);
            bullet2->SetActive(false);
            
            b2CircleShape circle;
            circle.m_radius = 15.0/PTM_RATIO;
            
            b2FixtureDef ballShapeDef2;
            ballShapeDef2.shape = &circle;
            ballShapeDef2.density = 0.8f;
            ballShapeDef2.restitution = 0.2f;
            ballShapeDef2.friction = 0.99f;
            bullet2->CreateFixture(&ballShapeDef2);
            
            [bullets2 addObject:[NSValue valueWithPointer:bullet2]];
        }
    }
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);	
        
        ScoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:20];
        [ScoreLabel setPosition:ccp(screenSize.width-100, screenSize.height-10)];
        [ScoreLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        [self addChild:ScoreLabel];
        
        PlayerLabel = [CCLabelTTF labelWithString:@"Player 2" fontName:@"Helvetica" fontSize:20];
        [PlayerLabel setPosition:ccp(screenSize.width+400, screenSize.height-10)];
        [PlayerLabel setColor:ccc3(0.0f, 0.0f, 0.0f)];
        [self addChild:PlayerLabel];
        
        //start of code, add sprites/background to scene
        CCSprite *sprite = [CCSprite spriteWithFile:@"bg.png"];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:-1];
                
        sprite = [CCSprite spriteWithFile:@"catapult_base_2.png"];
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(680.0f, FLOOR_HEIGHT);
        [self addChild:sprite z:0];

        sprite = [CCSprite spriteWithFile:@"catapult_base_1.png"];
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(680.0f, FLOOR_HEIGHT);
        [self addChild:sprite z:9];
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
        // bottom
        groundBox.SetAsEdge(b2Vec2(0,FLOOR_HEIGHT/PTM_RATIO), b2Vec2(screenSize.width*2.0f/PTM_RATIO,FLOOR_HEIGHT/PTM_RATIO));
        groundBody->CreateFixture(&groundBox,0);
        
        //create second catapult
        CCSprite *arm2 = [CCSprite spriteWithFile:@"catapult_arm2.png"];
        [self addChild:arm2 z:1];
        
        b2BodyDef armBodyDef2;
        armBodyDef2.type = b2_dynamicBody;
        armBodyDef2.linearDamping = 1;
        armBodyDef2.angularDamping = 1;
        armBodyDef2.position.Set(730.0f/PTM_RATIO,(FLOOR_HEIGHT+111.0f)/PTM_RATIO);
        armBodyDef2.userData = arm2;
        armBody2 = world->CreateBody(&armBodyDef2);
        
        b2PolygonShape armBox2;
        b2FixtureDef armBoxDef2;
        armBoxDef2.shape = &armBox2;
        armBoxDef2.density = 0.3F;
        armBox2.SetAsBox(11.0f/PTM_RATIO, 91.0f/PTM_RATIO);
        armFixture2 = armBody2->CreateFixture(&armBoxDef2);
        
        //creates joint on the catapult
        b2RevoluteJointDef armJointDef2;
        armJointDef2.Initialize(groundBody, armBody2, b2Vec2(733.0f/PTM_RATIO, FLOOR_HEIGHT/PTM_RATIO));
        armJointDef2.enableMotor = true;
        armJointDef2.enableLimit = true;
        armJointDef2.motorSpeed  = 10;
        armJointDef2.lowerAngle  = CC_DEGREES_TO_RADIANS(-45);
        armJointDef2.upperAngle  = CC_DEGREES_TO_RADIANS(-10);
        armJointDef2.maxMotorTorque = 700;
        
        armJoint2 = (b2RevoluteJoint*)world->CreateJoint(&armJointDef2);
        
        contactListener = new MyContactListener();
        world->SetContactListener(contactListener);
        
        //delay added so cannon ball appears correctly in place
        [self performSelector:@selector(resetGame) withObject:nil afterDelay:.7f];
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint != nil) return;
    
    //following converts touches on screen to the 'world' coordinates that game uses
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    if (locationWorld.x < armBody2->GetWorldCenter().x + 50.0/PTM_RATIO)
    {
        b2MouseJointDef md;
        md.bodyA = groundBody;
        md.bodyB = armBody2;
        md.target = locationWorld;
        md.maxForce = 1000;
        
        mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint == nil) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    mouseJoint->SetTarget(locationWorld);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mouseJoint!= nil)
    {
        if (armJoint2->GetJointAngle() <= CC_DEGREES_TO_RADIANS(-20))
        {
            releasingArm2 = YES;
        }
        world->DestroyJoint(mouseJoint);
        mouseJoint = nil;
    }
}

- (BOOL)attachBullet2
{
    if (currentBullet2 < [bullets2 count])
    {
        bulletBody2 = (b2Body*)[[bullets2 objectAtIndex:currentBullet2++] pointerValue];
        bulletBody2->SetTransform(b2Vec2(730.0f/PTM_RATIO, (175.0f+FLOOR_HEIGHT)/PTM_RATIO), 0.0f);
        bulletBody2->SetActive(true);
        
        b2WeldJointDef weldJointDef2;
        weldJointDef2.Initialize(bulletBody2, armBody2, b2Vec2(730.0f/PTM_RATIO,(175.0f+FLOOR_HEIGHT)/PTM_RATIO));
        weldJointDef2.collideConnected = false;
        
        bulletJoint2 = (b2WeldJoint*)world->CreateJoint(&weldJointDef2);
        return YES;
    }
    
    return NO;
}

- (void)resetBullet
{
    if ([enemies count] == 0)
    {
        [[CCDirector sharedDirector] replaceScene: [Player1 scene]];    
    }
    else if ([self attachBullet2])
    {
        [self runAction:[CCMoveTo actionWithDuration:2.0f position:CGPointZero]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene: [Player1 scene]];    
    }
}

- (void)createTarget:(NSString*)imageName
          atPosition:(CGPoint)position
            rotation:(CGFloat)rotation
            isCircle:(BOOL)isCircle
            isStatic:(BOOL)isStatic
             isEnemy:(BOOL)isEnemy
{
    CCSprite *sprite = [CCSprite spriteWithFile:imageName];
    [self addChild:sprite z:1];
    
    b2BodyDef bodyDef;
    bodyDef.type = isStatic?b2_staticBody:b2_dynamicBody;
    bodyDef.position.Set((position.x+sprite.contentSize.width/2.0f)/PTM_RATIO,
                         (position.y+sprite.contentSize.height/2.0f)/PTM_RATIO);
    bodyDef.angle = CC_DEGREES_TO_RADIANS(rotation);
    bodyDef.userData = sprite;
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2FixtureDef boxDef;
    if (isCircle)
    {
        b2CircleShape circle;
        circle.m_radius = sprite.contentSize.width/2.0f/PTM_RATIO;
        boxDef.shape = &circle;
    }
    else
    {
        b2PolygonShape box;
        box.SetAsBox(sprite.contentSize.width/2.0f/PTM_RATIO, sprite.contentSize.height/2.0f/PTM_RATIO);
        boxDef.shape = &box;
    }
    
    if (isEnemy)
    {
        boxDef.userData = (void*)1;
        [enemies addObject:[NSValue valueWithPointer:body]];
    }
    
    boxDef.density = 0.5f;
    body->CreateFixture(&boxDef);
    
    [targets addObject:[NSValue valueWithPointer:body]];
}

- (void)createTargets
{
    [targets release];
    [enemies release];
    targets = [[NSMutableSet alloc] init];
    enemies = [[NSMutableSet alloc] init];
    
    // Create targets to destroy
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(0.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(30.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(60.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];    
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(90.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(120.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(150.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(180.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];    
    [self createTarget:@"soldier-2enemies.png" atPosition:CGPointMake(210.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES];
    
}


- (void)resetGame
{
    // Previous targets cleanup
    if (targets)
    {
        for (NSValue *bodyValue in targets)
        {
            b2Body *body = (b2Body*)[bodyValue pointerValue];
            CCNode *node = (CCNode*)body->GetUserData();
            [self removeChild:node cleanup:YES];
            world->DestroyBody(body);
        }
        [targets release];
        [enemies release];
        targets = nil;
        enemies = nil;
    }
    
    self.position = CGPointMake(-480, 0);
    [self createTargets];
    [self createBullets2:1];
    [self attachBullet2];
}

-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}

    // Arm1 is being released.
    if (releasingArm2 && bulletJoint2)
    {
        // Check if the arm reached the end so we can return the limits
        if (armJoint2->GetJointAngle() <= CC_DEGREES_TO_RADIANS(-10))
        {
            releasingArm2 = NO;
            
            // Destroy joint so the bullet will be free
            world->DestroyJoint(bulletJoint2);
            
            [self performSelector:@selector(resetBullet) withObject:nil afterDelay:4.0f];
            bulletJoint2 = nil;
        }
    }
    
    // Bullet is moving. Used to add camera movement to bullet
    if (bulletBody2 && bulletJoint2 == nil)
    {
        b2Vec2 position = bulletBody2->GetPosition();
        CGPoint myPosition = self.position;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // Move the camera.
        if (position.x > screenSize.width / 2.0f / PTM_RATIO)
        {
            myPosition.x = -MIN(screenSize.width * 2.0f - screenSize.width, position.x * PTM_RATIO - screenSize.width / 2.0f);
            self.position = myPosition;
        }
    }
    
    //Check for impacts
    std::set<b2Body*>::iterator pos;
    for(pos = contactListener->contacts.begin();
        pos != contactListener->contacts.end(); ++pos)
    {
        b2Body *body = *pos;
        
        CCNode *contactNode = (CCNode*)body->GetUserData();
        CGPoint position = contactNode.position;
        [self removeChild:contactNode cleanup:YES];
        world->DestroyBody(body);
        
        scoreCount++;
        score = [NSString stringWithFormat:@"Score: %d", scoreCount];
        [ScoreLabel setString:score];
        
        [targets removeObject:[NSValue valueWithPointer:body]];
        [enemies removeObject:[NSValue valueWithPointer:body]];
        
        CCParticleSun* explosion = [[CCParticleSun alloc] initWithTotalParticles:200];
        explosion.autoRemoveOnFinish = YES;
        explosion.startSize = 10.0f;
        explosion.speed = 70.0f;
        explosion.anchorPoint = ccp(0.5f,0.5f);
        explosion.position = position;
        explosion.duration = 1.0f;
        [self addChild:explosion z:11];
        [explosion release];
    }
    
    // remove everything from the set
    contactListener->contacts.clear();
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
    [bullets2 release];
    [targets release];
    [enemies release];
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
