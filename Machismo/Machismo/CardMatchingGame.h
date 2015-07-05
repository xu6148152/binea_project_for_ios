//
//  CardMatchingGame.h
//  Machismo
//
//  Created by Binea Xu on 7/5/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount: (NSInteger) count usingDeck: (Deck*)deck;

-(void)chooseCardAtIndex: (NSUInteger)index;

-(Card*)cardAtIndex: (NSInteger)index;

@property (nonatomic, readonly) NSInteger score;


@end
