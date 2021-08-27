//
//  LibpinyinEditor.h
//  macos-libpinyin
//
//  Created by inoki on 3/10/21.
//

#import <Foundation/Foundation.h>

#import "LibpinyinConfig.h"
#import "MakibusLibpinyinController.h"


@protocol EditorProtocol <NSObject>

- (BOOL)processKeyEventWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (void)pageUp;
- (void)pageDown;
- (void)cursorUp;
- (void)cursorDown;
- (void)update;
- (void)reset;
- (void)candidateClickedAt: (int)index withButton:(int) button andState:(int)state;

- (void)refresh:(id)client underController:(MakibusLibpinyinController *)conrtoller;

- (BOOL)insertCharacter:(char)ch;
- (void)commit:(NSString *)str;
- (void)commitEmpty;

- (void)updateLookupTable;
- (void)updateLookupTableFast;
- (void)updateAuxiliaryText;
- (void)updatePreeditText;

- (BOOL)moveCursorLeft;
- (BOOL)moveCursorRight;
- (BOOL)moveCursorLeftByWord;
- (BOOL)moveCursorRightByWord;
- (BOOL)moveCursorToBegin;
- (BOOL)moveCursorToEnd;

- (BOOL)removeCharBefore;
- (BOOL)removeCharAfter;

@end

#define MAX_PINYIN_LEN 64

@protocol LibpinyinEditorProtocol <EditorProtocol>

/* Public methods from PhoneticEditor */
- (BOOL)processSpaceWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processFunctionKeyWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)updateCandidates;
- (BOOL)fillLookupTable;

- (NSUInteger)getPinyinCursor;
- (NSUInteger)getLookupCursor;

- (BOOL)removeWordBefore;
- (BOOL)removeWordAfter;
- (void)updatePinyin;

- (NSUInteger)getCursorLeftByWord;
- (NSUInteger)getCursorRightByWord;

/* Methods from PinyinEditor */
- (BOOL)processPinyinWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processNumberWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;
- (BOOL)processPunctWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers;

/* Instance */
- (pinyin_instance_t *)getPinyinInstance;
- (NSString *)getText;

@end

@protocol LookupTableProtocol <NSObject>

- (void)setPageSize:(NSUInteger)size;
- (void)setCursorPos:(NSUInteger)pos;
- (NSUInteger)pageSize;
- (NSUInteger)cursorPos;
- (NSUInteger)size;

- (void)clear;
- (void)pageUp;
- (void)pageDown;
- (void)cursorUp;
- (void)cursorDown;

@end

@interface LookupTable : NSObject<LookupTableProtocol> {
    NSUInteger m_size;
    NSUInteger m_pageSize;
    NSUInteger m_pos;
    NSUInteger m_cursor;
    NSUInteger m_pageNumber;
}

- (id)initWithPageSize:(NSUInteger)size;

@end
