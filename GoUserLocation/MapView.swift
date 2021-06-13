//
//  MapView.swift
//  FootMark
//
//  Created by Zhihui Tang on 2021/05/12.
//

import SwiftUI
import MapKit
import Combine

struct MapView: UIViewRepresentable {
    private let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        let categories: [MKPointOfInterestCategory] = [.restaurant, .atm, .hotel]
        let filter = MKPointOfInterestFilter(including: categories)
        mapView.pointOfInterestFilter = filter
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
    }
    func makeCoordinator() -> Coordinator {
        .init(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        private var control: MapView
        private var lastUserLocation: CLLocationCoordinate2D?
        private var subscriptions: Set<AnyCancellable> = []

        init(_ control: MapView) {
            self.control = control
            super.init()
            
            NotificationCenter.default.publisher(for: .goToCurrentLocation)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] output in
                    guard let lastUserLocation = self?.lastUserLocation else { return }
                    control.mapView.setCenter(lastUserLocation, animated: true)
                }
                .store(in: &subscriptions)
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            lastUserLocation = userLocation.coordinate
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
