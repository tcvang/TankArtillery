//
//  AppDelegate.h
//  ArtilleryGame
//
//  Created by default on 4/16/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end


/*
 The app runs, plays well, and looks fairly good. Good first effort, and props for
 teaching yourself Cocos2d.
 
 I'm disappointed, though, that you merely implemented a tutorial app. Also, you
 made some questionable decisions on coding style. For example, most of the code
 in Player1 and Player2 is identical. Why not use object-oriented design principles
 and have them both inherit from a Player superclass? You also avoid the standard
 Model-View-Controller paradigm and have all your logic munged together, which is
 admittedly harder to do when using OpenGL.
 
 Grade: 80%
 Course grade: 82% (B)
*/