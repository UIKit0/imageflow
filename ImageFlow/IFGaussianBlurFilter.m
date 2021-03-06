//
//  IFGaussianBlurFilter.m
//  ImageFlow
//
//  Created by Michel Schinz on 12.12.05.
//  Copyright 2005 Michel Schinz. All rights reserved.
//

#import "IFGaussianBlurFilter.h"

#import "IFEnvironment.h"
#import "IFType.h"
#import "IFExpression.h"

@implementation IFGaussianBlurFilter

- (NSArray*)computePotentialTypesForArity:(unsigned)arity;
{
  if (arity == 1) {
    IFType* imageType = [IFType imageTypeWithPixelType:[IFType typeVariable]];
    return [NSArray arrayWithObject:[IFType funTypeWithArgumentType:imageType returnType:imageType]];
  } else
    return [NSArray array];
}

- (IFExpression*)rawExpressionForArity:(unsigned)arity typeIndex:(unsigned)typeIndex;
{
  NSAssert(arity == 1 && typeIndex == 0, @"invalid arity or type index");
  return [IFExpression lambdaWithBody:
          [IFExpression primitiveWithTag:IFPrimitiveTag_GaussianBlur operands:
           [IFExpression argumentWithIndex:0],
           [IFConstantExpression expressionWithWrappedFloat:[settings valueForKey:@"radius"]],
           nil]];
}

- (NSString*)computeLabel;
{
  return [NSString stringWithFormat:@"blur (%.1f gaussian)", [(NSNumber*)[settings valueForKey:@"radius"] floatValue]];
}

@end
