import UIKit

/// The `MapManager` is responsible for managing the `mapView`
/// and orchestrating between the different components of the Mapbox SDK
extension MapView {

    /// Configures/Initializes the map with `mapConfig`
    internal func setupManagers() {

        // Initialize/Configure camera manager first since Gestures needs it as dependency
        setupCamera(view: self)

        // Initialize/Configure style manager
        setupStyle(with: mapboxMap.__map)

        // Initialize/Configure gesture manager
        setupGestures(with: self, cameraManager: camera)

        // Initialize/Configure ornaments manager
        setupOrnaments(with: self)

        // Initialize/Configure location manager
        setupUserLocationManager(with: self)

        // Initialize/Configure annotations manager
        setupAnnotationManager(with: self, mapEventsObservable: mapboxMap, style: style)
    }

    /// Updates the map with new configuration options. Causes underlying structures to reload configuration synchronously.
    /// - Parameter update: A closure that is fed the current map options and manipulates it in some way.
    public func update(with updateMapConfig: (inout MapConfig) -> Void) {
        updateMapConfig(&mapConfig) // This mutates the map options
    }

    internal func setupGestures(with view: UIView, cameraManager: CameraAnimationsManager) {
        gestures = GestureManager(for: view, cameraManager: cameraManager)
    }

    internal func setupCamera(view: MapView) {
        camera = CameraAnimationsManager(mapView: view)
    }

    internal func setupOrnaments(with view: OrnamentSupportableView) {
        ornaments = OrnamentsManager(view: view, options: OrnamentOptions())
    }

    internal func setupUserLocationManager(with locationSupportableMapView: LocationSupportableMapView) {

        location = LocationManager(locationSupportableMapView: locationSupportableMapView)
    }

    internal func setupAnnotationManager(with annotationSupportableMap: AnnotationSupportableMap, mapEventsObservable: MapEventsObservable, style: Style) {
        annotations = AnnotationManager(for: annotationSupportableMap, mapEventsObservable: mapEventsObservable, with: style)
    }

    internal func setupStyle(with map: Map) {
        style = Style(with: map)
    }
}
