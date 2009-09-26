//
//  IFStackFilter.m
//  ImageFlow
//
//  Created by Michel Schinz on 28.11.08.
//  Copyright 2008 Michel Schinz. All rights reserved.
//

#import "IFStackFilter.h"

#import "IFType.h"
#import "IFExpression.h"

@implementation IFStackFilter

- (NSArray*)computePotentialTypesForArity:(unsigned)arity;
{
  IFType* typeVar = [IFType typeVariable];
  IFType* retType = [IFType arrayTypeWithContentType:typeVar];
  if (arity == 0)
    return [NSArray arrayWithObject:retType];
  else {
    NSMutableArray* argTypes = [NSMutableArray arrayWithCapacity:arity];
    for (int i = 0; i < arity; ++i)
      [argTypes addObject:typeVar];
    return [NSArray arrayWithObject:[IFType funTypeWithArgumentTypes:argTypes returnType:retType]];
  }
}

- (NSArray*)potentialRawExpressionsForArity:(unsigned)arity;
{
  NSMutableArray* operands = [NSMutableArray arrayWithCapacity:arity];
  for (unsigned i = 0; i < arity; ++i)
    [operands addObject:[IFExpression argumentWithIndex:arity - (i + 1)]];
  IFExpression* expr = [IFExpression primitiveWithTag:IFPrimitiveTag_ArrayCreate operandsArray:operands];
  for (unsigned i = 0; i < arity; ++i)
    expr = [IFExpression lambdaWithBody:expr];
  return [NSArray arrayWithObject:expr];
}

- (NSString*)nameOfParentAtIndex:(int)index;
{
  return [NSString stringWithFormat:@"#%d",index];
}

- (NSString*)computeLabel;
{
  return @"stack";
}

@end
