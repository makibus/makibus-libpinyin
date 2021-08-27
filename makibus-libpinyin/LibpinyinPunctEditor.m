//
//  LibpinyinPunctEditor.m
//  macos-libpinyin
//
//  Created by inoki on 3/24/21.
//

#import "LibpinyinPunctEditor.h"
#import "LibpinyinEditor.h"
#import "Utils.h"

// Punction table from https://github.com/libpinyin/ibus-libpinyin/blob/master/src/PYPunctTable.h
static const char * const puncts[] = {
    "", "·", "，", "。", "「", "」", "、", "：", "；", "？", "！", NULL,
    "!", "！", "﹗", "‼", "⁉", NULL,
    "\"", "“", "”", "＂", NULL,
    "#", "＃", "﹟", "♯", NULL,
    "$", "＄", "€", "﹩", "￠", "￡", "￥", NULL,
    "%", "％", "﹪", "‰", "‱", "㏙", "㏗", NULL,
    "&", "＆", "﹠", NULL,
    "'", "、", "‘", "’", NULL,
    "(", "（", "︵", "﹙", NULL,
    ")", "）", "︶", "﹚", NULL,
    "*", "＊", "×", "※", "╳", "﹡", "⁎", "⁑", "⁂", "⌘", NULL,
    "+", "＋", "±", "﹢", NULL,
    ",", "，", "、", "﹐", "﹑", NULL,
    "-", "…", "—", "－", "¯", "﹉", "￣", "﹊", "ˍ", "–", "‥", NULL,
    ".", "。", "·", "‧", "﹒", "．", NULL,
    "/", "／", "÷", "↗", "↙", "∕", NULL,
    "0", "０", "0", NULL,
    "1", "１", "1", NULL,
    "2", "２", "2", NULL,
    "3", "３", "3", NULL,
    "4", "４", "4", NULL,
    "5", "５", "5", NULL,
    "6", "６", "6", NULL,
    "7", "７", "7", NULL,
    "8", "８", "8", NULL,
    "9", "９", "9", NULL,
    ":", "：", "︰", "﹕", NULL,
    ";", "；", "﹔", NULL,
    "<", "＜", "〈", "《", "︽", "︿", "﹤", NULL,
    "=", "＝", "≒", "≠", "≡", "≦", "≧", "﹦", NULL,
    ">", "＞", "〉", "》", "︾", "﹀", "﹥", NULL,
    "?", "？", "﹖", "⁇", "⁈", NULL,
    "@", "＠", "⊕", "⊙", "㊣", "﹫", "◉", "◎", NULL,
    "A", "Ａ", "A", NULL,
    "B", "Ｂ", "B", NULL,
    "C", "Ｃ", "C", NULL,
    "D", "Ｄ", "D", NULL,
    "E", "Ｅ", "E", NULL,
    "F", "Ｆ", "F", NULL,
    "G", "Ｇ", "G", NULL,
    "H", "Ｈ", "H", NULL,
    "I", "Ｉ", "I", NULL,
    "J", "Ｊ", "J", NULL,
    "K", "Ｋ", "K", NULL,
    "L", "Ｌ", "L", NULL,
    "M", "Ｍ", "M", NULL,
    "N", "Ｎ", "N", NULL,
    "O", "Ｏ", "O", NULL,
    "P", "Ｐ", "P", NULL,
    "Q", "Ｑ", "Q", NULL,
    "R", "Ｒ", "R", NULL,
    "S", "Ｓ", "S", NULL,
    "T", "Ｔ", "T", NULL,
    "U", "Ｕ", "U", NULL,
    "V", "Ｖ", "V", NULL,
    "W", "Ｗ", "W", NULL,
    "X", "Ｘ", "X", NULL,
    "Y", "Ｙ", "Y", NULL,
    "Z", "Ｚ", "Z", NULL,
    "[", "「", "［", "『", "【", "｢", "︻", "﹁", "﹃", NULL,
    "\\", "＼", "↖", "↘", "﹨", NULL,
    "]", "」", "］", "』", "】", "｣", "︼", "﹂", "﹄", NULL,
    "^", "︿", "〈", "《", "︽", "﹤", "＜", NULL,
    "_", "＿", "╴", "←", "→", NULL,
    "`", "‵", "′", NULL,
    "a", "ａ", "a", NULL,
    "b", "ｂ", "b", NULL,
    "c", "ｃ", "c", NULL,
    "d", "ｄ", "d", NULL,
    "e", "ｅ", "e", NULL,
    "f", "ｆ", "f", NULL,
    "g", "ｇ", "g", NULL,
    "h", "ｈ", "h", NULL,
    "i", "ｉ", "i", NULL,
    "j", "ｊ", "j", NULL,
    "k", "ｋ", "k", NULL,
    "l", "ｌ", "l", NULL,
    "m", "ｍ", "m", NULL,
    "n", "ｎ", "n", NULL,
    "o", "ｏ", "o", NULL,
    "p", "ｐ", "p", NULL,
    "q", "ｑ", "q", NULL,
    "r", "ｒ", "r", NULL,
    "s", "ｓ", "s", NULL,
    "t", "ｔ", "t", NULL,
    "u", "ｕ", "u", NULL,
    "v", "ｖ", "v", NULL,
    "w", "ｗ", "w", NULL,
    "x", "ｘ", "x", NULL,
    "y", "ｙ", "y", NULL,
    "z", "ｚ", "z", NULL,
    "{", "｛", "︷", "﹛", "〔", "﹝", "︹", NULL,
    "|", "｜", "↑", "↓", "∣", "∥", "︱", "︳", "︴", "￤", NULL,
    "}", "｝", "︸", "﹜", "〕", "﹞", "︺", NULL,
    "~", "～", "﹋", "﹌", NULL,
};

