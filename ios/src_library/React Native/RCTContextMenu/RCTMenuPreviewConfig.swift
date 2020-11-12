//
//  RCTMenuPreviewConfig.swift
//  IosContextMenuExample
//
//  Created by Dominic Go on 11/8/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


@available(iOS 13.0, *)
struct PreviewConfig {
  
  // -----------------------
  // MARK: Type Declarations
  // -----------------------
  
  enum PreviewType: String {
    case DEFAULT;
    case CUSTOM;
  };

  enum PreviewSize: String {
    case INHERIT;
    case STRETCH;
  };
  
  // ----------------
  // MARK: Properties
  // ----------------
  
  var previewType: PreviewType = .DEFAULT;
  var previewSize: PreviewSize = .INHERIT;
  
  var isResizeAnimated = true;
  
  var borderRadius   : CGFloat?;
  var targetViewNode : NSNumber?;
  var backgroundColor: UIColor = .clear;
  
  var preferredCommitStyle: UIContextMenuInteractionCommitStyle = .dismiss;
};

// --------------------------
// MARK: PreviewConfig - Init
// --------------------------

@available(iOS 13.0, *)
extension PreviewConfig {
  
  init(dictionary: NSDictionary){
    self.borderRadius   = dictionary["borderRadius"  ] as? CGFloat;
    self.targetViewNode = dictionary["targetViewNode"] as? NSNumber;
    
    if let string      = dictionary["previewType"] as? String,
       let previewType = PreviewType(rawValue: string) {
      
      self.previewType = previewType;
    };
    
    if let string      = dictionary["previewSize"] as? String,
       let previewSize = PreviewSize(rawValue: string) {
      
      self.previewSize = previewSize;
    };
    
    if let isResizeAnimated = dictionary["isResizeAnimated"] as? Bool {
      self.isResizeAnimated = isResizeAnimated;
    };
    
    if let string  = dictionary["backgroundColor"] as? String,
       let bgColor = UIColor(cssColor: string) {
      
      self.backgroundColor = bgColor;
    };
    
    if let string = dictionary["preferredCommitStyle"] as? String,
       let preferredCommitStyle = UIContextMenuInteractionCommitStyle.fromString(string) {
      
      self.preferredCommitStyle = preferredCommitStyle;
    };
  };
  
  init?(dictionary: NSDictionary?){
    guard let dictionary = dictionary else { return nil };
    self.init(dictionary: dictionary);
  };
};
