import XCTest
@testable import HomeRenovationLog

@MainActor
final class StoreTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.isPro = false
    }

    func testAddItem() {
        let item = HomeRenovationLogItem(projectName: "A", budget: "B", status: "C")
        let added = store.add(item)
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, 1)
    }

    func testFreeLimitBlocksAdd() {
        for i in 0..<Store.freeLimit {
            store.add(HomeRenovationLogItem(projectName: "\(i)", budget: "B", status: "C"))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit)
        let blocked = store.add(HomeRenovationLogItem(projectName: "over", budget: "B", status: "C"))
        XCTAssertFalse(blocked)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testProBypassesLimit() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(HomeRenovationLogItem(projectName: "\(i)", budget: "B", status: "C"))
        }
        XCTAssertEqual(store.items.count, Store.freeLimit + 5)
    }

    func testDeleteItem() {
        let item = HomeRenovationLogItem(projectName: "A", budget: "B", status: "C")
        store.add(item)
        store.delete(item)
        XCTAssertTrue(store.items.isEmpty)
    }

    func testUpdateItem() {
        var item = HomeRenovationLogItem(projectName: "A", budget: "B", status: "C")
        store.add(item)
        item.projectName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.projectName, "Updated")
    }

    func testCanAddMoreTrueInitially() {
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteAtOffsets() {
        store.add(HomeRenovationLogItem(projectName: "A", budget: "B", status: "C"))
        store.add(HomeRenovationLogItem(projectName: "D", budget: "E", status: "F"))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }

    func testPersistenceRoundTrip() {
        store.add(HomeRenovationLogItem(projectName: "Persist", budget: "B", status: "C"))
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.projectName == "Persist" }))
    }
}
