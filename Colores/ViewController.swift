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
            view.backgroundColor = UIColor(hue:0.5,saturation:0.5,brightness:0.75,alpha:1.0)
            imgKnob.isHidden = false
            imgKnobBase.isHidden = false
        } else {
            view.backgroundColor = UIColor(hue:0.5,saturation:0,brightness:0.2,alpha:1.0)
            imgKnob.isHidden = true
            imgKnobBase.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_on"), for: .selected)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

