import UIKit

class ResultsViewController: UIViewController {

    // レストランのデータ
    var restaurantList: [StoreData] = []

    // 検索結果を表示するView
    @IBOutlet private weak var resultsView: UIView!
    @IBOutlet private weak var resultsListViewContainer: UIView!
    @IBOutlet private weak var resultsMapViewContainer: UIView!

    // ViewContainerの配列
    private var containers: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        containers = [resultsListViewContainer, resultsMapViewContainer]

        resultsView.bringSubviewToFront(resultsListViewContainer)
    }

}

// MARK: - Screen transition
extension ResultsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("showList"?, let viewController as ResultsListViewController):
            viewController.restaurantList = self.restaurantList
        case ("showMap"?, let viewController as ResultsMapViewController):
            viewController.restaurantList = self.restaurantList
        default:
            ()
        }
    }
}

// MARK: - Action
extension ResultsViewController {
    @IBAction func changeContainerView(_ sender: UISegmentedControl) {
        let currentContainerView = containers[sender.selectedSegmentIndex]
        resultsView.bringSubviewToFront(currentContainerView)
    }
}
