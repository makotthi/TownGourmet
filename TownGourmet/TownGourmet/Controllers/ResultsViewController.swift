import UIKit

class ResultsViewController: UIViewController {

    // レストランのデータ
    var restaurantList: [StoreData] = []

    // 検索結果を表示するView
    @IBOutlet private weak var resultsView: UIView!
    @IBOutlet private weak var resultsListViewContainer: UIView!
    @IBOutlet private weak var resultsMapViewContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //print(restaurantList.first?.name)

        resultsView.bringSubviewToFront(resultsListViewContainer)
    }

}

// MARK: - Screen transition
extension ResultsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("showList"?, let viewController as ResultsListViewController):
            viewController.restaurantList = self.restaurantList
        default:
            ()
        }
    }
}
