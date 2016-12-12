//
//  ViewController.swift
//  Colores
//
//  Created by Benjamín Garrido Barreiro on 11/12/16.
//  Copyright © 2016 Benjamín Garrido Barreiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var imgKnobBase: UIImageView!
    @IBOutlet weak var imgKnob: UIImageView!

    private var deltaAngle: CGFloat?
    private var startTransform: CGAffineTransform?
    
    // Se corresponde con PI/2 que es la vertical
    private var setPointAngle = M_PI_2
    
    // Establecemos los límites tomando como referencia un ángulo de 30 grados (PI/6 = 30 grados)
    private var maxAngle = 7 * M_PI / 6
    private var minAngle = 0 - (M_PI/6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgKnob.isHidden = true
        imgKnobBase.isHidden = true
        imgKnob.isUserInteractionEnabled = true
    }
    
    @IBAction func btnSwitchPressed(_ sender: Any) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        if btnSwitch.isSelected {
            resetKnob()
            imgKnob.isHidden = false
            imgKnobBase.isHidden = false
        } else {
            view.backgroundColor = UIColor(hue:0.5,saturation:0,brightness:0.2,alpha:1.0)
            imgKnob.isHidden = true
            imgKnobBase.isHidden = true
        }
    }
    
    func resetKnob() {
        view.backgroundColor = UIColor(hue:0.5,saturation:0.5,brightness:0.75,alpha:1.0)
        // Le indicamos que vuelva a su lugar de origen
        imgKnob.transform = CGAffineTransform.identity
        setPointAngle = M_PI_2
    }
    
    private func touchIsInKnobWithDistance(distance: CGFloat)->Bool {
        // Calculamos el radio
        if distance > (imgKnob.bounds.height/2) {
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_on"), for: .selected)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Momento en el que ponemos el dedo y vamos a comenzar una interaccion
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // Obtenemos la parte de la vista en la que hemos tocado
            let delta = touch.location(in: imgKnob)
            // Distancia del centro a donde hemos tocado
            let dist = calculateDistanceFromCenter(delta)
            if touchIsInKnobWithDistance(distance: dist) {
                startTransform = imgKnob.startTransform
                let center = CGPoint(x: imgKnob.bounds.size.width/2, y: imgKnob.bounds.size.height/2)
                let deltaX = delta.x - center.x
                let deltaY = delta.y - center.y
                // Calculamos el arcotangente
                deltaAngle = atan2(deltaY, deltaX)
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    // Esto es el teorema de pitágoras
    private func calculateDistanceFromCenter(_ point: CGPoint)-> CGFloat {
        let center = CGPoint(x: imgKnob.bounds.size.width/2, y: imgKnob.bounds.size.height/2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt((dx * dy) + (dx * dy))
    }
}

