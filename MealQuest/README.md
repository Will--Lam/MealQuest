Important: Installing SQLite.swift

1. Unzip SQLite.swift-master.zip
2. Go into the folder, drag the SQLite.xcodeproj file into your Xcode 
3. Click on the blue "MealQuest" and go to add Embedded Binaries
Note: choose MealQuest -> SQLite.xcodeproj -> SQLite.framework iOS
4. Build, which should be successful
(Refer to https://github.com/stephencelis/SQLite.swift#manual)

To link UI elements:
1. In the Story Board, click on the round yellow "View Controller"
2. On the side bar, click the newspaper icon
3. Put the name of the custom view controller you want to link to in "Custom Class"
4. Build (command+b)
5. In your custom view controller, drag the hollow circle near to the UI element
6. The hollow circle should be solid and it's linked!'
