import UIKit

class ResultsViewController: UIViewController {

    var restaurantList: [StoreData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        print(restaurantList.first?.name)
        // Do any additional setup after loading the view.
    }

}
