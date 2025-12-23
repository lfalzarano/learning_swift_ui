//
//  User.swift
//  SwiftDataProject
//
//  Created by Logan Falzarano on 12/9/25.
//

import Foundation
import SwiftData

@Model
class User {
    var name: String
    var city: String
    var joinDate: Date
    @Relationship(deleteRule: .cascade, inverse: \Job.owner) var jobs = [Job]() //must explicity set the inverse relationship we want if there are multiple job opjects
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
