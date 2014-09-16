import "element.wl"

extern undecorated int printf(char ^fmt, ...);

class Node {
    Element value
    Node next
    weak Node prev 

    this(Node n, Node p, Element e) {
        .next = n
        .prev = p
        .value = e
    }
}

class List {
    Node first
    weak Node last

    this() {
        .first = null
        .last = null
    }

    ~this() {
        .first = null
        .last = null
    }

    void append(Element elem) {
        Node n = new Node(null, null, elem)
        if(!.first) {
            .first = n
            .last = n
        } else {
            .last.next = n
            n.prev = .last
            .last = n
        }
    }
}
