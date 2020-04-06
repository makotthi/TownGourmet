import UIKit

class DetailsViewContainer: UIViewController {

    var restaurantData: StoreData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("showDetails"?, let viewController as DetailsViewController):
            viewController.restaurantData = self.restaurantData
        default:
            ()
        }
    }

}
