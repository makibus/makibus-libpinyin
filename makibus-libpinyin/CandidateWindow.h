//
//  CandidateWindow.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


@interface CandidateWindow : NSObject {
    NSWindow            *_window;
    NSView              *_view;
    NSMutableDictionary *_attr;

    NSColor             *_fgColor;
    NSColor             *_hlColor;
    NSFont              *_font;
}

-(void)setFont:(NSFont *)font;
-(NSFont*)font;

-(NSColor*)bgColor;
-(void)setBgColor:(NSColor*)color;

-(void)showCandidates:(NSArray*)candiArray around:(NSRect)cursorRect;
-(void)hideCandidates;

-(void)setRadius:(float)radius;

@property (retain, nonatomic) NSColor *fgColor;
@property (retain, nonatomic) NSColor *hlColor;

@end

