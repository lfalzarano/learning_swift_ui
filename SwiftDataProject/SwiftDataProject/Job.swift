//
//  Job.swift
//  SwiftDataProject
//
//  Created by Logan Falzarano on 12/19/25.
//

import Foundation
import SwiftData

@Model
class Job {
    var name: String
    var priority: Int
    var owner: User?
    var coOwner: User?

    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
