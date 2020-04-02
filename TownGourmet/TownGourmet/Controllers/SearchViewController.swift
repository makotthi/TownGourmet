
import UIKit

class SearchViewController: UIViewController {

    // 現在地を再取得ボタン
    @IBOutlet weak var reloadCurrentLocationButton: UIButton!
    // 現在地周辺のレストランを検索ボタン
    @IBOutlet weak var searchRestaurantsAroundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


// MARK: - Action
extension SearchViewController {
    
    // 現在地再取得ボタンが押された時の処理
    @IBAction func reloadCurrentLocation(_ sender: Any) {
    }
    
    // 現在地周辺のレストランを検索ボタンが押された時の処理
    @IBAction func searchRestaurantsAround(_ sender: Any) {
    }
}