static const char * const * punct_table[] = {
    &puncts[0],    // ""
    &puncts[12],    // "!"
    &puncts[18],    // "\""
    &puncts[23],    // "#"
    &puncts[28],    // "$"
    &puncts[36],    // "%"
    &puncts[44],    // "&"
    &puncts[48],    // "'"
    &puncts[53],    // "("
    &puncts[58],    // ")"
    &puncts[63],    // "*"
    &puncts[74],    // "+"
    &puncts[79],    // ","
    &puncts[85],    // "-"
    &puncts[97],    // "."
    &puncts[104],    // "/"
    &puncts[111],    // "0"
    &puncts[115],    // "1"
    &puncts[119],    // "2"
    &puncts[123],    // "3"
    &puncts[127],    // "4"
    &puncts[131],    // "5"
    &puncts[135],    // "6"
    &puncts[139],    // "7"
    &puncts[143],    // "8"
    &puncts[147],    // "9"
    &puncts[151],    // ":"
    &puncts[156],    // ";"
    &puncts[160],    // "<"
    &puncts[168],    // "="
    &puncts[177],    // ">"
    &puncts[185],    // "?"
    &puncts[191],    // "@"
    &puncts[200],    // "A"
    &puncts[204],    // "B"
    &puncts[208],    // "C"
    &puncts[212],    // "D"
    &puncts[216],    // "E"
    &puncts[220],    // "F"
    &puncts[224],    // "G"
    &puncts[228],    // "H"
    &puncts[232],    // "I"
    &puncts[236],    // "J"
    &puncts[240],    // "K"
    &puncts[244],    // "L"
    &puncts[248],    // "M"
    &puncts[252],    // "N"
    &puncts[256],    // "O"
    &puncts[260],    // "P"
    &puncts[264],    // "Q"
    &puncts[268],    // "R"
    &puncts[272],    // "S"
    &puncts[276],    // "T"
    &puncts[280],    // "U"
    &puncts[284],    // "V"
    &puncts[288],    // "W"
    &puncts[292],    // "X"
    &puncts[296],    // "Y"
    &puncts[300],    // "Z"
    &puncts[304],    // "["
    &puncts[314],    // "\\"
    &puncts[320],    // "]"
    &puncts[330],    // "^"
    &puncts[338],    // "_"
    &puncts[344],    // "`"
    &puncts[348],    // "a"
    &puncts[352],    // "b"
    &puncts[356],    // "c"
    &puncts[360],    // "d"
    &puncts[364],    // "e"
    &puncts[368],    // "f"
    &puncts[372],    // "g"
    &puncts[376],    // "h"
    &puncts[380],    // "i"
    &puncts[384],    // "j"
    &puncts[388],    // "k"
    &puncts[392],    // "l"
    &puncts[396],    // "m"
    &puncts[400],    // "n"
    &puncts[404],    // "o"
    &puncts[408],    // "p"
    &puncts[412],    // "q"
    &puncts[416],    // "r"
    &puncts[420],    // "s"
    &puncts[424],    // "t"
    &puncts[428],    // "u"
    &puncts[432],    // "v"
    &puncts[436],    // "w"
    &puncts[440],    // "x"
    &puncts[444],    // "y"
    &puncts[448],    // "z"
    &puncts[452],    // "{"
    &puncts[460],    // "|"
    &puncts[471],    // "}"
    &puncts[479],    // "~"
};


