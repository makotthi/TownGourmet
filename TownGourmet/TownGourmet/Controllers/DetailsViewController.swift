import UIKit
import MapKit

class DetailsViewController: UIViewController {

    // 店の画像
    @IBOutlet private weak var imageView1: UIImageView!
    @IBOutlet private weak var imageView2: UIImageView!
    // カテゴリー
    @IBOutlet private weak var categoryLabel: UILabel!
    // 店名
    @IBOutlet private weak var nameLabel: UILabel!
    // 住所
    @IBOutlet private weak var addressLabel: UILabel!
    // 電話番号
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    // 営業時間
    @IBOutlet private weak var openTimeLabel: UILabel!
    // PR文
    @IBOutlet private weak var prTextView: UITextView!
    // 地図
    @IBOutlet private weak var mapView: MKMapView!

    // レストランのデータ
    var restaurantData: StoreData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 店舗データを表示
        showData()
    }

}

// MARK: - Show restaurant data
extension DetailsViewController {
    private func showData() {
//        guard let restaurantData = restaurantData else {
//            return
//        }
        print(restaurantData?.name)

        // 店舗画像を表示
        imageView1.loadImage(url: restaurantData?.image_url?.shop_image1)
        imageView2.loadImage(url: restaurantData?.image_url?.shop_image2, noImage: .ver2)
        // カテゴリーを表示
        categoryLabel.text = restaurantData?.code?.category_name_l?.first
        // 店名を表示
        nameLabel.text = restaurantData?.name
        // 住所を表示
        addressLabel.text = restaurantData?.address
        // 電話番号を表示
        if let phoneNumber = restaurantData?.tel {
            phoneNumberLabel.text = "TEL: " + phoneNumber
        }
        // 営業時間を表示
        if let openTime = restaurantData?.opentime {
            openTimeLabel.text = "営業時間:\n" + openTime
        }
        // PR文を表示
        if let pr = restaurantData?.pr?.pr_long {
            prTextView.text = pr
        }

        // 地図上にピンを表示
        putPin()
    }
}

// MARK: - Setting annotation
extension DetailsViewController {
    private func putPin() {
        guard let restaurantData = restaurantData else {
            return
        }

        // ピンのインスタンスを生成
        let pin = MKPointAnnotation()
        // レストランのデータをセット
        pin.setStoreData(storeData: restaurantData)
        // ピンを地図に置く
        mapView.addAnnotation(pin)

        mapView.mapZoom(storeData: restaurantData)
    }
}

// MARK: - Action
extension DetailsViewController {
    @IBAction private func showWebPage(_ sender: Any) {
    }
}
