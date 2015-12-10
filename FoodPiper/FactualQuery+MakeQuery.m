//
//  FactualQuery+MakeQuery.m
//  FoodPiper
//
//  Created by adeiji on 12/9/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

#import "FactualQuery+MakeQuery.h"

@implementation FactualQuery (MakeQuery)

+ (FactualQuery *) makeQuery
{
    return [FactualQuery query];
}

@end
