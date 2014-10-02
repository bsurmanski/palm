import "element.wl"
import "file.wl"

void tagList(File out, ListElement list) {
    if(list.first && list.first.isId()) {
        printf("{")

        Element elem = list.first.next
        while(elem) {
            dumpJSON(null, elem)
            elem = elem.next
        }

        printf("}\n")
    }
}

void dumpJSON(char^ filenm, Element elem) {
    if(elem.isList()) {
        tagList(null, ListElement: elem)
    } else if(elem.isString()) {
        printf((StringElement: elem).value)
    } else if(elem.isNumeric()) {
        if(elem.isInt()) {
            printf("%d", (IntElement: elem).value)
        }

        if(elem.isFloat()) {
            printf("%f", (FloatElement: elem).value)
        }
    }
}
