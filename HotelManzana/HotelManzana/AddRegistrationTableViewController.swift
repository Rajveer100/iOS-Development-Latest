//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Rajveer Singh on 03/10/22.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    @IBOutlet weak var stayDurationLabel: UILabel!
    
    @IBOutlet weak var roomChargeLabel: UILabel!
    @IBOutlet weak var roomChargePerNightLabel: UILabel!
    
    @IBOutlet weak var wifiChargeLabel: UILabel!
    @IBOutlet weak var wifiChoiceLabel: UILabel!
    
    @IBOutlet weak var totalChargeLabel: UILabel!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false {
        
        didSet {
            
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        
        didSet {
            
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    var roomType: RoomType?
    
    var registration: Registration? {
        
        guard let roomType = roomType else {
            
            doneBarButton.isEnabled = false
            return nil
        }
        
        if let viewRegistration = viewRegistration {
            
            return Registration(firstName: viewRegistration.firstName,
                                lastName: viewRegistration.lastName,
                                emailAddress: viewRegistration.emailAddress,
                                checkInDate: viewRegistration.checkInDate,
                                checkOutDate: viewRegistration.checkOutDate,
                                numberOfAdults: viewRegistration.numberOfAdults,
                                numberOfChildren: viewRegistration.numberOfChildren,
                                wifi: viewRegistration.wifi,
                                roomType: viewRegistration.roomType)
        }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName,
                            lastName: lastName,
                            emailAddress: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChildren,
                            wifi: hasWifi,
                            roomType: roomType)
    }
    
    var viewRegistration: Registration?
    
    init?(coder: NSCoder, registration: Registration?) {
        
        viewRegistration = registration
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDoneButtonState()
        
        if let viewRegistration = viewRegistration {
            
            cancelBarButton.isHidden = true
            
            firstNameTextField.text = viewRegistration.firstName
            lastNameTextField.text = viewRegistration.lastName
            emailTextField.text = viewRegistration.emailAddress
            
            checkInDatePicker.date = viewRegistration.checkInDate
            checkOutDatePicker.date = viewRegistration.checkOutDate
            
            numberOfAdultsLabel.text = "\(viewRegistration.numberOfAdults)"
            numberOfAdultsStepper.value = Double(viewRegistration.numberOfAdults)
            
            numberOfChildrenLabel.text = "\(viewRegistration.numberOfChildren)"
            numberOfChildrenStepper.value = Double(viewRegistration.numberOfChildren)
            
            wifiSwitch.isOn = viewRegistration.wifi
            roomType = viewRegistration.roomType
        } else {
            
            let midnightToday = Calendar.current.startOfDay(for: Date())
            
            checkInDatePicker.minimumDate = midnightToday
            checkInDatePicker.date = midnightToday
        }
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        updateDateViews()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        
        let numberOfNights = Int(numberOfNightsLabel.text ?? "0")!
        let wifiCost = 10 * numberOfNights
        
        wifiChargeLabel.text = (wifiSwitch.isOn ? "$ \(wifiCost)" : "$ 0")
        wifiChoiceLabel.text = (wifiSwitch.isOn ? "Yes" : "No")
        
        updateTotalCost()
    }
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        
        return selectRoomTypeController
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
    }
    
    @IBAction func firstNameTextFieldEditingChanged(_ sender: Any) {
        
        updateDoneButtonState()
    }
    
    @IBAction func lastNameTextFieldEditingChanged(_ sender: Any) {
        
        updateDoneButtonState()
    }
    
    @IBAction func emailTextFieldEditingChanged(_ sender: Any) {
        
        updateDoneButtonState()
    }
    
    func updateDoneButtonState() {
        
        doneBarButton.isEnabled = (!(firstNameTextField.text ?? "").isEmpty &&
                                   !(lastNameTextField.text ?? "").isEmpty &&
                                   !(emailTextField.text ?? "").isEmpty &&
                                   roomType != nil)
    }
    
    func updateDateViews() {
        
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        
        let numberOfNightsInSeconds = checkInDate.distance(to: checkOutDate)
        let numberOfNightsInDays = Int(floor(numberOfNightsInSeconds / 86400))
        
        numberOfNightsLabel.text = "\(numberOfNightsInDays)"
        stayDurationLabel.text = (checkInDate ..< checkOutDate).formatted(date: .numeric, time: .omitted)
        
        updateRoomCost()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
            
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            
            return 0
            
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            
            return 0
            
        default:
            
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
            
        case checkInDatePickerCellIndexPath:
            
            return 190
            
        case checkOutDatePickerCellIndexPath:
            
            return 190
        
        default:
            
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath {
            
            if isCheckOutDatePickerVisible && !isCheckInDatePickerVisible {
                
                isCheckOutDatePickerVisible.toggle()
            }
            
            isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath {
            
            if isCheckInDatePickerVisible && !isCheckOutDatePickerVisible {
                
                isCheckInDatePickerVisible.toggle()
            }
            
            isCheckOutDatePickerVisible.toggle()
        } else {
            
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func updateNumberOfGuests() {
        
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        
        if let roomType = roomType {
            
            roomTypeLabel.text = roomType.name
            
            updateRoomCost()
        } else {
            
            roomTypeLabel.text = "Not Set"
        }
        
        updateDoneButtonState()
    }
    
    func updateRoomCost() {
        
        guard let roomType = roomType else { return }
        
        let numberOfNights = Int(numberOfNightsLabel.text ?? "0")!
        let roomCost = roomType.price * numberOfNights
        
        roomChargeLabel.text = "$ \(roomCost)"
        roomChargePerNightLabel.text = "\(roomType.name) @ $ \(roomType.price)/night"
        
        updateTotalCost()
    }
    
    func updateTotalCost() {
        
        guard let roomType = roomType else { return }
        
        let numberOfNights = Int(numberOfNightsLabel.text ?? "0")!
        
        let roomCost = roomType.price * numberOfNights
        let wifiCost = (wifiSwitch.isOn ? 10 * numberOfNights : 0)
        
        let totalCost = roomCost + wifiCost
        
        totalChargeLabel.text = "$ \(totalCost)"
    }
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        
        self.roomType = roomType
        
        updateRoomType()
    }
}
