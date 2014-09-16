import "list.wl"
import "element.wl"
import "file.wl"

Element parseElement(File file) {
    file.get()
    return null
}

List parse() {
    var file = new File("input.lm")
    var list = new List()
    while(!file.eof()) {
        list.append(parseElement(file))
    }
}
