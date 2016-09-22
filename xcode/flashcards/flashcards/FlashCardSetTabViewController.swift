//
//  FlashCardSetTabViewController.swift
//  baby-flashcards
//
//  Created by Michael Ishmael on 13/05/2016.
//  Copyright © 2016 66Bytes. All rights reserved.
//

import Foundation
import UIKit
import GRDB

protocol IApplicationEventHandler
{
    func deckSelected(_ tile:DeckViewData, frame:CGRect);
    func flashCardDismissed();
}


class FlashCardSetTabViewController : UITabBarController, IApplicationEventHandler
{
    var _collectionControllers:[UICollectionViewController] = []
    var _pictureController:UIViewController?
    var _clickCount = 0
    var _appData:AppData? = nil
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        do {
            let dbPool = try DatabasePool(path: "/Users/scorpio/Dev/Projects/flashcard-app/xcode/flashcards/flashcards/flashcards.db")
            
            try dbPool.read({ db in
                for row in Row.fetch(db, "SELECT * FROM card") {
                    let name: String = row.value(named: "name")
                    print(name)
                }
            })
            
        } catch let ex {
            print(ex)
        }
        
        if let path = Bundle.main.path(forResource: "appdata", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: [AnyObject]]
                
                let appData = AppData(json: json! as JSON)
                
                for cardSet in appData!.deckSets{
                    let layout = self.getFlowLayout()
                    let collectionController = DeckCollectionViewController(layout: layout, cardSet: cardSet, eventHandler: self as IApplicationEventHandler)
                    collectionController.collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                    collectionController.tabBarItem = UITabBarItem();
                    let tbi = collectionController.tabBarItem;
                    tbi?.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
                    tbi?.image = UIImage.init(named: cardSet.icon)
                    self._collectionControllers.append(collectionController)
                }
                
                self.viewControllers = self._collectionControllers;
                
            } catch let error as NSError {
                print(error.localizedDescription)
            } catch {
                
            }
        } else {
            print("Invalid filename/path.")
        }
        
        //super.init(nibName: nil, bundle: nil)

        

    
    /*
    var secondTab = new UIViewController ();
    secondTab.View.BackgroundColor = UIColor.Gray;
    secondTab.TabBarItem = new UITabBarItem ();
    secondTab.TabBarItem.ImageInsets = new UIEdgeInsets(6, 0, -6, 0);
    secondTab.TabBarItem.Image = UIImage.FromBundle ("lionIcon.png");
    */
        
    
    }

    
    func getFlowLayout() -> JumbleFlowLayout{
    
        let flowLayout = JumbleFlowLayout ()
    
            //HeaderReferenceSize = new CGSize (4, 50),
        flowLayout.sectionInset = UIEdgeInsets (top: 20,left: 10,bottom: 4,right: 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical;
        flowLayout.minimumInteritemSpacing = 4; // minimum spacing between cells
        flowLayout.minimumLineSpacing = 4 // minimum spacing between rows if ScrollDirection is Vertical or between columns if Horizontal
        flowLayout.itemSize = CGSize(width: 114, height: 140)
    
        return flowLayout;
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func deckSelected(_ tile:DeckViewData, frame:CGRect){
        _pictureController = FlashCardViewController(flashCard: tile.getNextFlashCard(), sourceFrame: frame, eventHandler: self as IApplicationEventHandler)
        let tr = FlashCardViewTransitioningDelegate();
        _pictureController!.transitioningDelegate = tr;
        
        self.present(_pictureController!, animated: true, completion: nil);
        _clickCount+=1;
    }
    
    func flashCardDismissed() {
        dismiss(animated: true, completion: checkAndJumble)
    }
    
    func checkAndJumble(){
        if _clickCount >= 5 {
            _clickCount = 0;
            (selectedViewController as! DeckCollectionViewController).jumble();
        }
    }

    
    //_pictureController.RemoveFromParentViewController();
    }
    

