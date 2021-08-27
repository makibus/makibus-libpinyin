//
//  CandidateWindow.m
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import "Carbon/Carbon.h"
#import "CandidateWindow.h"

static void tuningFrameForScreen (NSRect *, NSSize, NSRect);

@interface CandidateView : NSView {
    NSAttributedString  *_string;
    NSColor             *_bgColor;
    float                _radius;
}

-(void)setAttributedString:(NSAttributedString *)str;
-(void)setBgColor:(NSColor*)color;

@property (retain, nonatomic) NSColor *bgColor;

@end

@implementation CandidateView

@synthesize bgColor  = _bgColor;

-(void)setAttributedString:(NSAttributedString *)str
{
    _string = str;
    [self setNeedsDisplay:YES];
}

-(void)setRadius:(float)radius
{
    _radius = radius;
}

- (void)drawRect:(NSRect)rect
{
    if (!_string)
        return;

    [[NSColor clearColor] set];
    NSRectFill([self bounds]);

    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:_radius yRadius:_radius];
    [_bgColor set];
    [path fill];

    NSPoint stringOrigin;
    NSSize stringSize = [_string size];
    stringOrigin.x = rect.origin.x + (rect.size.width  - stringSize.width)/2;
    stringOrigin.y = rect.origin.y + (rect.size.height - stringSize.height + 1)/2;

    [_string drawAtPoint:stringOrigin];
}

@end

@implementation CandidateWindow

@synthesize fgColor  = _fgColor;
@synthesize hlColor  = _hlColor;

-(id)init
{
    _font = [NSFont systemFontOfSize:16];
    _fgColor = [NSColor whiteColor];
    _hlColor = [NSColor blueColor];

    _attr = [[NSMutableDictionary alloc] init];
    [_attr setObject:_fgColor forKey:NSForegroundColorAttributeName];
    [_attr setObject:_font forKey:NSFontAttributeName];

    _window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,0,0)
                                styleMask:NSWindowStyleMaskBorderless
                                backing:NSBackingStoreBuffered
                                defer:NO];

    [_window setAlphaValue:1.0];
    [_window setLevel:NSScreenSaverWindowLevel+1];
    [_window setHasShadow:YES];
    [_window setOpaque:NO];

    _view = [[CandidateView alloc] initWithFrame:[[_window contentView] frame]];
    [_window setContentView:_view];
    
    return self;
}

-(NSFont *)font
{
    return _font;
}

-(void)setFont:(NSFont*)font
{
    _font = font;
    [_attr setObject:_font forKey:NSFontAttributeName];
}

-(NSColor*)bgColor
{
    return [(CandidateView*)_view bgColor];
}

-(void)setBgColor:(NSColor*)color
{
    [(CandidateView*)_view setBgColor:color];
}

-(void)setRadius:(float)radius
{
    [(CandidateView*)_view setRadius:radius];
}

-(void)showCandidates:(NSArray *)candiArray around:(NSRect)cursorRect
{
    if ([candiArray count] == 0) {
        [self hideCandidates];
        return;
    }

    [_attr setObject:_fgColor forKey:NSForegroundColorAttributeName];
    [_attr setObject:_font forKey:NSFontAttributeName];

    int i;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    for (i=0; i<[candiArray count]; i++) {
        NSString *str = [NSString stringWithFormat:@"%d.%@ ", i+1, [candiArray objectAtIndex:i]];
        NSAttributedString *astr = [[NSAttributedString alloc] initWithString:str attributes:_attr];
        [string appendAttributedString:astr];
        
        if (i==0)
            [string addAttribute:NSForegroundColorAttributeName
                    value:_hlColor
                    range:NSMakeRange(0, [str length])];
    }
    
    NSRect winRect = [_window frame];
    NSSize strSize = [string size];

    tuningFrameForScreen (&winRect, strSize, cursorRect);
    
    [(CandidateView*)_view setAttributedString:string];

    [_window setFrame:winRect display:YES animate:NO];
    [_window orderFront:nil];
}

-(void)hideCandidates
{
    [_window orderOut:self];
}

@end

static void tuningFrameForScreen (NSRect *winRect, NSSize strSize, NSRect cursorRect)
{
    /* calculate the initial window's size */
    winRect->size.height = strSize.height+5;
    winRect->size.width = strSize.width+5;
    winRect->origin.x = cursorRect.origin.x + 2;
    winRect->origin.y = cursorRect.origin.y - winRect->size.height -2;

    /* find a proper screen by input cursor */
    NSRect screenRect = [[NSScreen mainScreen] frame];
    NSArray *screens =[NSScreen screens];
    int i, num_of_scrs = [screens count];

    /* no choices, just use mainScreen */
    if (num_of_scrs == 1)
        goto FOUND_SCREEN;

    for (i=0; i<num_of_scrs; i++) {
        NSScreen *screen = [screens objectAtIndex:i];
        NSRect rect = [screen frame];
        if (NSPointInRect (cursorRect.origin, rect)) {
            screenRect = rect;
            goto FOUND_SCREEN;
        }
    }

    /* find a proper screen by mouse position */
    HIPoint p;
    HIGetMousePosition (kHICoordSpaceScreenPixel, NULL, &p);
    NSPoint mousePosition;
    mousePosition.x = p.x;
    mousePosition.y = screenRect.size.height - p.y;

    for (i=0; i<num_of_scrs; i++) {
        NSScreen *screen = [screens objectAtIndex:i];
        NSRect rect = [screen frame];
        if (NSPointInRect (mousePosition, rect)) {
            screenRect = rect;
            goto FOUND_SCREEN;
        }
    }

FOUND_SCREEN:;
    CGFloat min_x = NSMinX (screenRect), max_x = NSMaxX (screenRect);
    CGFloat min_y = NSMinY (screenRect);

    if (winRect->origin.x > max_x - winRect->size.width)
        winRect->origin.x = max_x - winRect->size.width;

    if (winRect->origin.x < min_x)
        winRect->origin.x = min_x;

    if (winRect->origin.y < min_y)
        winRect->origin.y = cursorRect.origin.y > min_y?
                            cursorRect.origin.y + cursorRect.size.height + 2:
                            min_y;
}
