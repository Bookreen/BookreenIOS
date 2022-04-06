import Foundation
import UIKit

struct HourFieldModel {
    let hour: String
    let minute: String
}

final class HourPickerViewController: AppViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    

    var callback: ((HourFieldModel) -> Void)?
    var hour: HourFieldModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTitle.text = S.pleaseSelectHour.localized()
        
        self.buttonDone.setTitle(S.done.localized(), for: .normal)
     
        self.buttonDone.layer.cornerRadius = 10.0
       
        self.buttonCancel.setTitle(S.cancel.localized(), for: .normal)
        self.buttonCancel.layer.cornerRadius = 10.0
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hourPicker.delegate = self
        self.hourPicker.dataSource = self
        
        self.hourPicker.selectRow(self.findHourIndex(), inComponent: 0, animated: true)
        self.hourPicker.selectRow(self.findMinuteIndex(), inComponent: 1, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hourPicker.delegate = nil
        self.hourPicker.dataSource = nil
    }
    
    @IBAction func pressedButtonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedButtonDone(_ sender: UIButton) {
        let hourIndex = self.hourPicker.selectedRow(inComponent: 0)
        let minuteIndex = self.hourPicker.selectedRow(inComponent: 1)
        
        let hour = self.getHourList()[hourIndex]
        let minute = self.getMinuteList()[minuteIndex]
        self.dismiss(animated: true) {
            self.callback?(HourFieldModel(hour: hour, minute: minute))
        }
    }
    
    private func findHourIndex() -> Int {
        if let _hour = self.hour {
            var index = -1
            let hourAsString = _hour.hour
            for hour in self.getHourList() {
                index = index + 1
                if hour == hourAsString {
                    return index
                }
            }
        }
        return 0
    }
    
    private func findMinuteIndex() -> Int {
        if let _hour = self.hour {
            var index = -1
            let minuteAsString = _hour.minute
            for minute in self.getMinuteList() {
                index = index + 1
                if minute == minuteAsString {
                    return index
                }
            }
        }
        return 0
    }
}

extension HourPickerViewController {
    func getHourList() -> [String] {
        let list: [String] = [
            "07", "08", "09",
            "10", "11", "12",
            "13", "14", "15",
            "16", "17", "18", "19"
        ]
        return list
    }
    
    func getMinuteList() -> [String] {
        var list: [String] = []
        let end = 59
        for index  in 0...end {
            list.append(index < 10 ? "0\(index)" : "\(index)")
        }
        return list
    }
}

extension HourPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.getHourList().count
        case 1:
            return self.getMinuteList().count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel

        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

        label.textColor = UIColor.label
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)

        var text = ""

        switch component {
            case 0:
                text = self.getHourList()[row]
            case 1:
                text = self.getMinuteList()[row]
            default:
                break
        }

        label.text = text

        return label
    }
}
