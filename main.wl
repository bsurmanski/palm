import "file.wl"
import "element.wl"
import "parser.wl"
import "html.wl"
import "json.wl"

int main(int argc, char^^ argv) {
    var file = new File("test/input.lm")
    Element elem = parse(file)
    dumpHTML("output.html", elem)
    return 0
}
