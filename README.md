# Gigs

## Introduction

Please look at the screen recording below to know what the finished project should look like:

![Gigs Screen Recording](https://user-images.githubusercontent.com/16965587/57464723-71893d80-723a-11e9-87fe-1831188727e5.gif)

(The gif is fairly large in size. It may take a few seconds for it to appear)

## Instructions

Please fork and clone this repository. This repository does not have a starter project, so create one inside of the cloned repository folder.

You will be making a basic job posting application where users may post jobs, and view jobs that other users have posted themselves.

## Part 1 - Storyboard Setup

In the "Main.storyboard":

1. Delete the view controller scene on the storyboard and add a new `UIViewController` scene.

2. Add a `UITableViewController` scene and embed it in a navigation controller. This navigation controller should be the "Main.storyboard"'s initial view controller.

    - Change the cell's style to one that has two labels (subtitle, right detail, etc.
    
    - Give the cell an identifier.
    
    - Add a bar button item to the right of the navigation item. Set its "System Item" to "Add".
    
    - Create a Cocoa Touch Subclass of `UITableViewController` called `GigsTableViewController` and set this table view controller scene's class to this new subclass you just created.

3. Add a `UIViewController` scene for signing up/logging in:
    - Create a **modal** manual segue from the `GigsTableViewController` scene to this new view controller scene.
    
    - Add two text fields; one for a username, and one for a password.
    
    - Add a segmented control with two segments; one for signing up and one for logging in.
    
    - Add a button that will serve as the "Log In" and "Sign Up" button.
    
    - Create a Cocoa Touch Subclass of `UIViewController` called `LoginViewController` and set this view controller scene's class to this new subclass you just created.
    
    - Create outlets from the text fields, segmented control, and button using descriptive variable names.
    
    - Create an action for when the segmented control's value changes from one sign in type to the other, and an action for when the user taps the login/sign up button.

4. Add a second `UIViewController` scene. This will be used for creating new gigs, and viewing details about existing ones.
    - Create a show segue from the table view controller's cell to this new scene. Give the segue an identifier that describes what the user would expect to do in this view controller based on the thing triggering the segue. In this case, "ShowGig", "ViewGig", etc. may make sense.
    
    - Create another show segue from the "+" bar button item to this new scene. Again, give the segue a descriptive identifier. 
    
    - Add a text field to put the gig's title in.
    
    - Add a date picker to allow the user to select the due date of the gig.
    
    - Add a text view to put a longer description of the gig in.
    
    - Add a label next to each of these three UI elements describing what its purpose is ("Job Title:", "Due Date:", "Description:").
    
    - Add a navigation item to this scene, so you can then add a bar button item with the "Save" "System Item".
    
    - Create outlets from the text field, date picker, and text view. 
    
    - Create an action from the save button

## Part 2 - Models

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

This date format in the JSON above is called "ISO 8601", which is another common format for dates. Luckily, when you get to decoding the JSON data, you can specify that you want dates to be decoded from this format.

2. This API also uses Bearer token authentication. Create a `Bearer` swift file and struct. An example of the JSON logging in will return is as follows:

``` JSON
{
  "id": 4,
  "token": "uLCa2hVZ9\/nWsp670qhXucl5A2TZsxr5Mgap5iCAiwY=",
  "userId": 1
}
```

You will only need the token as a property in your struct in this application.

3. Finally, create a `User` swift file and struct that will be used to hold a user's login information. Include the following:

    - A `username` String
    
    - A `password` String

**NOTE: This API expects the encoded User object's keys to be "username" and "password". If you wish to give the properties different names for some reason, you will need to make a coding keys enum to map the new property names to the correct keys the API expects.**

## Part 3 - Gig Controller

1. Create a new Swift file called "GigController.swift" and make a class in it called `GigController`. This class will be responsible for signing you up, logging you in, creating gigs, and fetching gigs. We'll keep everything in this class for simplicity's sake but you may choose to have an "AuthenticationController" to handle the authentication aspect of the API. These design decisions are up to the developer and their team. At this point in your learning, implementing one way or the other shouldn't be something to worry over.

2. Add the following properties:

    - An array of `Gigs`
    
    - A `Bearer?`
    
    - A base URL.

**NOTE: Before you begin the next step, be aware that you will need to add an "application/json" Content-Type header to any POST request, or it will not work properly. As an example, you would add this line once you have a request object:**

```
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
```

3. Following the API's documentation [here](https://github.com/LambdaSchool/ios-gigs/blob/master/APIDocumentation.md), create methods that perform a `URLSessionDataTask` for:

    - Signing up for the API using a username and password. Once you "sign up", you can then log into the API like you did in the guided project this morning.
    
    - Logging in to the API using a username and password. This will give you back a token in JSON data. Decode a `Bearer` object from this data and set the value of bearer property you made in this `GigController` so you can authenticate the requests that require it.
    
    - Getting all the gigs the API has. Once you decode the `Gig`s, set the value of the array of `Gig`s property you made in this `GigController` to it, so the table view controller can have a data source.
    
    - Creating a gig and adding it to the API to the API via a POST request. If the request is successful, append the gig to your local array of `Gig`s.

## Part 4 - View Controllers

### GigsTableViewController

1. In `GigsTableViewController`:

    - Add a property with a new instance of `GigController`. This instance of `GigController` will be used to perform network calls to get the gigs from the API, and be passed to the other view controllers to perform whatever API calls they need to do as well.
    
    - Implement `numberOfRowsInSection` using the `GigController`'s `gigs` property as your data source.
    
    - Implement `cellForRowAt` using the same array of `Gigs` to get the gig that corresponds to the cell being set up in this method. The cell's text label should show the gig's title. Use a `DateFormatter` to take the `Gig`'s `dueDate` property and make it into a more user-friendly readable string and place it in the detail text label of the cell.
    
    - Call `viewDidAppear`. In it, check if the `GigController` property's `bearer` is nil. If it is, then perform the manual segue you made to the `LoginViewController`. If it isn't nil, call your method that fetches all gigs from the API.
    
2. In `LoginViewController`:

  - Add a `var gigController: GigController!` property that will be used to receive the `GigsTableViewController`'s `GigController` through the `prepare(for segue`.
  
    - Add a property called `loginType` that lets you know which login type the user is trying to perform. (Logging in, or signing up). The best way to implement this is to create an enum with these two cases and have the property's type be that enum.
    
    - In the segmented control's action, based on the new selected segment, change the login type property that you just made, and change the button's title to match the login type.
    
    - In the button's action, based on the `loginType` property, perform the corresponding method in the `gigController` to either sign them up or log them in. If the **sign up** is successful, present an alert telling them they can log in. If the **log in** is successful, dismiss the view controller to take them back to the `GigsTableViewController`.
    
3. In `GigDetailViewController`:

    - Add a `var gigController: GigController!` property that will be used to receive the `GigsTableViewController`'s `GigController` through the `prepare(for segue`.
    
    - Add a `var gig: Gig?` property that will be used to receive a `Gig` from the `GigsTableViewController`'s `prepare(for segue`if the user taps on a gig cell.
    
    - Create an `updateViews()` method. If a `Gig` passed to the view controller, put its values in the corresponding UI elements like the date picker, and text field/view. If there wasn't a gig, set the view controller's title to "New Gig".
    
    - In the action of the save button, grab the values from the text field/view, and the date picker. Call the `GigController`'s method to create (POST) a gig on the API. In the completion of this method, pop the view controller (on the correct queue).
    
Back in `GigsTableViewController`:
    - Implement `prepare(for segue` to pass the necessary information to the destination view controller. You should have three segues you need to cover.
    
    
## Go Further

- Implement logic to prevent the user from trying to save an existing gig in `GigDetailViewController`. They could tap the save button and create a duplicate gig in the API.
