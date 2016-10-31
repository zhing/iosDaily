//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var message1 = "Hello Swift! How can I get started?"
var message2 = "The best way to get started is to stop talking and code."

message1.uppercased()
message2.lowercased() + " Okay, I'm working on it  "

if message1 == message2 {
    print("Same message")
} else {
    print("Not the same message")
}

let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
messageLabel.text = message1

messageLabel

messageLabel.backgroundColor = UIColor.orange
messageLabel.textAlignment = NSTextAlignment.center
messageLabel.layer.cornerRadius = 10.0
messageLabel.clipsToBounds = true

messageLabel

var msgStr: String?
if msgStr != nil {
    print("optional")
}

func sayHello(_ person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
sayHello("zhing")

func halfOpenRangeLength(start:Int, end: Int) ->Int {
    return end-start
}
halfOpenRangeLength(start: 1, end: 10)

/*fuction
 *
 * 一般情况下函数调用的都得带上参数名，除非函数定义时外部参数名为_
 *
 */
// 1
func test(_ a:Int, _ b:Int) ->Int {
    return a + b
}

test(1, 1)

//2
class Test {
    var name: String
    var age: Int
    
    init(_ name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func sayHello(word: String, place: String) {
        print("Hello \(self.name), \(word) at \(place)")
    }
    
    func sayHelloTwice() {
        sayHello(word: "", place: "")
    }
}

var test = Test("Jack", age: 12) // (C)
test.sayHello(word: "nice to meet you", place: "Beijing") // (D)
print(test.age)

var testOptional : Test?
testOptional = Test("Zhing", age: 25)
testOptional!.sayHelloTwice()

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference :Person? = Person(name: "Zhing")
reference = nil

