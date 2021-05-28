//
//  MainViewController.swift
//  GithubUser
//
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
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
        tableView.delegate = self
    }
  
    override func bindInput(viewModel: MainViewModelType) {
        super.bindInput(viewModel: viewModel)
        
        rx.viewDidLoad
            .bind(to: viewModel.inputs.viewDidLoadTrigger)
            .disposed(by: disposeBag)
    }
    
    override func bindOutput(viewModel: MainViewModelType) {
        super.bindOutput(viewModel: viewModel)
        
        viewModel.outputs.isLoading.drive(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            isLoading ? self.showSpinner() : self.hideSpinner()
        }).disposed(by: bag)

        let datasource = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { [weak self](_, tableView, index, item) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            
            switch item {
            case .userList(let viewModel):
                let cell: UserTableViewCell = tableView.dequeueReusableCell(for: index, cellType: UserTableViewCell.self)
                cell.configure(viewModel)
                cell.addFavoriteCallback = { userId in
                    self.viewModel.inputs.addFavoriteTrigger.accept(userId)
                    tableView.reloadData()
                }
                cell.checkFavoriteStatus(self.viewModel.outputs.favoriteList)
    
                return cell
            }
        })
        
        viewModel.outputs.sectionRows
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: bag)
    }
  
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath.row)")
    }
}