enum PunctMode {
    MODE_DISABLE,
    MODE_INIT,
    MODE_NORMAL,
};

@implementation LibpinyinPunctEditor {
    BOOL m_shouldShowLookupTable;
    BOOL m_shouldPreeditText;
    BOOL m_shouldCommitString;

    enum PunctMode m_mode;

    NSUInteger m_cursor;

    NSMutableArray *m_selected_puncts;
    NSMutableArray *m_punct_candidates;
}

- (void)candidateClickedAt:(int)index withButton:(int)button andState:(int)state {
    return;
}

- (void)cursorDown {
}

- (void)cursorUp {
}

- (void)pageDown {
}

- (void)pageUp {
}

- (BOOL)processKeyEventWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    modifiers = filter_modifier(modifiers);

    BOOL ret = NO;
    switch (keyval) {
        case ' ':
            ret = [self processSpaceWithKeyValue:keyval keyCode:keycode modifiers:modifiers];
            break;
        case kVK_Escape:
            [self reset];
            ret = YES;
            break;
        case kVK_Return:
            [self commit:m_text];
            return TRUE;
            break;
        case kVK_Delete:
            [self removeCharBefore];
            ret = YES;
            break;
        case kVK_ForwardDelete:
            [self removeCharAfter];
            ret = YES;
            break;
        case kVK_LeftArrow:
            [self moveCursorLeft];
            ret = YES;
            break;
        case kVK_RightArrow:
            [self moveCursorRight];
            ret = YES;
            break;
        case kVK_Home:
            [self moveCursorToBegin];
            ret = YES;
            break;
        case kVK_End:
            ret = YES;
            break;
        case kVK_UpArrow:
            [self cursorUp];
            ret = YES;
            break;
        case kVK_DownArrow:
            [self cursorDown];
            ret = YES;
            break;
        case kVK_PageUp:
            [self pageUp];
            ret = YES;
            break;
        case kVK_PageDown:
        case kVK_Tab:
            [self pageDown];
            ret = YES;
            break;
        default:
            break;
    }
    return ret;
}

- (void)refresh:(id)client underController:(MakibusLibpinyinController *)conrtoller {
}

- (void)reset {
    m_mode = MODE_DISABLE;
    [m_selected_puncts removeAllObjects];
    [m_punct_candidates removeAllObjects];

    bool need_update = (m_cursor != 0 || [m_text length] != 0);
    m_cursor = 0;
    [m_text setString:@""];
    if (need_update)
        [self update];
}

- (void)update {
    [self updateLookupTable];
    [self updatePreeditText];
    [self updateAuxiliaryText];
}

- (void)commit:(NSString *)str {
}


- (void)commitEmpty {
    m_shouldCommitString = YES;
}


- (BOOL)insertCharacter:(char)ch {
    switch (m_mode) {
        case MODE_DISABLE:
            // Check trigger
            if (ch == '`' && m_cursor == 0) {
                m_mode = MODE_INIT;
                [self updatePunctCandidates:ch];
                [m_selected_puncts removeAllObjects];
                [m_selected_puncts insertObject:[m_punct_candidates objectAtIndex:0] atIndex:0];
                [self update];
            }
            break;
        case MODE_INIT:
            [m_text setString:@""];
            [m_selected_puncts removeAllObjects];
            m_cursor = 0;
        case MODE_NORMAL:
            [m_text insertString:[NSString stringWithFormat:@"%c", ch] atIndex:m_cursor];
            [self updatePunctCandidates:ch];
            m_mode = MODE_NORMAL;
            // Update selected
            if ([m_punct_candidates count] > 0) {
                [m_selected_puncts insertObject:m_punct_candidates[0] atIndex:m_cursor];
            }
            m_cursor += 1;
            [self update];
            break;
        default:
            break;
    }
    return YES;
}

