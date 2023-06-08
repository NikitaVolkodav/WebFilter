import UIKit

final class FilterViewController: UIViewController {
    
    private let tableView = UITableView()
    private let alertService = AlertService()
    private var filtersModel = FiltersModel()
    private let filterCacheService = FilterCacheService()
    private var dataReloadDelegate: DataReloadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataReloadDelegate = self
        filtersModel.filters = filterCacheService.getFilters()
        view.addSubview(tableView)
        registerCell()
        addTableViewConstraints()
        addDelegateDataSource()
        addButtonInNavigationBar()
    }
    
    @objc private func addFilter() {
        alertService.addFilterAlert(from: self, delegate: self )
    }
    
    private func addDelegateDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCell() {
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterCell")
    }
    
    private func addButtonInNavigationBar() {
        var imagePlus = UIImage(systemName: "plus")?.withTintColor(.black)
        imagePlus = imagePlus?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imagePlus, style: .plain, target: self, action: #selector(addFilter))
        navigationController?.navigationBar.tintColor = .black
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtersModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdendifier: String = "FilterCell"
        guard let mainCell = tableView.dequeueReusableCell(withIdentifier: cellIdendifier, for: indexPath) as? FilterTableViewCell else { return UITableViewCell()}
        mainCell.textLabel?.text = filtersModel.filters[indexPath.row]
        return mainCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            filtersModel.filters.remove(at: indexPath.row)
            filterCacheService.saveFilters(filtersModel.filters)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FilterViewController: FilterDelegate {
    func wasAddFilter(_ newFilter: String) {
        filtersModel.filters.append(newFilter)
        filterCacheService.saveFilters(filtersModel.filters)
        tableView.reloadData()
    }
}

extension FilterViewController: DataReloadDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
