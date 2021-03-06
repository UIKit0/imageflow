//
//  IFTreeNodeFilter.h
//  ImageFlow
//
//  Created by Michel Schinz on 22.09.07.
//  Copyright 2007 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFTreeNode.h"
#import "IFExpression.h"
#import "IFEnvironment.h"
#import "IFType.h"

@interface IFTreeNodeFilter : IFTreeNode<NSCoding> {
  IFEnvironment* settings;
  unsigned activeTypeIndex;
  NSMutableDictionary* parentExpressions;
  IFType* type;
  NSNib* settingsNib;

  // Potential types cache
  NSArray* cachedTypes;
  unsigned firstVectorizedTypeIndex;
  NSArray* cachedVectorizationInfo;
  unsigned cachedTypesArity;
}

+ (id)nodeWithFilterNamed:(NSString*)theFilterName settings:(IFEnvironment*)theSettings;
- (id)initWithSettings:(IFEnvironment*)theSettings;

- (NSArray*)instantiateSettingsNibWithOwner:(NSObject*)owner;

// MARK: -
// MARK: PROTECTED

- (void)clearPotentialTypesCache;
- (NSArray*)computePotentialTypesForArity:(unsigned)arity;
- (IFExpression*)rawExpressionForArity:(unsigned)arity typeIndex:(unsigned)typeIndex;

@end
