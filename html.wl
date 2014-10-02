import "element.wl"
import "file.wl"

void printIndent(int level) 
    for(int i = 0; i < level; i++) 
        printf("\t")

void tagList(File out, ListElement list, int level) {
    if(list.first && list.first.isId()) {
        printf("<")
        printf((IdElement: list.first).str)
        printf(">")

        Element elem = list.first.next
        while(elem) {
            printf("\n")
            printIndent(level+1)
            dumpHTML_r(null, elem, level + 1)
            elem = elem.next
        }
        if(list.first.next) {
            printf("\n")
            printIndent(level)
        }
        printf("</")
        printf((IdElement: list.first).str)
        printf(">")
    }
}

void dumpHTML_r(File file, Element elem, int level) {
    if(elem.isList()) {
        tagList(null, ListElement: elem, level)
    } else if(elem.isString()) {
        printf((StringElement: elem).value)
    }
}

void dumpHTML(char^ filenm, Element elem) {
    dumpHTML_r(null, elem, 0)
}
