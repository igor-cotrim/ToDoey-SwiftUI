//
//  ToDoModel.swift
//  ToDoey
//
//  Created by Igor Cotrim on 06/03/25.
//

import Foundation

struct ToDoModel: Identifiable, Codable {
    var id: Int?
    var createdAt: Date
    var title: String
    var isComplete: Bool
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case title
        case isComplete = "is_complete"
        case userId = "user_id"
    }
}
