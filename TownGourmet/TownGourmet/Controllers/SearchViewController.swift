import UIKit
import MapKit

class SearchViewController: UIViewController {

    // 現在地を再取得ボタン
    @IBOutlet private weak var reloadCurrentLocationButton: UIButton!
    // 現在地周辺のレストランを検索ボタン
    @IBOutlet private weak var searchRestaurantsAroundButton: UIButton!

    // 検索場所を表示するtextField
    @IBOutlet private weak var locationTextField: UITextField!

    // カテゴリーを表示するtextField
    @IBOutlet private weak var categoryTextField: UITextField!
    // キーワードを表示するtextField
    @IBOutlet private weak var keywordTextField: UITextField!

    // 現在地を取得するクラス
    private let currentLocationReader = CurrentLocationReader()
    // APIクライアント
    private let apiClient = APIClient()

    // 現在地の緯度と経度
    private var currentLatitude: Double?
    private var currentLongitude: Double?

    // 検索場所の緯度と経度
    private var locationLatitude: Double?
    private var locationLongitude: Double?

    // レストランのデータを保持する
    private var restaurantList: [StoreData] = []

    // カテゴリーのデータを保持する
    private var categoryArray: [String] = []
    private var categoryDictionary: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // テキストフィールドのデリゲートを設定
        locationTextField.delegate = self
        categoryTextField.delegate = self
        keywordTextField.delegate = self

        // レストランのカテゴリーデータを受け取る
        setCategorys()

        // 現在地を取得する
        readCurrentLocation()
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    // 完了ボタンがタップされた時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()

        return true
    }
}

// MARK: - Setting category data
extension SearchViewController {
    // カテゴリーを受診して変数に保存する
    private func setCategorys() {
        apiClient.receiveCategorys({[unowned self] (result: Result<CategoryDataArray, Error>) in
            switch result {
            // カテゴリーのデータを受け取れた時
            case .success(let categoryDataArray):
                // 画面遷移する
                self.setDataInArrayAndDictionary(data: categoryDataArray)

            // 通信に失敗した時
            case .failure(let error):
                print(error)
            }
        })
    }

    private func setDataInArrayAndDictionary(data: CategoryDataArray) {
        guard let categoryArray = data.category_l else {
            return
        }

        for item in categoryArray {
            guard let name = item.category_l_name, let code = item.category_l_code else {
                continue
            }
            self.categoryArray.append(name)
            self.categoryDictionary[name] = code
        }
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
                self.currentLatitude = latitude
                self.currentLongitude = longitude
                // 検索ボタンを有効にする
                self.searchRestaurantsAroundButton.isEnabled = true

            // 位置情報の取得に失敗した時
            case .failure(let error):
                print(error)

            }
            // 現在地再取得ボタンを有効にする
            self.reloadCurrentLocationButton.isEnabled = true

            print(self.currentLatitude)
            print(self.currentLongitude)
        }
    }
}

// MARK: - API
extension SearchViewController {
    private func searchRestaurant(mode: SearchMode) {
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

        var latitudeOptional: Double?
        var longitudeOptional: Double?
        switch mode {
        case .currentLocation:
            latitudeOptional = currentLatitude
            longitudeOptional = currentLongitude
        case .locationWord:
            latitudeOptional = locationLatitude
            longitudeOptional = locationLongitude
        }

        guard let latitude = latitudeOptional, let longitude = longitudeOptional else {
            return
        }
        // 緯度経度からレストランを検索
        apiClient.searchRestaurants(latitude: latitude, longitude: longitude, keyword: keywordTextField.text, onCompleteReceiveRestaurant)
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
        searchRestaurant(mode: .currentLocation)
    }

    // 入力場所周辺のレストランを検索ボタンが押された時の処理
    @IBAction private func searchRestaurantLocationWord(_ sender: Any) {
        // 入力地点の緯度と経度を受け取る
        readLocationCoordinate()
    }

}

// MARK: - Read location Coordinate
extension SearchViewController {
    private func readLocationCoordinate() {
        let geocoder = CLGeocoder()

        guard let keyword = locationTextField.text else {
            return
        }

        // 緯度と経度を検索し、変数に代入する
        geocoder.geocodeAddressString(keyword, completionHandler: {(placemarks, _) in
            if let coordinate = placemarks?.first?.location?.coordinate {
                self.locationLatitude = coordinate.latitude
                self.locationLongitude = coordinate.longitude

                // レストランを検索する
                self.searchRestaurant(mode: .locationWord)
            }
        })
    }
}

enum SearchMode {
    case currentLocation, locationWord
}
