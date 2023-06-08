import UIKit

final class AlertService {
    
    func addFilterAlert(from viewController: UIViewController, delegate: FilterDelegate?) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Filter", message: "", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Type new filter"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            guard let textFieldText = textField.text else { return }
            delegate?.wasAddFilter(textFieldText)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(from viewController: UIViewController) {
        let alert = UIAlertController(title: "Unable to open", message: "Sorry, but access to this site is denied. You can change it in your filters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Filters", style: .default, handler: { action in
            let filterVC = FilterViewController()
            viewController.navigationController?.pushViewController(filterVC, animated: true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
