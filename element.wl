import "file.wl"

extern undecorated double atof(char^ ptr);
extern undecorated long atoll(char^ ptr);
extern undecorated int printf(char ^fmt, ...);
extern undecorated char^ strdup(char^ str);

class Element {
    Element next

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
class TokenElement : Element {
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

class ListElement : Element {
    Element first
    
    this(Element first) {
        .first = first
    }

    bool isList() return true

    void dump() {
        printf("(")
        Element sym = .first
        while(sym) {
            sym.dump()
            sym = sym.next
        }
        printf(")\n")
    }
}

class IdElement : Element {
    char^ str

    this(char^ str) {
        .str = str
    }

    bool isId() return true

    void dump() {
        printf("(ID %s)\n", .str)
    }
}

class NumericElement : Element {
    bool isNumeric() return true
}

class IntElement : Element {
    long value

    this(long value) {
        .value = value
    }

    bool isInt() return true

    void dump() {
        printf("(int %lld)", .value)
    }
}

class FloatElement : Element {
    double value

    this(double value) {
        .value = value
    }

    bool isFloat() return true

    void dump() {
        printf("(float %f)", .value)
    }
}

class StringElement : Element {
    char^ value
    this(char^ value) {
        .value = value
    }

    bool isString() return true

    void dump() {
        printf("(string %s)", .value)
    }
}

