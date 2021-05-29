//
//  UserRepositoryViewController.swift
//  GithubUser
//
import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Extensions
import Reusable

final class UserRepositoryViewController: BaseViewController<UserRepositoryType> {
    
    @IBOutlet private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    // MARK: Setup
    override func setupView() {
        super.setupView()
        tableView.register(cellType: UserTableViewCell.self)
        tableView.register(cellType: UserRepoTableViewCell.self)
        tableView.delegate = self
      
        navigationItem.title = "Repositories"
    }
    
    override func bindInput(viewModel: UserRepositoryType) {
        super.bindInput(viewModel: viewModel)
        
        rx.viewDidLoad
            .bind(to: viewModel.inputs.viewDidLoadTrigger)
            .disposed(by: disposeBag)
    }
    
    override func bindOutput(viewModel: UserRepositoryType) {
        super.bindOutput(viewModel: viewModel)
        
        viewModel.outputs.isLoading.drive(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            isLoading ? self.showSpinner() : self.hideSpinner()
        }).disposed(by: bag)

        let datasource = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { (_, tableView, index, item) -> UITableViewCell in
            
            switch item {
            
            case .userList(_):
                return UITableViewCell()
                
            case .userRepo(let viewModel):
                let cell: UserRepoTableViewCell = tableView.dequeueReusableCell(for: index, cellType: UserRepoTableViewCell.self)
                cell.configure(viewModel)
                return cell
            }
        })
        
        viewModel.outputs.sectionRows
            .drive(tableView.rx.items(dataSource: datasource))
            .disposed(by: bag)
        
        viewModel.outputs.alertError.drive { msg in
            let actionSheet =  UIAlertController(title: msg, message: nil, preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                viewModel.inputs.backPage()
            }))
            self.present(actionSheet, animated: true, completion: nil)
        }.disposed(by: bag)
    }
}

extension UserRepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell
        cell?.configure(viewModel.outputs.headerViewModel)
        cell?.hideFavoriteButton()
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.3967932876)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
}

