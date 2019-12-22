import UIKit

class ViewControllerFactory {
    private let databaseService: DatabaseService
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    func main() -> MainViewController {
        let mainViewModel = MainViewModel(databaseService: databaseService)
        return MainViewController(viewModel: mainViewModel)
    }
}
