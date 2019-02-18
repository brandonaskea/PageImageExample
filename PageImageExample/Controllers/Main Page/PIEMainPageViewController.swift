//
//  PIEMainPageViewController.swift
//  PageImageExample
//
//  Created by Brandon Askea on 2/16/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

let mainPageErrorMessage = "The was an error loading the main page."

class PIEMainPageViewController: UIPageViewController {
    
    var content:[PIEContent] = []
    var contentViewControllers:[UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        PIENetworkManager().downloadImageContent { (errorMessage, content) in
            if let errorMessage = errorMessage {
                self.presentAlertWith(errorMessage)
            }
            else {
                self.loadViewControllersFor(content)
            }
        }
    }
    
    func presentAlertWith(_ errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadViewControllersFor(_ content: [PIEContent]) {
        self.contentViewControllers.removeAll()
        for c in content {
            guard let vc = UIStoryboard(name: "Content", bundle: .main).instantiateInitialViewController() as? PIEContentViewController else { return }
            vc.content = c
            self.contentViewControllers.append(vc)
        }
        DispatchQueue.main.async {
            if let firstVC = self.contentViewControllers.first {
                self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
            else {
                self.presentAlertWith(mainPageErrorMessage)
            }
        }
    }
    
}

// MARK: UIPageViewControllerDatasource

extension PIEMainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0,
        contentViewControllers.count > previousIndex
        else { return nil }
        return contentViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard contentViewControllers.count != nextIndex,
        contentViewControllers.count > nextIndex
        else { return nil }
        return contentViewControllers[nextIndex]
    }
}
