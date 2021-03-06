//
//  IFDocumentInspectorWindowController.m
//  ImageFlow
//
//  Created by Michel Schinz on 03.10.05.
//  Copyright 2005 Michel Schinz. All rights reserved.
//

#import "IFDocumentInspectorWindowController.h"

@implementation IFDocumentInspectorWindowController

-(id)init;
{
  if (![super initWithWindowNibName:@"IFDocumentSettings"])
    return nil;
  return self;
}

- (void)dealloc;
{
  [super dealloc];
}

- (void)documentDidChange:(IFDocument*)newDocument;
{
  [super documentDidChange:newDocument];
  [documentController setContent:newDocument];
  [canvasController setObject:newDocument andKey:@"canvasBounds"];
}

- (IBAction)applySettings:(id)sender;
{
  [documentController commitEditing];
}

@end
