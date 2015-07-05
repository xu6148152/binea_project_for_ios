//
//  CardMatchingGame.m
//  Machismo
//
//  Created by Binea Xu on 7/5/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;

@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation CardMatchingGame

-(NSMutableArray*)cards{
    if(!_cards){
        _cards = [[NSMutableArray alloc] init];
        
    }
    return _cards;
}

- (instancetype)initWithCardCount: (NSInteger) count usingDeck: (Deck*)deck{
    self = [super init];
    if(self){
        for (int i =0; i<count; i++){
            Card *card = [deck drawRandomCard];
            if(card){
                [self.cards addObject: card];
            }else{
                self = nil;
                break;
            }
            
        }
    }
    
    return self;
    
}

- (Card*)cardAtIndex:(NSInteger)index{
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index{
    
}


@end
