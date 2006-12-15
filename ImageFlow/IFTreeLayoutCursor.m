//
//  IFTreeLayoutCursor.m
//  ImageFlow
//
//  Created by Michel Schinz on 16.08.05.
//  Copyright 2005 Michel Schinz. All rights reserved.
//

#import "IFTreeLayoutCursor.h"
#import "IFNodesView.h"

@implementation IFTreeLayoutCursor

+ (id)layoutCursorWithBase:(IFTreeLayoutSingle*)theBase pathWidth:(float)thePathWidth;
{
  return [[[self alloc] initWithBase:theBase pathWidth:thePathWidth] autorelease];
}

- (id)initWithBase:(IFTreeLayoutSingle*)theBase pathWidth:(float)thePathWidth;
{
  if (![super initWithBase:theBase])
    return nil;
  cursorPath = [[base outlinePath] copy];
  [cursorPath setLineWidth:thePathWidth];
  [self setBounds:NSInsetRect([cursorPath bounds], -thePathWidth, -thePathWidth)];
  return self;
}

- (void) dealloc;
{
  OBJC_RELEASE(cursorPath);
  [super dealloc];
}

- (void)drawForLocalRect:(NSRect)rect;
{
  [[[containingView layoutParameters] cursorColor] set];
  [cursorPath stroke];
}

@end
