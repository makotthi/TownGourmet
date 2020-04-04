import UIKit

class SearchViewController: UIViewController {

    // 現在地を再取得ボタン
    @IBOutlet private weak var reloadCurrentLocationButton: UIButton!
    // 現在地周辺のレストランを検索ボタン
    @IBOutlet private weak var searchRestaurantsAroundButton: UIButton!

    // 現在地を取得するクラス
    private let currentLocationReader = CurrentLocationReader()
    // APIクライアント
    private let apiClient = APIClient()

    // 緯度と経度
    private var latitude: Double?
    private var longitude: Double?

    // レストランのデータを保持する
    private var restaurantList: [StoreData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // 現在地を取得する
        readCurrentLocation()
    }

}

// MARK: - ReadCurrentLocation
extension SearchViewController {
    // 現在地を取得する
    private func readCurrentLocation() {
        // 検索ボタンと再取得ボタンを無効にする
        searchRestaurantsAroundButton.isEnabled = false
        reloadCurrentLocationButton.isEnabled = false

        // 現在地を取得する
        currentLocationReader.readCurrentLocation {[unowned self] result in
            switch result {
            // 位置情報の取得に成功した時
            case .success(let latitude, let longitude):
                // 緯度と経度を受け取る
                self.latitude = latitude
                self.longitude = longitude
                // 検索ボタンを有効にする
                self.searchRestaurantsAroundButton.isEnabled = true

            // 位置情報の取得に失敗した時
            case .failure(let error):
                print(error)

            }
            // 現在地再取得ボタンを有効にする
            self.reloadCurrentLocationButton.isEnabled = true

            print(self.latitude)
            print(self.longitude)
        }
    }
}

// MARK: - API
extension SearchViewController {
    private func searchRestaurant() {
        // クロージャの定義
        let onCompleteReceiveRestaurant = {[unowned self] (result: Result<StoreDataArray, Error>) in
            switch result {
            // レストランのデータを受け取れた時
            case .success(let storeDataArray):
                // 画面遷移する
                self.showResults(storeDataArray)

            // 通信に失敗した時
            case .failure(let error):
                print(error)
            }
        }

        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        // 緯度経度からレストランを検索
        apiClient.searchRestaurants(latitude: latitude, longitude: longitude, onCompleteReceiveRestaurant)
    }
}

// MARK: - Screen transition
extension SearchViewController {
    // 画面遷移
    private func showResults(_ storeDataArray: StoreDataArray) {
        // レストランデータのリストを初期化
        restaurantList = storeDataArray.rest ?? []

        performSegue(withIdentifier: "goNextView", sender: nil)
    }

    // 遷移先にレストランのデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 次の画面のインスタンスを格納
        if let nextViewController = segue.destination as? ResultsViewController {
            nextViewController.restaurantList = self.restaurantList
        }
    }
}

// MARK: - Action
extension SearchViewController {

    // 現在地再取得ボタンが押された時の処理
    @IBAction private func reloadCurrentLocation(_ sender: Any) {
        // 現在地を取得する
        readCurrentLocation()
    }

    // 現在地周辺のレストランを検索ボタンが押された時の処理
    @IBAction private func searchRestaurantsAround(_ sender: Any) {
        // レストランを検索する
        searchRestaurant()
    }

}
