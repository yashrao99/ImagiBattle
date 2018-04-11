//
//  BattleViewController.swift
//  ImagiBattle
//
//  Created by Yash Rao on 4/10/18.
//  Copyright © 2018 com.YashasRao99. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreGraphics

class BattleViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    var scene: SCNScene?
    var sceneNode: SCNNode?
    var pickerData: [String] = ["Falcon", "Kylo", "Luke", "Raichu", "Stormtrooper", "Xwing"]
    var indexPickerName: [String] = ["model_Millenium_falcon_20171214_153929645", "Kylo", "model_Luke_20171215_093639477", "_odel_Pok__mon_20171108_19001620", "model_Stormtrooper_20171214_154554283", "model_X_Wing_20171214_155110102"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Picker sets
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.isHidden = true
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        scene = SCNScene(named: "art.scnassets/Kylo.dae")!
        self.sceneNode = scene!.rootNode.childNode(withName: "Kylo", recursively: true)
        self.sceneNode?.scale = SCNVector3(0.01, 0.01, 0.01)
        // Set the scene to the view
        //sceneView.scene = scene!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        
        guard let hitFunction = results.last else {
            return
        }
        
        let hitTransform = SCNMatrix4(hitFunction.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        let sceneClone = sceneNode?.clone()
        sceneClone?.position = hitPosition
        sceneView.scene.rootNode.addChildNode(sceneClone!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func selectedScene(_ name: String,_ modelName: String) {
        scene = SCNScene(named: name)
        self.sceneNode = scene!.rootNode.childNode(withName: modelName, recursively: true)
        self.sceneNode?.scale = SCNVector3(2,2,2)
    }
    
    @IBAction func clearView(_ sender: Any) {
        
        sceneView.scene = scene!
    }
    
    @IBAction func selectImage(_ sender: Any) {
        print("Button pressed")
        UIView.animate(withDuration: 0.3) {
            self.picker.frame = CGRect(x: 0, y: self.view.bounds.size.height - self.picker.bounds.size.height, width: self.picker.bounds.size.width, height: self.picker.bounds.size.height)
        }
        self.picker.becomeFirstResponder()
        
    }
}

extension BattleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedScene(pickerData[row], indexPickerName[row])
        self.picker.resignFirstResponder()
        self.picker.isHidden = true
    }
}
