#Custom Clock Icon
Gives Winterboard themes the ability to modify the clock icon appearance.
##Why?
Because the color values of the live Clock icon in iOS 7 are hardcoded.
##How do i use it?
Custom Clock Icon is designed to be an enhancement for winterboard themes. To use this tweak in your theme:
*   add this package as a dependency to your themes debian control file
*   create a dictionary in your theme's Info.plist file called ```customclockicon```
*   inside that dictionary, create strings called:
+   	```blackDot```
+   	```hours```
+   	```minutes```
+   	```seconds```
+   	```redDot```
*   the value of those strings should be a color value in hexadecimal representation formatted like this: ```#FFFFFF```

That's all there is to it. MIT license.
