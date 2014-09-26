import "list.wl"
import "element.wl"
import "lexer.wl"
import "file.wl"

Element parseElement(File file) {
    Symbol sym = nextSymbol(file)
    if(sym) {
        sym.dump()
    }
    return null
}

List parse(File file) {
    var list = new List()
    while(!file.eof()) {
        Element elem = parseElement(file)
        if(elem)
            list.append(elem)
    }
}
