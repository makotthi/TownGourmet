import MapKit

extension MKMapView {
    // 指定した店の半径2kmの範囲を表示
    func mapZoom(storeData: StoreData) {
        guard let latitudeString = storeData.latitude, let longitudeString = storeData.longitude else {
            return
        }

        let latitude = atof(latitudeString)
        let longitude = atof(longitudeString)
        let targetCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
    }
}
