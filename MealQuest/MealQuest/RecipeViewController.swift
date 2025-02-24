//
//  RecipeViewController.swift
//  MealQuest
//
//  Created by Will Lam on 2017-06-07.
//  Copyright © 2017 LifeQuest. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    let overviewView = Bundle.main.loadNibNamed("OverviewView", owner: self, options: nil)!.first! as! OverviewView
    let ingredientsView = Bundle.main.loadNibNamed("IngredientsView", owner: self, options: nil)!.first! as! IngredientsView
    let instructionsView = Bundle.main.loadNibNamed("InstructionsView", owner: self, options: nil)!.first! as! InstructionsView
    let buttonCell = Bundle.main.loadNibNamed("ButtonCell", owner: self, options: nil)!.first! as! ButtonCell
    
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var ingredientsArray = [RecipeIngredient]()
    var servingSize = Double(1)

    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
    
    var categoryResults = [RecipeItem]()
    var recipeDetails = RecipeItem(id: -1)
    var detailsPassed = RecipeItem(id: -1)
    var id = Int64()
    var observer = ResultsTableViewController()
    var random = false
    
    // This function only calls from editing a favorite recipe
    func redrawView( ) {
        setOverviewView()
        setIngredientsView()
        setInstructionsView()
        ingredientsView.ingredientsTable.reloadData()
        
        // Redraw the results table
        if (!random) {
            observer.redrawTable()
        }
    }
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        if (!random) {
            observer.redrawTable()

        }
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        id = recipeDetails.recipeID
        
        print("setting up overview, ingredients, and instructions")
        // Do any additional setup after loading the view.
        setOverviewView( )
        containerView.addSubview(overviewView)
        overviewView.pinToSuperview()
        
        setIngredientsView( )
        containerView.addSubview(ingredientsView)
        ingredientsView.pinToSuperview()
        
        setInstructionsView( )
        containerView.addSubview(instructionsView)
        instructionsView.pinToSuperview()
        
        containerView.bringSubview(toFront: overviewView)
        
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func tabChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        
        if (sender.selectedSegmentIndex == 0) {
            containerView.bringSubview(toFront: overviewView)
        } else if (sender.selectedSegmentIndex == 1) {
            containerView.bringSubview(toFront: ingredientsView)
        } else if (sender.selectedSegmentIndex == 2) {
            containerView.bringSubview(toFront: instructionsView)
        } else {
            print("ERROR: unknown selected segment index")
        }
    }
}
