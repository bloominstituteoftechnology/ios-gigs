# Gigs Part 2

Please look at the screen recording below to know what the finished project should look like:

![Gigs Screen Recording](https://user-images.githubusercontent.com/16965587/57464723-71893d80-723a-11e9-87fe-1831188727e5.gif)

## Introduction

Use the project you worked on yesterday afternoon and continue where you left off. You don't have to create a new branch for today's features but you are welcome to.

## Part 1 - Storyboard Additions

1. In Main.storyboard add a new `UIViewController` scene. This will be used for creating new gigs, and viewing details about existing ones.

2. Create a show segue from the table view controller's cell to this new scene. Give the segue an identifier that describes what the user would expect to do in this view controller based on the thing triggering the segue. In this case "ShowGig", "ViewGig", etc. may make sense.

3. Add a bar button item to the right of the navigation item in the table view controller scene. Set its "System Item" to "Add" in the Attributes Inspector.
    
4. Create another show segue from the bar button item to this new `UIViewController` scene. Again, give the segue a descriptive identifier. 
    
    - Create a Cocoa Touch Subclass of `UITableViewController` called `GigsTableViewController` and set this table view controller scene's class to this new subclass you just created.

3. Add a `UIViewController` scene for signing up/logging in:
    - Create a modal **manual** segue from the `GigsTableViewController` scene to this new view controller scene. Click on the segue in the storyboard and change its "Presentation" to "Full Screen" in the Attributes Inspector.
5. Add a text field to put the gig's title in.
    
6. Add a date picker to allow the user to select the due date of the gig.
    
7. Add a text view to put a longer description of the gig in.
    
8. Add a label next to each of these three UI elements describing what its purpose is ("Job Title:", "Due Date:", "Description:").
    
9. Add a navigation item to this scene, so you can then add a bar button item with the "Save" "System Item" in the Attributes Inspector.
    
10. Create a Cocoa Touch file that is a subclass of `UIViewController` called "GigDetailViewController". Set this new view controller scene's class to `GigDetailViewController` in the Identity Inspector.
    
11. Create outlets from the text field, date picker, and text view. 
    
12. Create an action from the save button.

## Part 2 - Gig Model

1. Create a "Gig.swift" file and add a new struct called `Gig`. It should have the following properties:
    - A title.
    - A description.
    - A due date as a `Date`.

Here is a `Gig` in JSON format that the API will return:

``` JSON
{
  "title": "Test Job",
  "dueDate": "2019-05-10T05:29:01Z",
  "description": "This is just a test"
}
```

This date format in the JSON above is called "ISO 8601", which is another common format for dates. Luckily, when you get to decoding the JSON data, you can specify that you want dates to be decoded from this format using the `.dateDecodingStrategy` property on your `JSONDecoder` instance.

## Part 3 - GigController

1. Add a new variable called `var gigs: [Gig] = []` that will be used for storing the fetched and created gigs. This will also be the data source for the table view.

2. Again following the API's documentation [here](https://github.com/LambdaSchool/ios-gigs/blob/master/APIDocumentation.md), create methods that perform a `URLSessionDataTask` for:

    - Getting all the gigs the API has. Once you decode the `Gig`s, set the value of the array of `Gig`s property you made in this `GigController` to it, so the table view controller can have a data source.
    
    - Creating a gig and adding it to the API to the API via a POST request. If the request is successful, append the gig to your local array of `Gig`s.

## Part 4 - View Controller Implementation

1. In `GigsTableViewController`: 

    - Implement `numberOfRowsInSection` using the `GigController`'s `gigs` property as your data source.
    
    - Implement `cellForRowAt` using the same array of `Gigs` to get the gig that corresponds to the cell being set up in this method. The cell's text label should show the gig's title. Use a `DateFormatter` to take the `Gig`'s `dueDate` property and make it into a more user-friendly readable string and place it in the detail text label of the cell.
        - `DateFormatter`s are "expensive" to create. It is better to just create a stored  property of type `DateFormatter` on the `GigsTableViewController` rather than initializing a date formatter in the `cellForRowAt` and effectively making a new date formatter for every cell in your table view.

2. In `GigDetailViewController`:

    - Add a `var gigController: GigController!` property that will be used to receive the `GigsTableViewController`'s `GigController` through the `prepare(for segue`.
    
    - Call `viewDidAppear`. In it, check if the `GigController` property's `bearer` is nil. If it is, then perform the manual segue you made to the `LoginViewController`. We will deal with what happens if it isn't nil tomorrow. For now, just put this line in.
        ```
        // TODO: fetch gigs here
        ```
    - Add a `var gig: Gig?` property that will be used to receive a `Gig` from the `GigsTableViewController`'s `prepare(for segue`if the user taps on a gig cell.
    
    - Create an `updateViews()` method. If a `Gig` passed to the view controller, put its values in the corresponding UI elements like the date picker, and text field/view. If there wasn't a gig, set the view controller's title to "New Gig".
    
    - In the action of the save button, grab the values from the text field/view, and the date picker. Call the `GigController`'s method to create (POST) a gig on the API. In the completion of this method, pop the view controller (on the correct queue) back to the table view controller.
    
3. Back in `GigsTableViewController`:
    - Implement `prepare(for segue` to pass the necessary information to the destination view controller. You should have three segues you need to cover.
    
  - Add a `var gigController: GigController!` property that will be used to receive the `GigsTableViewController`'s `GigController` through the `prepare(for segue`.
  
    - Add a property called `loginType` that lets you know which login type the user is trying to perform. (Logging in, or signing up). The best way to implement this is to create an enum with these two cases and have the property's type be that enum.
    
    - In the segmented control's action, based on the new selected segment, change the login type property that you just made, and change the button's title to match the login type.
    
    - In the button's action, based on the `loginType` property, perform the corresponding method in the `gigController` to either sign them up or log them in. If the **sign up** is successful, present an alert telling them they can log in. If the **log in** is successful, dismiss the view controller to take them back to the `GigsTableViewController`.
    

**The API documentation only showed what was required for this module project. For the next module project, you will continue writing this project. The updated API documentation can be found in the day2 branch's README of this repo here: https://github.com/LambdaSchool/ios-gigs/blob/day2/APIDocumentation.md**

## Go Further

- Implement logic to prevent the user from trying to save an existing gig in `GigDetailViewController`. They could tap the save button and create a duplicate gig in the API.
