import MapKit

extension MKPointAnnotation {
    // ピンに店のデータをセットする
    func setStoreData(storeData: StoreData) {
        guard let latitudeString = storeData.latitude, let longitudeString = storeData.longitude else {
            return
        }

        let latitude = atof(latitudeString)
        let longitude = atof(longitudeString)
        let targetCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        coordinate = targetCoordinate
        title = storeData.name
        subtitle = storeData.code?.category_name_l?.first
    }
}
