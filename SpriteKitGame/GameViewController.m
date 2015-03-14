//
//  ViewController.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 5/2/14.
//  Copyright (c) 2014 Sky Mist Development. All rights reserved.
//

#import "GameViewController.h"
#import "MyScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
   
    skView.ignoresSiblingOrder = YES;
    skView.showsFPS = YES;
    
    // Create and configure the scene.
    //SKScene * scene = [MyScene sceneWithSize:CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width)];
    MyScene * scene = [MyScene sceneWithSize:self.view.bounds.size];

    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
