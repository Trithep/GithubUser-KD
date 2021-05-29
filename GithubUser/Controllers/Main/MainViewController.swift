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
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var sortButton: UIButton!
    @IBOutlet private var filtterButton: UIButton!
    
    private let disposeBag = DisposeBag()
  
    // MARK: Setup
    override func setupView() {
        super.setupView()
        tableView.register(cellType: UserTableViewCell.self)
        tableView.delegate = self
        
        navigationItem.title = "GitHub User"
    }
  
    override func bindInput(viewModel: MainViewModelType) {
        super.bindInput(viewModel: viewModel)
        
        rx.viewDidLoad
            .bind(to: viewModel.inputs.viewDidLoadTrigger)
            .disposed(by: disposeBag)
        
        sortButton.rx.tap.bind(to: viewModel.inputs.sortUserTrigger)
            .disposed(by: disposeBag)
        
        filtterButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let actionSheet =  UIAlertController(title: "Filter user", message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "All", style: .default, handler: { action in
                viewModel.inputs.filterUserTrigger.accept(.all)
            }))
            actionSheet.addAction(UIAlertAction(title: "Favorite", style: .default, handler: { action in
                viewModel.inputs.filterUserTrigger.accept(.favorite)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty.twoWayBind(to: viewModel.inputs.searchUserTrigger)
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
                
            default: return UITableViewCell()
            }
        })
        
        viewModel.outputs.sectionRows
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: bag)
        
        viewModel.outputs.sortStateChange.drive(sortButton.rx.isSelected).disposed(by: disposeBag)
        
        viewModel.outputs.alertError.drive { msg in
            let actionSheet =  UIAlertController(title: msg, message: nil, preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
                guard let self = self else { return }
                self.searchTextField.text = ""
            }))
            self.present(actionSheet, animated: true, completion: nil)
        }.disposed(by: bag)
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputs.openUserDetailTrigger.accept(indexPath.row)
    }
}
