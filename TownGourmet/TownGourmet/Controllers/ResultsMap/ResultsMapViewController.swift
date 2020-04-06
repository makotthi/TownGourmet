import UIKit
import MapKit

class ResultsMapViewController: UIViewController {

    // 地図を表示するMapView
    @IBOutlet private weak var mapView: MKMapView!

    // レストランのリストを格納する
    var restaurantList: [StoreData] = []

    // 選択されたレストランのデータ
    private var restaurantData: StoreData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲートの設定
        mapView.delegate = self

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

// MARK: - MKMapViewDelegate
extension ResultsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // 初期化
        restaurantData = nil

        let annotation = view.annotation
        let name = annotation?.title

        // 一致するレストランを検索
        for item in restaurantList {
            if item.name == name {
                restaurantData = item
                break
            }
        }

        // 画面遷移
        performSegue(withIdentifier: "goNextView", sender: nil)
    }

    // 遷移先に値を渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 次の画面のインスタンスを格納
        if let nextViewController = segue.destination as? DetailsViewContainer {
            nextViewController.restaurantData = self.restaurantData
        }
    }
}
