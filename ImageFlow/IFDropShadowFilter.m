//
//  IFDropShadowFilter.m
//  ImageFlow
//
//  Created by Michel Schinz on 04.01.07.
//  Copyright 2007 Michel Schinz. All rights reserved.
//

#import "IFDropShadowFilter.h"

#import "IFEnvironment.h"
#import "IFType.h"
#import "IFExpression.h"
#import "IFConstantExpression.h"
#import "IFBlendMode.h"

@implementation IFDropShadowFilter

- (NSArray*)computePotentialTypesForArity:(unsigned)arity;
{
  if (arity == 1)
    return [NSArray arrayWithObject:
            [IFType funTypeWithArgumentTypes:[NSArray arrayWithObject:[IFType imageRGBAType]]
                                  returnType:[IFType imageRGBAType]]];
  else
    return [NSArray array];
}

- (NSArray*)potentialRawExpressionsForArity:(unsigned)arity;
{
  if (arity == 1) {
    IFExpression* sh = [IFExpression primitiveWithTag:IFPrimitiveTag_SingleColor operands:
                        [IFExpression argumentWithIndex:0],
                        [IFExpression variableWithName:@"color"],
                        nil];
    IFExpression* trSh = [IFExpression primitiveWithTag:IFPrimitiveTag_Translate operands:sh, [IFExpression variableWithName:@"offset"], nil];
    IFExpression* blTrSh = [IFExpression primitiveWithTag:IFPrimitiveTag_GaussianBlur operands:trSh, [IFExpression variableWithName:@"blur"], nil];
    
    return [NSArray arrayWithObject:
            [IFExpression lambdaWithBody:
             [IFExpression blendBackground:blTrSh
                            withForeground:[IFExpression argumentWithIndex:0]
                                    inMode:[IFConstantExpression expressionWithInt:IFBlendMode_SourceOver]]]];
  } else {
    return [NSArray array];
  }
}

- (NSString*)computeLabel;
{
  return @"drop shadow";
}

@end
