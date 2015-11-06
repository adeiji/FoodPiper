//
//  PeepPageViewController.swift
//  FoodPiper
//
//  Created by adeiji on 11/6/15.
//  Copyright © 2015 Dephyned. All rights reserved.
//

import UIKit

class PeepPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController:UIPageViewController!
    var pipes:[PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    func reset () {
        // Get the Paging View Controller
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let peepViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([peepViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = self.view.frame
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! PeepViewController).pageIndex!
        if index <= 0 {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! PeepViewController).pageIndex!
        if index >= pipes!.count - 1 {
            return nil
        }
        
        index++
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if pipes == nil {
            return nil
        }
        let peepViewController = PeepViewController.init(nibName:"ViewPeep", bundle: nil)
        peepViewController.pageIndex = index
        peepViewController.pipe = pipes?[index] as! Pipe
        return peepViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pipes!.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
