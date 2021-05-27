//
//  MainViewController.swift
//  GithubUser
//
import UIKit
import RxCocoa
import RxSwift
import Extensions
import Reusable

final class MainViewController: BaseViewController<MainViewModelType>
{
    
    @IBOutlet private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
  
    // MARK: Setup
    override func setupView() {
        super.setupView()
        tableView.register(cellType: UserTableViewCell.self)
    }
  
    override func bindInput(viewModel: MainViewModelType) {
        super.bindInput(viewModel: viewModel)
        
        rx.viewDidLoad
            .bind(to: viewModel.inputs.viewDidLoadTrigger)
            .disposed(by: disposeBag)
    }
    
    override func bindOutput(viewModel: MainViewModelType) {
        super.bindOutput(viewModel: viewModel)
        
        viewModel.outputs.usersResult
            .drive(tableView.rx.items){ (table, item, element) in
                let indexPath = IndexPath(item: item, section: 0)
                let cell: UserTableViewCell = table.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
                let vm = UserTableCellViewModel(user: element)
                cell.configure(vm)
                return cell
            }
            .disposed(by: disposeBag)

    }
  
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