- (id)initWithConfig:(LibpinyinConfig *) config {
    m_config = config;

    m_text = [[NSMutableString alloc] init];
    m_buffer = [[NSMutableString alloc] init];
    m_commitString = [[NSMutableString alloc] init];

    m_lookupTable = [[LookupTable alloc] initWithPageSize:[m_config pageSize]];

    m_cursor = 0;
    
    m_selected_puncts = [[NSMutableArray alloc] init];
    m_punct_candidates = [[NSMutableArray alloc] init];

    return self;
}

- (void)updateAuxiliaryText {
}


- (void)updateLookupTable {
}


- (void)updateLookupTableFast {
}


- (void)updatePreeditText {
}

- (BOOL)moveCursorLeft {
    return YES;
}


- (BOOL)moveCursorLeftByWord {
    return YES;
}


- (BOOL)moveCursorRight {
    return YES;
}


- (BOOL)moveCursorRightByWord {
    return YES;
}


- (BOOL)moveCursorToBegin {
    return YES;
}


- (BOOL)moveCursorToEnd {
    return YES;
}

- (BOOL)removeCharAfter {
    return YES;
}


- (BOOL)removeCharBefore {
    return YES;
}

- (BOOL)processSpaceWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    // Ony handle in these two modes
    if (m_mode != MODE_INIT && m_mode != MODE_NORMAL) {
        return NO;
    }
    if (filter_modifier_without_shift(modifiers)) {
        return YES;
    }
    [self commitEmpty];
    return YES;
}

- (BOOL)processNumberWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    return YES;
}

- (BOOL)processPunctWithKeyValue:(int)keyval keyCode:(int)keycode modifiers:(int)modifiers {
    if (filter_modifier_without_shift(modifiers)) {
        return YES;
    }
    
    if (m_mode == MODE_DISABLE) {
        // Not yet enabled
        if (keyval == '`') {
            [self insertCharacter:keyval];
            return YES;
        }
    }

    // TODO: Check mode in MODE_INIT or MODE_NORMAL
    
    switch (keyval) {
        case '`':   /* grave */
        case '~':   /* asciitilde */
        case '!':   /* exclam */
        case '@':   /* at */
        case '#':   /* numbersign */
        case '$':   /* dollar */
        case '%':   /* percent */
        case '^':   /* asciicircum */
        case '&':   /* ampersand */
        case '*':   /* asterisk */
        case '(':   /* parenleft */
        case ')':   /* parenright */
        case '-':   /* minus */
        case '_':   /* underscore */
        case '=':   /* equal */
        case '+':   /* plus */
        case '[':   /* bracketleft */
        case ']':   /* bracketright */
        case '{':   /* braceleft */
        case '}':   /* braceright */
        case '\\':  /* backslash */
        case '|':   /* bar */
        case ':':   /* colon */
        case ';':   /* semicolon */
        case '\'':  /* apostrophe */
        case '"':   /* quotedbl */
        case ',':   /* comma */
        case '.':   /* period */
        case '<':   /* less */
        case '>':   /* greater */
        case '/':   /* slash */
        case '?':   /* question */
        case '0' ... '9':
        case 'a' ... 'z':
        case 'A' ... 'Z':
            return [self insertCharacter:keyval];
            break;
        default:
            return NO;
    }
}

- (void)updatePunctCandidates:(char)ch {
    // Clear
    [m_punct_candidates removeAllObjects];

    // Search
    const char * const * const *search_result = NULL;
    for (int i = 0; i < sizeof(punct_table); i++) {
        if (punct_table[i][0][0] == ch) {
            search_result = punct_table + i;
            break;
        }
    }

    if (search_result != NULL) {
        for (const char * const * res = (*search_result) + 1; *res != NULL; ++res) {
            [m_punct_candidates addObject:[NSString stringWithUTF8String:*res]];
        }
    }

    // TODO: Fill lookup table
}

@end
