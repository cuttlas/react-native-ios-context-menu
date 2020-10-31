//
//  RCTContextMenuButton.swift
//  IosContextMenuExample
//
//  Created by Dominic Go on 10/28/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit;


@available(iOS 14, *)
class RCTContextMenuButton: UIButton {
  
  var isContextMenuVisible = false;
  var didPressMenuItem     = false;
  
  // ---------------------------------------------
  // MARK: RCTContextMenuButton - RN Event Callbacks
  // ---------------------------------------------
  
  @objc var onMenuWillShow  : RCTBubblingEventBlock?;
  @objc var onMenuWillHide  : RCTBubblingEventBlock?;
  @objc var onMenuWillCancel: RCTBubblingEventBlock?;
  
  @objc var onMenuDidShow  : RCTBubblingEventBlock?;
  @objc var onMenuDidHide  : RCTBubblingEventBlock?;
  @objc var onMenuDidCancel: RCTBubblingEventBlock?;
  
  @objc var onPressMenuItem: RCTBubblingEventBlock?;
  
  // -------------------------------------
  // MARK: RCTContextMenuButton - RN Props
  // -------------------------------------
    
  @objc var menuConfig: NSDictionary? {
    didSet {
      guard
        let menuConfig     = self.menuConfig, menuConfig.count > 0,
        let rootMenuConfig = RCTMenuItem(dictionary: menuConfig) else { return };
      
      #if DEBUG
      print("RCTContextMenuButton"
        + " - menuConfig didSet"
        + " - RCTMenuItem init"
      );
      #endif
     
      let rootMenu = rootMenuConfig.createMenu {(dict, action) in
        self.didPressMenuItem = true;
        self.onPressMenuItem?(dict);
      };
      
      if self.isContextMenuVisible,
         let interaction: UIContextMenuInteraction = self.contextMenuInteraction {
        
        // context menu is open, update the menu items
        interaction.updateVisibleMenu {(menu: UIMenu) in
          menu.replacingChildren(menu.children);
          return menu;
        };
        
      } else {
        // set menu property
        self.menu = rootMenu;
      };
    }
  };
  
  // TODO: wip
  @objc var isMenuPrimaryAction: Bool = false {
    didSet {
      guard self.isMenuPrimaryAction != oldValue else { return };
      self.showsMenuAsPrimaryAction = self.isMenuPrimaryAction;
    }
  };
  
  // TODO: wip
  @objc var enableContextMenu: Bool = true {
    didSet {
      guard self.enableContextMenu != oldValue else { return };
      self.isContextMenuInteractionEnabled = self.isMenuPrimaryAction;
    }
  };
  
  // ---------------------------------
  // MARK: RCTContextMenuButton - Init
  // ---------------------------------
  
  init(bridge: RCTBridge) {
    super.init(frame: CGRect());
    
    let interaction = UIContextMenuInteraction(delegate: self);
    self.addInteraction(interaction);
    
    self.addAction( UIAction(title: ""){ action in
      // TODO: wip
    }, for: .menuActionTriggered);
    
    self.addAction( UIAction(title: ""){ action in
      // TODO: wip
    }, for: .primaryActionTriggered);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  override func reactSetFrame(_ frame: CGRect) {
    super.reactSetFrame(frame);
  };
};

// ---------------------------------------------------------
// MARK: RCTContextMenuButton - Public Functions for Manager
// ---------------------------------------------------------

func dismissMenu(){
  // TODO: wip
};

// -------------------------------------------------------------
// MARK: RCTContextMenuButton - UIContextMenuInteractionDelegate
// -------------------------------------------------------------

@available(iOS 14, *)
extension RCTContextMenuButton {
  
  // context menu display begins
  override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    super.contextMenuInteraction(interaction, willDisplayMenuFor: configuration, animator: animator);
    
    #if DEBUG
    print("RCTContextMenuButton, UIContextMenuInteractionDelegate"
      + " - contextMenuInteraction: will show"
    );
    #endif

    self.isContextMenuVisible = true;
    
    self.onMenuWillShow?([:]);
    animator?.addCompletion {
      self.onMenuDidShow?([:]);
    };
  };
  
  // context menu display ends
  override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    super.contextMenuInteraction(interaction, willEndFor: configuration, animator: animator);
    
    #if DEBUG
    print("RCTContextMenuButton, UIContextMenuInteractionDelegate"
      + " - contextMenuInteraction: will hide"
    );
    #endif
    
    guard self.isContextMenuVisible else { return };
    
    self.onMenuWillHide?([:]);
    if !self.didPressMenuItem {
      self.onMenuWillCancel?([:]);
    };
    
    animator?.addCompletion {
      if !self.didPressMenuItem {
        self.onMenuDidCancel?([:]);
      };
      
      self.onMenuDidHide?([:]);
      self.didPressMenuItem = false;
    };
    
    self.isContextMenuVisible = false;
  };
};
