import Foundation

public extension Notification.Name {
    static let fetchRemoteConfig = Notification.Name(rawValue: "fetchRemoteConfig")
    static let amPointGiveawayFetchRemoteConfig = Notification.Name(rawValue: "amPointGiveawayFetchRemoteConfig")
    static let performClearFirstLoadTMW = Notification.Name(rawValue: "performClearFirstLoadTMW")
    static let performAuthLanding = Notification.Name(rawValue: "performAuthLanding")
    static let performSaveCustomer = Notification.Name(rawValue: "performSaveCustomer")
}
