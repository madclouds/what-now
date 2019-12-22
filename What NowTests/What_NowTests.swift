import XCTest
@testable import What_Now

class What_NowTests: XCTestCase {
    var mainViewModel: MainViewModel!
    override func setUp() {
        super.setUp()
        //Todo:  I can't test this because it uses UserDefaults...
        //Should I test Firebase?
        //Do i need a special simplified version of my databse service for testing?
//        let databaseService = LocalStorageDatabaseService()
//        mainViewModel = MainViewModel(databaseService: databaseService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTrue() {
        XCTAssert(1 == 1)
    }
}
