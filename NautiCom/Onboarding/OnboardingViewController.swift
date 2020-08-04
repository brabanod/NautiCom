//
//  OnboardingViewController.swift
//  NautiCom
//
//  Created by Pascal Braband on 04.08.20.
//  Copyright © 2020 Pascal Braband. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingDashboard"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingCompass"),
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingPermissions")]
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "OnboardingBackgroundColor")
        
        self.isModalInPresentation = true

        self.dataSource = self
        
        // Set inital vc
        if let dashboardVC = orderedViewControllers.first {
            setViewControllers([dashboardVC],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    
    func showNext() {
        guard let currentVC = self.viewControllers?[0] else { return }
        guard let currentVCIndex = self.orderedViewControllers.firstIndex(of: currentVC) else { return }
        let nextVCIndex = currentVCIndex + 1
        
        guard nextVCIndex >= 0 else { return }
        guard nextVCIndex < orderedViewControllers.count else { return }
        
        let nextController = self.orderedViewControllers[nextVCIndex]
        self.setViewControllers([nextController], direction: .forward, animated: true, completion: nil)
    }
    
    
    @IBAction func exitAction(unwindSegue: UIStoryboardSegue) {
        
    }

}




extension OnboardingViewController: UIPageViewControllerDataSource {
 
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Determine index of previous vc
        guard let currentVCIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentVCIndex - 1
        
        // Limit View Controllers to 0 and vc count
        guard previousIndex >= 0 else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        return orderedViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Determine index of next vc
        guard let currentVCIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentVCIndex + 1
        
        // Limit View Controllers to vc count
        guard nextIndex < orderedViewControllers.count else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
}
