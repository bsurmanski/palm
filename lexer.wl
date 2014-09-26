import "file.wl"

extern undecorated double atof(char^ ptr);
extern undecorated long atoll(char^ ptr);
extern undecorated int printf(char ^fmt, ...);
extern undecorated char^ strdup(char^ str);

class Symbol {
    Symbol next

    this() {
        .next = null
    }

    bool isList() return true
    bool isId() return false
    bool isToken() return false
    bool isNumeric() return false
    bool isInt() return false 
    bool isFloat() return false
    bool isString() return false
    int getKind() return 0 //XXX temporary until cast availible
    void dump() {}
}

//XXX should be enum or similar
const int LPAREN_KIND = 0
const int RPAREN_KIND = 1
class TokenSymbol : Symbol {
    int kind

    int getKind() return .kind

    this(int kind) {
        .kind = kind
    }

    bool isToken() return true

    void dump() {
        if(.kind == LPAREN_KIND) {
            printf("(")
        } else if(.kind == RPAREN_KIND) {
            printf(")")
        }
    }
}

class ListSymbol : Symbol {
    Symbol first
    
    this(Symbol first) {
        .first = first
    }

    bool isList() return true

    void dump() {
        printf("(")
        Symbol sym = .first
        while(sym) {
            sym.dump()
            sym = sym.next
        }
        printf(")\n")
    }
}

class IdSymbol : Symbol {
    char^ str

    this(char^ str) {
        .str = str
    }

    bool isId() return true

    void dump() {
        printf("(ID %s)\n", .str)
    }
}

class NumericSymbol : Symbol {
    bool isNumeric() return true
}

class IntSymbol : Symbol {
    long value

    this(long value) {
        .value = value
    }

    bool isInt() return true

    void dump() {
        printf("(int %lld)", .value)
    }
}

class FloatSymbol : Symbol {
    double value

    this(double value) {
        .value = value
    }

    bool isFloat() return true

    void dump() {
        printf("(float %f)", .value)
    }
}

class StringSymbol : Symbol {
    char^ value
    this(char^ value) {
        .value = value
    }

    bool isString() return true

    void dump() {
        printf("(string %s)", .value)
    }
}

void skipWhitespace(File file) {
    int peek = file.peek()
    while(peek == ' ' || peek == '\n') {
        file.get()
        peek = file.peek()
    }
}

Symbol nextSymbol(File file) {
    skipWhitespace(file)
    int peek = file.peek()

    if(peek == '('){
        file.get() // ignore (
        skipWhitespace(file)
        Symbol first
        Symbol next

        while(file.peek() != ')') {
            if(file.eof()) {
                printf("error. unterminated list\n")
                return null
            }

            if(next) {
                next.next = nextSymbol(file)
                next = next.next
            } else {
                next = nextSymbol(file)
            }

            if(!first) first = next

            skipWhitespace(file)
        }

        if(file.peek() != ')') {
            printf("error: invalid list termination\n")
        }
        file.get() // ignore ')'

        return new ListSymbol(first)
    }

    /*
    if(peek == ')') {
        file.get()
        return new TokenSymbol(RPAREN_KIND)
    }*/

    if(peek == '\"') {
        char[64] strbuf
        char stri = 0
        file.get() // ignore "
        peek = file.peek()
        while(peek != '\"') {
            strbuf[stri] = peek
            stri++
            file.get()
            peek = file.peek()

            if(file.eof()) {
                printf("error: unterminated string\n")
                break;
            }
        }

        if(file.peek() != '\"') {
            printf("error: expected terminating string quote\n")
        }
        file.get() // ignore closing
        strbuf[stri] = 0
        return new StringSymbol(strdup(strbuf.ptr))
    }

    // parse numeral
    if(peek >= '0' && peek <= '9') {
        bool isfloat = false
        char[64] strbuf
        char stri = 0

        while((peek >= '0' && peek <= '9') || peek == '.') {
            strbuf[stri] = peek
            stri++
            if(peek == '.') isfloat = true
            file.get()
            peek = file.peek()
        }
        strbuf[stri] = 0

        if(isfloat) {
            double val = atof(strbuf.ptr)
            return new FloatSymbol(val)
        } else {
            long val = atoll(strbuf.ptr)
            return new IntSymbol(val)
        }
    }

    if((peek >= 'a' && peek <= 'z') || peek >= 'A' && peek <= 'Z') {
        char[64] strbuf
        char stri = 0
        while((peek >= 'a' && peek <= 'z') || 
            (peek >= 'A' && peek <= 'Z') ||
            (peek >= '0' && peek <= '9')) {
            file.get() // discard char
            strbuf[stri] = peek
            stri++
            peek = file.peek()
        }
        strbuf[stri] = 0
        return new IdSymbol(strdup(strbuf.ptr))
    }

    return null
}
