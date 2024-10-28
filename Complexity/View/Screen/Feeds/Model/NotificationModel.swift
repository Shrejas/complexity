//
//  NotificationModel.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/06/24.
//

import Foundation

struct NotificationModel: Codable {
    
    var notifications: [Notifications]?
    let isSucceed: Bool
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case notifications = "notifications"
        case isSucceed = "isSucceed"
        case message = "message"
    }
    
    static func += (lhs: inout NotificationModel, rhs: NotificationModel) {
        if let rhsNotifications = rhs.notifications {
            if lhs.notifications == nil {
                lhs.notifications = rhsNotifications
            } else {
                lhs.notifications! += rhsNotifications
            }
        }
    }
}

struct Notifications: Codable {

    let userId: Int
    let name: String
    let profilePicture: String
    let notificationId: Int
    let notificationMessage: String
    let createdAt: String
    let createdTime: String

    private enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case name = "name"
        case profilePicture = "profilePicture"
        case notificationId = "notificationId"
        case notificationMessage = "notificationMessage"
        case createdAt = "createdAt"
        case createdTime = "createdTime"
    }

}
