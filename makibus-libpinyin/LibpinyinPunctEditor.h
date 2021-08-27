//
//  LibpinyinPunctEditor.h
//  macos-libpinyin
//
//  Created by inoki on 3/24/21.
//

#import <Foundation/Foundation.h>

#import "LibpinyinEditor.h"

@interface LibpinyinPunctEditor : NSObject<EditorProtocol> {
    NSMutableString *m_buffer;
    NSMutableString *m_text;
    NSMutableString *m_preeditText;
    NSMutableString *m_commitString;
    LookupTable *m_lookupTable;

    LibpinyinConfig *m_config;
}

- (id)initWithConfig:(LibpinyinConfig *) config;

- (BOOL)processSpaceWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processNumberWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processPunctWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;

@end
