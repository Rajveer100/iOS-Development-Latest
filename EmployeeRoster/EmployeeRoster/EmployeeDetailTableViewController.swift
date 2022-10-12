
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    @IBOutlet var employeeTypeLabel: UILabel!
    
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    var employeeType: EmployeeType?
    
    var isDatePickerVisible: Bool = false
    var isEditingBirthday: Bool = false {
        
        didSet {
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var datePickerCellIndexPath: IndexPath = IndexPath(row: 2, section: 0)
    var birthdayCellIndexPath: IndexPath = IndexPath(row: 1, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField.text,
              let employeeType = employeeType else { return }
        
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        
        updateSaveButtonState()
    }
    
    @IBAction func dobDatePickerValueChanged(_ sender: Any) {
        
        dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        
        let viewController = EmployeeTypeTableViewController(coder: coder)
        viewController?.delegate = self
        
        return viewController
    }
    
    func updateView() {
        
        if let employee = employee {
            
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        
        let shouldEnableSaveButton = (nameTextField.text?.isEmpty == false && employeeType != nil)
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == datePickerCellIndexPath && isEditingBirthday == false {
            
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == birthdayCellIndexPath {
            
            isEditingBirthday.toggle()
            
            dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
        }
    }
    
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
        
        self.employeeType = employeeType
        
        employeeTypeLabel.text = "\(employeeType)"
        employeeTypeLabel.textColor = .black
        
        updateSaveButtonState()
    }
}
