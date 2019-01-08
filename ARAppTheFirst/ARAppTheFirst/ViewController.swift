//
//  ViewController.swift
//  ARAppTheFirst
//
//  Created by Carlos Santiago Cruz on 1/7/19.
//  Copyright © 2019 Carlos Santiago Cruz. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
    sceneView.showsStatistics = true
    sceneView.session.run(configuration,options:[])
    sceneView.delegate = self
    
    
    }
    // MARK: SceneView Delegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let plane = OverlayPlane(planeAnchor: planeAnchor)
        node.addChildNode(plane)
    }
}

