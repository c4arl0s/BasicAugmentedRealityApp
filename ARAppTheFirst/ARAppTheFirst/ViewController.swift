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

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    let configuration = ARWorldTrackingConfiguration()
    sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
    sceneView.showsStatistics = true
    sceneView.session.run(configuration,options:[])
    
    loadScene()
    
    let boxNode = createBox(width: 0.3, height: 0.3, lenght: 0.3, color: .white)
    boxNode.position = SCNVector3Make(0.0, 0.0,-1.5)
    sceneView.scene.rootNode.addChildNode(boxNode)
        
    let sphereNode = createSphere(radius: 0.3)
    sphereNode.position = SCNVector3Make(0.0, 0.0, -2.0)
    sceneView.scene.rootNode.addChildNode(sphereNode)
    
    let textNode = createText(text: "this is Planet Earth")
    textNode.position = SCNVector3Make(0.0, 0.5, -3.5)
    sceneView.scene.rootNode.addChildNode(textNode)
        
    let planetEarthNode = createPlanet(radius: 0.5, textureName: "earth")
    planetEarthNode.position = SCNVector3Make(0.0, 0.0, -3.5)
    sceneView.scene.rootNode.addChildNode(planetEarthNode)
        
    let planetJupiterNode = createPlanet(radius: 1.5, textureName: "jupiter")
    planetJupiterNode.position = SCNVector3Make(0.0, 0.0, -7.0)
    sceneView.scene.rootNode.addChildNode(planetJupiterNode)
    
    let textNodeForPlanetJupiter = createText(text: "this is Planet Jupiter")
    textNodeForPlanetJupiter.position = SCNVector3Make(0.0, 1.5, -7.0)
    sceneView.scene.rootNode.addChildNode(textNodeForPlanetJupiter)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    sceneView.addGestureRecognizer(tapGesture)


    }
    func loadScene() {
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
    }

    @objc func tapped(recognizer: UIGestureRecognizer) {
        guard let view = recognizer.view as? ARSCNView else {return}
        let touchLocation = recognizer.location(in: view)
        let hitResults = view.hitTest(touchLocation, options: [:])
        if let hitResult = hitResults.first {
            let node = hitResult.node
            if node.name == "planet" {
                let material = node.geometry?.material(named: "planetTexture")
                material?.diffuse.contents = UIImage(named: "earth")
            }
            
            
        }
        print("Tocamos la vista")
    }
    func createBox(width: CGFloat, height: CGFloat, lenght: CGFloat, color: UIColor ) ->  SCNNode{
        let box = SCNBox(width: width, height: height, length: lenght, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        box.materials = [material]
        let boxNode = SCNNode(geometry: box)
        return boxNode
    }
    func createSphere(radius: CGFloat) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.cyan
        sphere.materials = [material]
        let sphereNode = SCNNode(geometry: sphere)
        return sphereNode
    }
    func createText(text: String) -> SCNNode {
        let text = SCNText(string: text, extrusionDepth: 1.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        text.materials = [material]
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3Make(0.02, 0.02, 0.02)
        return textNode
    }
    func createPlanet(radius: CGFloat, textureName: String) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: textureName)
        sphere.name = "planet"
        sphere.materials = [material]
        let sphereNode = SCNNode(geometry: sphere)
        return sphereNode
    }
}

