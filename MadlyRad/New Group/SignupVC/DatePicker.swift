//
//  DatePicker.swift
//  MadlyRad
//
//  Created by JOJO on 7/19/20.
//  Copyright © 2020 MadlyRad. All rights reserved.
//

import UIKit

class DatePicker: UIViewController {
        
        // Age of 13.
        let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -13, to: Date())!;
        
        // Age of 100.
        let MAXIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -150, to: Date())!;
        
        @IBOutlet weak var datePicker: UIDatePicker!
        
        @IBAction func validateButtonPressed(_ sender: Any) {
            let isValidAge = validateAge(birthDate: datePicker.date);
            
            if isValidAge {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "Terms")
               self.present(controller, animated: true, completion: nil);
            } else {
                showAlert(title: "Too Young", message: "Must be at least 13");
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        func validateAge(birthDate: Date) -> Bool {
            var isValid: Bool = true;
            
            if birthDate < MAXIMUM_AGE || birthDate > MINIMUM_AGE {
                isValid = false;
            }
            
            return isValid;
        }
        
        func showAlert(title: String, message: String) {
            // Create alert controller.
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil);
            alertController.addAction(alertAction);
            

            self.present(alertController, animated: true, completion: nil);
        }
    }
