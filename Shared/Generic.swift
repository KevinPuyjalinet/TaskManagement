//
//  Generic.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 18/02/2026.
//

import Foundation

//MARK: Les Generique

// 1) Une struct générique qui stocke une valeur de n’importe quel type
struct Box<T> {
    var value: T
}

// 2) Une fonction générique
func printValue<T>(_ value: T) {
    print(value)
}

func demoGenerics() {
    // 3) Tests
    let intBox = Box(value: 10)
    let stringBox = Box(value: "Hello")
    let boolBox = Box(value: true)

    printValue(intBox.value)
    printValue(stringBox.value)
    printValue(boolBox.value)
}
