//
//  ViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/7/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import UIKit
import Interstellar
@available(iOS 9.0, *)
class GameViewController: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet weak var controlHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomBoardConstraint: NSLayoutConstraint!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var bottomBarConstraint: NSLayoutConstraint!
	@IBOutlet weak var topBarConstraint: NSLayoutConstraint!
	@IBOutlet weak var boardView: BoardView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var viewModel: GameViewModel!
	var control: NumberPickerViewController!
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.gameSignal.ensure(Thread.main).next { _ in
			self.boardView.controller = self
			self.boardView.drawNumbersForSquares(self.viewModel.puzzle, found: self.viewModel.playerSquares)
			self.activityIndicator.stopAnimating()
			self.scrollView.hidden = false
			self.scrollView.userInteractionEnabled = true
			self.zoomIn()
			self.scrollView.alpha = 0
			UIView.animateWithDuration(0.3, animations: {
				self.scrollView.alpha = 1
			})
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
		control = childViewControllers[0] as! NumberPickerViewController
		control.controller = self
		
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		boardView.setNeedsDisplay()
	}
	@IBAction func tapped(sender: UITapGestureRecognizer) {
		boardView.deselectAllSquares()
		if controlHeightConstraint.constant > 0
		{
			hideControl()
		}
		else
		{
			if CGRectContainsPoint(scrollView.frame, sender.locationOfTouch(0, inView: view))
			{
				zoomIn()
			}
			else
			{
				zoomOut()
			}
		}
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return boardView
	}
	
	var previousScale: CGFloat = 1
	func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
		previousScale = scrollView.zoomScale
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.userInteractionEnabled
		{
			let leftMargin = (scrollView.frame.size.width - boardView.frame.size.width)*0.5
			let topMargin = (scrollView.frame.size.height - boardView.frame.size.height)*0.5
			scrollView.contentInset = UIEdgeInsetsMake(max(0, topMargin), max(0, leftMargin), 0, 0)
			if scrollView.zoomScale < previousScale
			{
				showBars()
			}
			else if scrollView.zoomScale > previousScale
			{
				hideBars()
			}
		}
	}
	
	func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
		if scale < previousScale
		{
			zoomOut()
		}
		else if scale > previousScale
		{
			zoomIn()
		}
	}
	
	
	func zoomOut()
	{
		boardView.userInteractionEnabled = false
		view.layoutIfNeeded()
		showBars()
		UIView.animateWithDuration(0.3) {
			self.scrollView.zoomScale = 0.6
			self.scrollView.contentInset = UIEdgeInsetsMake(1, 1, 0, 0)
		}
		boardView.setNeedsDisplay()
		
	}
	
	func zoomIn()
	{
		boardView.userInteractionEnabled = true
		hideBars()
		UIView.animateWithDuration(0.3) {
			self.scrollView.zoomScale = 1
			self.view.layoutIfNeeded()
		}
		boardView.setNeedsDisplay()
		
	}
	
	func showBars()
	{
		view.layoutIfNeeded()
		bottomBarConstraint.constant = 0
		topBarConstraint.constant = 20
		UIView.animateWithDuration(0.3) {
			self.view.layoutIfNeeded()
			
		}
	}
	
	func hideBars()
	{
		view.layoutIfNeeded()
		bottomBarConstraint.constant = -64
		topBarConstraint.constant = -64 - 20
		UIView.animateWithDuration(0.3) {
			self.view.layoutIfNeeded()
		}
	}
	
	func showControl()
	{
		control.view.hidden = false
		scrollView.userInteractionEnabled = false
		hideBars()
		view.layoutIfNeeded()
		controlHeightConstraint.constant = view.frame.height - (scrollView.frame.origin.y + boardView.frame.height * 0.6) - 20
		UIView.animateWithDuration(0.3) {
			self.scrollView.zoomScale = 0.6
			let leftMargin = (self.scrollView.frame.size.width - self.boardView.frame.size.width)*0.5
			self.scrollView.contentInset = UIEdgeInsetsMake(0, leftMargin, 0, 0)
			self.view.layoutIfNeeded()
		}
	}
	
	func hideControl()
	{
		scrollView.userInteractionEnabled = true
		view.layoutIfNeeded()
		controlHeightConstraint.constant = 0
		UIView.animateWithDuration(0.3, animations: {
			self.scrollView.zoomScale = 1
			self.view.layoutIfNeeded()
			}) { _ in
				self.control.view.hidden = true
		}
		
	}
	func orientationChanged(_: NSNotification)
	{
		hideControl()
	}
	@IBAction func checkButtonPressed(sender: UIButton) {
		switch viewModel.checkProgress() {
		case .Finished: showMessage("toSuccess")
		case .GoodSoFar: showMessage("toNoMistakes")
		case .Mistake: showMessage("toFailure")
		}
	}
	
	func showMessage(segueIdentifier: String)
	{
		zoomOut()
		bottomBarConstraint.constant = -64
		UIView.animateWithDuration(0.3) {
			self.view.layoutIfNeeded()
		}
		performSegueWithIdentifier(segueIdentifier, sender: self)
	}
	
	func newGame()
	{
		hideBars()
		UIView.animateWithDuration(0.3, animations: {
			self.scrollView.alpha = 0
			}, completion: { _ in
				self.scrollView.hidden = true
				self.viewModel.loadGame()
		})
		activityIndicator.startAnimating()
	}
	
	func removeMistakes()
	{
		viewModel.removeMistakes()
		boardView.drawNumbersForSquares(viewModel.puzzle, found: viewModel.playerSquares)
	}
	
	func editSquareView(square: SquareView)
	{
		showControl()
		control.editSquareView(square)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let message = segue.destinationViewController as? MessageViewController
		{
			message.controller = self
		}
		
		if let settings = segue.destinationViewController as? SettingsViewController
		{
			settings.controller = self
		}
	}
	
	@IBAction func returnFromSegueActions(sender: UIStoryboardSegue){ }
	@IBAction func hintButtonPressed(sender: UIButton) {
		viewModel.giveHint()
		boardView.drawNumbersForSquares(viewModel.puzzle, found: viewModel.playerSquares)
	}
	
}

