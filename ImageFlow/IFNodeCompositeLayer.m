//
//  IFNodeCompositeLayer.m
//  ImageFlow
//
//  Created by Michel Schinz on 16.08.08.
//  Copyright 2008 Michel Schinz. All rights reserved.
//

#import "IFNodeCompositeLayer.h"
#import "IFDisplayedImageLayer.h"
#import "IFNodeLayer.h"
#import "IFLayoutParameters.h"

typedef enum {
  IFCompositeSublayerDisplayedImage,
  IFCompositeSublayerBase,
  IFCompositeSublayerHighlight,
} IFCompositeSublayer;

@implementation IFNodeCompositeLayer

+ (id)layerForNode:(IFTreeNode*)theNode ofTree:(IFTree*)theTree canvasBounds:(IFVariable*)theCanvasBoundsVar;
{
  return [[[self alloc] initWithNode:theNode ofTree:theTree canvasBounds:theCanvasBoundsVar] autorelease];
}

- (id)initWithNode:(IFTreeNode*)theNode ofTree:(IFTree*)theTree canvasBounds:(IFVariable*)theCanvasBoundsVar;
{
  if (![super init])
    return nil;

  self.zPosition = 1.0;
  
  const IFLayoutParameters* layoutParameters = [IFLayoutParameters sharedLayoutParameters];
  
  CALayer* baseLayer = [IFNodeLayer layerForNode:theNode ofTree:theTree canvasBounds:theCanvasBoundsVar];
  
  CALayer* displayedImageLayer = [IFDisplayedImageLayer displayedImageLayer];
  displayedImageLayer.frame = CGRectInset(baseLayer.frame, -25, 0); // TODO: use a parameter in the layout parameters
  displayedImageLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
  displayedImageLayer.hidden = YES;
  
  // Highlight (used for drag&drop)
  CALayer* highlightLayer = [CALayer layer];
  highlightLayer.anchorPoint = CGPointZero;
  highlightLayer.frame = baseLayer.frame;
  highlightLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
  highlightLayer.cornerRadius = baseLayer.cornerRadius;
  highlightLayer.hidden = YES;
  highlightLayer.backgroundColor = layoutParameters.highlightBackgroundColor;
  highlightLayer.borderColor = layoutParameters.highlightBorderColor;
  highlightLayer.borderWidth = layoutParameters.selectionWidth;

  [self addSublayer:displayedImageLayer];
  [self addSublayer:baseLayer];
  [self addSublayer:highlightLayer];

  return self;
}

- (BOOL)isNode;
{
  return YES;
}

- (CALayer*)displayedImageLayer;
{
  return [self.sublayers objectAtIndex:IFCompositeSublayerDisplayedImage];
}

- (IFNodeLayer*)baseLayer;
{
  return [self.sublayers objectAtIndex:IFCompositeSublayerBase];
}

- (CALayer*)highlightLayer;
{
  return [self.sublayers objectAtIndex:IFCompositeSublayerHighlight];
}
 
@end
