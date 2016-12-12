//
//  PickerTableCell.swift
//  Banking
//
//  Created by Niranjan Ravichandran on 11/1/16.
//  Copyright © 2016 uncc. All rights reserved.
//

import UIKit

protocol PickerValueChangedDelegate {
    func valueChanged(value: Int)
}

class PickerTableCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    
    let pickerData = [1, 2, 3, 4, 5]
    var delegate: PickerValueChangedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        picker.selectRow(2, inComponent: 0, animated: true)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.valueChanged(value: pickerData[row])
    }
    
}
