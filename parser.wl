import "element.wl"
import "file.wl"

Element parseElement(File file) {
    Element sym = nextElement(file)
    return sym
}

Element parse(File file) {
    Element ret
    while(!file.eof()) {
        skipWhitespace(file)
        if(file.eof()) break
        ret = parseElement(file)
    }

    return ret
}

void skipWhitespace(File file) {
    int peek = file.peek()
    while(peek == ' ' || peek == '\n') {
        file.get()
        peek = file.peek()
    }
}

Element nextElement(File file) {
    skipWhitespace(file)
    int peek = file.peek()

    if(peek == '('){
        file.get() // ignore (
        skipWhitespace(file)
        Element first
        Element next

        while(file.peek() != ')') {
            if(file.eof()) {
                printf("error. unterminated list\n")
                return null
            }

            if(next) {
                next.next = nextElement(file)
                next = next.next
            } else {
                next = nextElement(file)
            }

            if(!first) first = next

            skipWhitespace(file)
        }

        if(file.peek() != ')') {
            printf("error: invalid list termination\n")
        }
        file.get() // ignore ')'

        return new ListElement(first)
    }

    /*
    if(peek == ')') {
        file.get()
        return new TokenElement(RPAREN_KIND)
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
        return new StringElement(strdup(strbuf.ptr))
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
            return new FloatElement(val)
        } else {
            long val = atoll(strbuf.ptr)
            return new IntElement(val)
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
        return new IdElement(strdup(strbuf.ptr))
    }

    return null
}
