//
//  testSearchUser.swift
//  GithubUserTests
//
//  Created by Trithep Thumrongluck on 29/5/2564 BE.
//

import XCTest
import Domain
import RxSwift
import RxTest
import SceneCore
import Platform
import Networking
import FBSnapshotTestCase
@testable import GithubUser

class SearchUserTests: FBSnapshotTestCase {
    
    var scheduler: TestScheduler!
    let bag = DisposeBag()
    var provider: UseCaseProviderDomain!
    var coordinator: SceneCoordinator!
    var vc: MainViewController!

    override func setUp() {
        super.setUp()
//        recordMode = true
        scheduler = TestScheduler(initialClock: 0)
        provider = UseCaseProvider(network: URLSessionNetwork(base: URL(string: BaseURL.api)!, environment: .local))
        coordinator = SceneCoordinator(window: UIWindow(frame: UIScreen.main.bounds))
        let viewModel = MainViewModel(coordinator: coordinator, provider: provider)
        let scene = MainScene.main(viewModel: viewModel)
        vc = scene.viewController as? MainViewController
    }

    override func tearDown() {
        
    }
    
    func testSeacrhUserFound_then_displayUserInfo() {
    
        FBSnapshotVerifyView(vc.view)
        
        let json = jsonDataSearchGitHubUser(userName: "mojombo")
        
        do {
            let user = try JSONDecoder().decode(UserSearch.self, from: json)
            let result = user.items!.first(where: { $0.login == "mojombo" })
            let sut = UserTableCellViewModel(user: result!)
            
            XCTAssert(sut.outputs.name == "mojombo")
            XCTAssert(sut.outputs.imageUrl != nil)
            XCTAssert(!sut.outputs.url.isEmpty)
            XCTAssertEqual("mojombo", result!.login)
        } catch {
            XCTFail("Cannot parse object")
        }
    }
    
    func testSearchUserWithAtLeastOneCharacterInput_then_getSearchResult() {
        
        FBSnapshotVerifyView(vc.view)
        
        let sut = MainViewModel(coordinator: coordinator, provider: provider)
        
        let sections = scheduler.createObserver([UserSection].self)
        sut.outputs.sectionRows.drive(sections).disposed(by: bag)
        scheduler.createColdObservable([.next(1, "a")])
            .bind(to: sut.inputs.searchUserTrigger).disposed(by: bag)
        
        let foundUser = scheduler.createObserver(Bool.self)
        
        sut.outputs.sectionRows.asObservable().map{ sections in
            sections[0].items.count > 0
        }.bind(to: foundUser).disposed(by: bag)

        scheduler.start()
        
        XCTAssertEqual(foundUser.events, [.next(1, true)])
    }
    
    func testSearchUserWithoutCharacterInput_then_noSearchResult() {
        
        FBSnapshotVerifyView(vc.view)
        
        let sut = MainViewModel(coordinator: coordinator, provider: provider)
        
        let sections = scheduler.createObserver([UserSection].self)
        sut.outputs.sectionRows.drive(sections).disposed(by: bag)
        scheduler.createColdObservable([.next(1, "")])
            .bind(to: sut.inputs.searchUserTrigger).disposed(by: bag)
        
        let foundUser = scheduler.createObserver(Bool.self)
        
        sut.outputs.sectionRows.asObservable().map{ sections in
            sections[0].items.count > 0
        }.bind(to: foundUser).disposed(by: bag)

        scheduler.start()
        
        XCTAssertEqual(foundUser.events, [])
    }
}

private extension SearchUserTests {
    
    func jsonDataSearchGitHubUser(userName: String) -> Data {
        let json = """
          {
            "total_count": 33309,
            "incomplete_results": false,
            "items": [
              {
                "login": "\(userName)",
                "id": 1134163,
                "node_id": "MDQ6VXNlcjExMzQxNjM=",
                "avatar_url": "https://avatars.githubusercontent.com/u/1134163?v=4",
                "gravatar_id": "",
                "url": "https://api.github.com/users/wy",
                "html_url": "https://github.com/wy",
                "followers_url": "https://api.github.com/users/wy/followers",
                "following_url": "https://api.github.com/users/wy/following{/other_user}",
                "gists_url": "https://api.github.com/users/wy/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/wy/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/wy/subscriptions",
                "organizations_url": "https://api.github.com/users/wy/orgs",
                "repos_url": "https://api.github.com/users/wy/repos",
                "events_url": "https://api.github.com/users/wy/events{/privacy}",
                "received_events_url": "https://api.github.com/users/wy/received_events",
                "type": "User",
                "site_admin": false,
                "score": 1.0
              }
            ]
          }
        """
        return json.data(using: .utf8)!
    }
}
