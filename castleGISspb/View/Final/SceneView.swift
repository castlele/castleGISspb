//
//  SceneView.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 10.03.2021.
//

import Foundation
import ArcGIS

final class SceneView {
	
	private let DISTANCE_FROM_STARTING_POINT : Double = 35_000
	private let CAMERA_HEADING : Double = 0
	private let CAMERA_PITCH : Double = 45
	private let CAMERA_ROLL : Double = 0
	
	var scene : AGSSceneView
	
	init(withBasemap: AGSBasemap = .topographic()) {
		self.scene = AGSSceneView()
		
		setup(basemap: withBasemap)
	}
	
	private var defaultLocation: Coordinates {
		Coordinates(lon: 30.3609, lat: 59.9311)
	}
	
	private func setup(basemap: AGSBasemap) {
		setupBasemapAndCamera(with: basemap)
		setupSurface()
		setupMeshLayer()
	}
	
	private func setupBasemapAndCamera(with basemap: AGSBasemap) {
		let scene = AGSScene(basemap: basemap)
		self.scene.scene = scene
		self.scene.setViewpointCamera(setupDefaultLocation(coordinates: defaultLocation))
	}
	
	private func setupDefaultLocation(coordinates: Coordinates) -> AGSCamera {
		let center = AGSPoint(clLocationCoordinate2D: Location2D(coordinates: coordinates))
		
		let camera = AGSCamera(
			lookAt: center,
			distance: DISTANCE_FROM_STARTING_POINT,
			heading: CAMERA_HEADING,
			pitch: CAMERA_PITCH,
			roll: CAMERA_ROLL
		)
		
		return camera
	}
	
	private func setupSurface() {
		let surface = AGSSurface()
		let worldElevationServiceURL = URL(string: "https://elevation3d.arcgis.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer")!
		let elevationSource = AGSArcGISTiledElevationSource(url: worldElevationServiceURL)
		surface.elevationExaggeration = 1.8
		surface.elevationSources.append(elevationSource)
		scene.scene?.baseSurface = surface
	}
	
	private func setupMeshLayer() {
		let url = URL(string: "https://tiles.arcgis.com/tiles/u0sSNqDXr7puKJrF/arcgis/rest/services/Frankfurt2017_v17/SceneServer/layers/0")!
		let meshLayer = AGSIntegratedMeshLayer(url: url)
		scene.scene?.operationalLayers.add(meshLayer)
	}
}
