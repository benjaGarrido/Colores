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
                startTransform = imgKnob.transform
                let center = CGPoint(x: imgKnob.bounds.size.width/2, y: imgKnob.bounds.size.height/2)
                let deltaX = delta.x - center.x
                let deltaY = delta.y - center.y
                // Calculamos el arcotangente
                deltaAngle = atan2(deltaY, deltaX)
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    // Momento en el que levantamos el dedo
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // Comprobamos que donde estamos tocando es el knob
            if touch.view == imgKnob {
                deltaAngle = nil
                startTransform = nil
            }
        }
        super.touchesEnded(touches, with: event)
    }
    
    // Controlamos el movimiento del dedo (mientras lo arrastramos)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let deltaAngle = deltaAngle, let startTransform = startTransform, touch.view == #imageLiteral(resourceName: "img_knob") {
            // Cogemos la posición en el knob de nuestro dedo
            let position = touch.location(in: imgKnob)
            // Calculamos la distancia desde el centro a donde tenemos el dedo
            let dist = calculateDistanceFromCenter(position)
            // Comprobamos si estamos dentro del knob o fuera
            if touchIsInKnobWithDistance(distance: dist) {
                // Calculamos el ángulo según arrastramos
                let center = CGPoint(x: imgKnob.bounds.size.width/2, y: imgKnob.bounds.size.height/2)
                let deltaX = position.x - center.x
                let deltaY = position.y - center.y
                let angle = atan2(deltaY, deltaX)
                
                // Calculamos la distancia con el anterior
                let angleDif = deltaAngle - angle
                // Rotamos la imágen en base al ángulo de diferencia
                let newTransform = startTransform.rotated(by: -angleDif)
                // Tenemos que guardar el ultimo lugar donde esta el punto del knob
                let lastSetPointAngle = setPointAngle
                // Comprobamos que no sobrepasamos los límites establecidos (de 30 grados)
                // Al anterior le sumamos lo que nos hemos movido
                setPointAngle = setPointAngle + Double(angleDif)
                if setPointAngle >= minAngle && setPointAngle <= maxAngle {
                    // En este caso estamos dentro de los límites y por lo tanto cambiamos el color
                    // Y aplicamos la transformada
                    view.backgroundColor = UIColor(hue: colorValueFromAngle(angle: setPointAngle), saturation: 0.75, brightness: 0.75, alpha: 1.0)
                    imgKnob.transform =  newTransform
                    self.startTransform = newTransform
                } else {
                    // Si no está en el límite (se pasa) lo dejamos en el límite
                    setPointAngle = lastSetPointAngle
                }
            }
            
        }
        super.touchesMoved(touches, with: event)
    }
    
    private func colorValueFromAngle(angle: Double)-> CGFloat {
        let hueValue = (angle - minAngle) * (360 / maxAngle - minAngle)
        return CGFloat(hueValue / 360)
    }
    
    // Esto es el teorema de pitágoras
    private func calculateDistanceFromCenter(_ point: CGPoint)-> CGFloat {
        let center = CGPoint(x: imgKnob.bounds.size.width/2, y: imgKnob.bounds.size.height/2)
        let dx = point.x - center.x
        let dy = point.y - center.y
        return sqrt((dx * dy) + (dx * dy))
    }
}

