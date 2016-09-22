//
//  DeckViewCell.swift
//  baby-flashcards
//
//  Created by Michael Ishmael on 16/05/2016.
//  Copyright © 2016 66Bytes. All rights reserved.
//

import Foundation
import UIKit

class DeckViewCell : UICollectionViewCell {
    
    fileprivate var _imageView:UIImageView
    
    override init(frame:CGRect){
        
        _imageView = UIImageView(frame: frame);
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.clear;
        self.contentView.isOpaque = false;
        
        
        _imageView.contentMode = UIViewContentMode.scaleAspectFit;
        _imageView.clipsToBounds = true;
        _imageView.layer.masksToBounds = true;
        _imageView.center = self.contentView.center;
        _imageView.isOpaque = false;
    
        //_imageView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        //CGAffineTransform.MakeScale (0.7f, 0.7,f);
        
        self.contentView.addSubview(_imageView);
        
        _imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        _imageView.translatesAutoresizingMaskIntoConstraints = true
        
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal var layer:CALayer {
        get{
            super.layer.speed = 0.4;
            return super.layer
        }
    }
    
    func setImagePath(_ value:String) {
        
        _imageView.image = UIImage.init(named: value)
        
    }
    
//    public override CALayer Layer {
//    get {
//				base.Layer.Speed = 0.4f;
//				return base.Layer;
//    }
//    }
//    
//    public String ImagePath {
//    set {
//				_imageView.Image = UIImage.FromBundle (value);;
//    }
//    }
    
    
    
}
