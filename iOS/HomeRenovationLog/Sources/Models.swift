import Foundation

struct HomeRenovationLogItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var projectName: String
    var budget: String
    var status: String
    var createdAt: Date = Date()
}
