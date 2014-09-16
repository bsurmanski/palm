# Primarily A List Markup

## Motivation
Create a easily parsible and human readible textual data store language.

## Concept
LEM will be a markup and object notation language that is easy to read and
write. On top of that, it will be very easy to parse. The basic syntax will
mimic lisp, but it will be oriented toward heirarchical data storage instead of
general computation.


## Syntax Example

    (elm
        (head
            title "hello world"
        )
        (body
            (button (text hello))   # showing the standard lisp syntax
            button (text hello)     # showing the implicit line style syntax
            button text:hello       # showing the associative property syntax
            def myvar:5             # define a variable myvar = 5
            b "bold text here"
            b:i "bold italic text here"
        )
    )

of course it is also ideal as a object-notation language like XML or JSON

(people
    (person
        name jonny
        age 5
    )
    (person
        name George
        age 21
        children (Maggy Sally Sue)
        address "123 fake st"
    )
    # example of colapsing an entry into a single line
    person name:Maggy age:2 address:"123 fake st" 
)
