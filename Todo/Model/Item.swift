//
//  Item.swift
//  Todo
//
//  Created by Lan Xuping on 2023/7/5.
//

import Foundation

class Item: Encodable,Decodable {
    var title: String = ""
    var done: Bool = false
}
