//
//  Notification.Name.swift
//  Complexity
//
//  Created by IE Mac 05 on 07/05/24.
//

import Foundation
extension Notification.Name {
    /// Notification sent when user session is expired
    static let sessionExpired = Notification.Name(StringConstants.NotificationName.sessionExpiredNotificationKey)
    static let userLogoutNotification = Notification.Name(StringConstants.NotificationName.userLogoutNotificationKey)
    static let callRefreshMethod = Notification.Name(StringConstants.NotificationName.callRefreshMethod)
    static let navigateToUserProfile = Notification.Name("navigateToUserProfile")
}
