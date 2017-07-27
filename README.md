# Runners-Air-Check
Check your city's air pollution level before you go for a run to make sure it's safe!

<img src="https://user-images.githubusercontent.com/11513453/28634261-7c46635c-71eb-11e7-8369-c79c4e660a68.png">  <img src="https://user-images.githubusercontent.com/11513453/28634263-7d5a607c-71eb-11e7-9e18-79a375195ca9.png">  

Most major cities are supported, but occassionally, there may be no data for the city you enter.

<img src="https://user-images.githubusercontent.com/11513453/28634264-7e83d500-71eb-11e7-8847-351f483de362.png">

## Approach
Runners' Air Check follows the MVC pattern. The model contains networking code for the [AQICN API](http://aqicn.org/api/), as well as the NSManagedObject subclasses for Core Data. Images used in the app are purchased from [iStockPhoto](http://www.istockphoto.com/).

The app has 3 main view controllers:
1. Search View Controller (embedded in a Tab Bar Controller)
2. Saved View Controller (embedded in a Tab Bar Controller and Navigation Controller)
3. Air Score View Controller

### Search View Controller
In the search view, users enter the name of a city. If the city consists of 2 or more words separated by a space, it is concatenated into a string without spaces. A GET request is then sent to the AQICN API to retrieve air quality data associated with that string. Depending on the air quality, the view displays either an image of a trail (it's safe to run outside) or a treadmill (it's unsafe to run outside), along with a message of running advice. The air quality score is displayed in a circle, and the score determines the circle's fill color (according to the universal air quality color scale: green -> yellow -> orange -> red -> purple -> brown, with green representing the cleanest air).

In this view, the user can choose to save the location they just entered by pressing the Save This Location button. The location is then saved to Core Data.

### Saved View Controller
The saved view displays all the user's saved locations in a table view in alphabetical order. The user can tap any row to view the air quality score and message of advice for that location. The user can also swipe left on any row to delete that saved location. 

### Air Score View Controller
When the user taps a row in the Saved View Controller, the Air Score View Controller is presented, with the air quality score and message of advice.

## Usage
Runners' Air Check is written in Swift 3. You can download this project and run it in any version of Xcode and Simulator. 

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request.
