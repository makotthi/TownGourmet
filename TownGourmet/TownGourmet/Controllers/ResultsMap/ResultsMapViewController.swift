import UIKit
import MapKit

class ResultsMapViewController: UIViewController {

    // 地図を表示するMapView
    @IBOutlet private weak var mapView: MKMapView!

    // レストランのリストを格納する
    var restaurantList: [StoreData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // 地図上にピンを置く
        putPins()
    }

}

// MARK: - Setting Annotiation
extension ResultsMapViewController {
    // 地図上にピンを設置する
    private func putPins() {
        for item in restaurantList {
            // ピンのインスタンスを生成
            let pin = MKPointAnnotation()
            // レストランのデータをセット
            pin.setStoreData(storeData: item)
            // ピンを地図に置く
            mapView.addAnnotation(pin)

        }

        if let storeData = restaurantList.first {
            mapView.mapZoom(storeData: storeData)
        }

    }
}
