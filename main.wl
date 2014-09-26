import "file.wl"
import "element.wl"
import "parser.wl"

int main(int argc, char^^ argv) {
    var file = new File("input.lm")
    parse(file)
    return 0
}
