# Gigs

## Introduction

Please look at the screen recording below to know what the finished project should look like:
![Gigs pt. 1](https://user-images.githubusercontent.com/16965587/59760255-1f7f0300-924f-11e9-83f2-a01933712ece.gif)


(The gif is fairly large in size. It may take a few seconds for it to appear)

## Instructions

Please fork and clone this repository. This repository does not have a starter project, so create one inside of the cloned repository folder.

You will be making a basic job posting application where users may post jobs, and view jobs that other users have posted themselves.

This is a two day project. For the first day, you will be working on the authentication part of this app. The second day will be fetching jobs and posting new ones.

## Part 1 - Storyboard Setup

In the "Main.storyboard":

1. Delete the view controller scene on the storyboard and add a new `UIViewController` scene.

2. Add a `UITableViewController` scene and embed it in a navigation controller. This navigation controller should be the "Main.storyboard"'s initial view controller.

    - Change the cell's style to one that has two labels (subtitle, right detail, etc.
    
    - Give the cell an identifier.
    
    - Create a Cocoa Touch Subclass of `UITableViewController` called `GigsTableViewController` and set this table view controller scene's class to this new subclass you just created.

3. Add a `UIViewController` scene for signing up/logging in:
    - Create a modal **manual** segue from the `GigsTableViewController` scene to this new view controller scene. Click on the segue in the storyboard and change its "Presentation" to "Full Screen" in the Attributes Inspector.
    
    - Add two text fields; one for a username, and one for a password.
    
    - Add a segmented control with two segments; one for signing up and one for logging in.
    
    - Add a button that will serve as the "Log In" and "Sign Up" button.
    
    - Create a Cocoa Touch Subclass of `UIViewController` called `LoginViewController` and set this view controller scene's class to this new subclass you just created.
    
    - Create outlets from the text fields, segmented control, and button using descriptive variable names.
    
    - Create an action for when the segmented control's value changes from one sign in type to the other, and an action for when the user taps the login/sign up button.

## Part 2 - Models

1. This API also uses Bearer token authentication. Create a `Bearer` swift file and struct. An example of the JSON logging in will return is as follows:

``` JSON
{
  "id": 4,
  "token": "uLCa2hVZ9\/nWsp670qhXucl5A2TZsxr5Mgap5iCAiwY=",
  "userId": 1
}
```

You will only need the token as a property in your struct in this application, but you are welcome to create properties for all of these key-value pairs.

2. Create a `User` swift file and struct that will be used to hold a user's login information. Include the following:

    - A `username` String
    
    - A `password` String

**NOTE: This API expects the encoded User object's keys to be "username" and "password". If you wish to give the properties different names for some reason, you will need to make a coding keys enum to map the new property names to the correct keys the API expects.**

## Part 3 - GigController

1. Create a new Swift file called "GigController.swift" and make a class in it called `GigController`. This class will be responsible for signing you up, and logging you in for today then additionally creating gigs, and fetching gigs tomorrow. We'll keep everything in this class for simplicity's sake but you may choose to have an "AuthenticationController" to handle the authentication aspect of the API. These design decisions are up to the developer and their team. At this point in your learning, implementing one way or the other shouldn't be something to worry over.

2. Add the following properties:
    
    - A `Bearer?` variable
    
    - A `baseURL: URL` constant. See the API documenatation [here](https://github.com/LambdaSchool/ios-gigs/blob/master/APIDocumentation.md) for the url you should use. 

**NOTE: Before you begin the next step, be aware that you will need to add an "application/json" Content-Type header to any POST request, or it will not work properly. As an example, you would add this line once you have a request object:**

```
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
```

3. Following the API's documentation [here](https://github.com/LambdaSchool/ios-gigs/blob/master/APIDocumentation.md), create methods that perform a `URLSessionDataTask` for:

    - Signing up for the API using a username and password. Once you "sign up", you can then log into the API like you did in the guided project this morning.
    
    - Logging in to the API using a username and password. This will give you back a token in JSON data. Decode a `Bearer` object from this data and set the value of bearer property you made in this `GigController` so you can authenticate the requests that require it tomorrow.
    
## Part 4 - View Controllers

### GigsTableViewController

1. In `GigsTableViewController`:

    - Add a property with a new instance of `GigController`. This instance of `GigController` will be used to perform network calls to get the gigs from the API, and be passed to the other view controllers to perform whatever API calls they need to do as well.
    
    - Call `viewDidAppear`. In it, check if the `GigController` property's `bearer` is nil. If it is, then perform the manual segue you made to the `LoginViewController`. We will deal with what happens if it isn't nil tomorrow. For now, just put this line in.
        ```
        // TODO: fetch gigs here
        ```
    
    - Return 0 for the `numberOfRowsInSection` and use this as your implementation of `cellForRowAt` until tomorrow:
    
    ```Swift
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)

        return cell
    }
    ```
    
    This way this table view controller will build and run in the simulator so you can run the checks that segue to the `LoginViewController` if the user isn't logged in.
    
2. In `LoginViewController`:

  - Add a `var gigController: GigController?` property that will be used to receive the `GigsTableViewController`'s `GigController` through the `prepare(for segue`.
  
    - Add a property called `loginType` that lets you know which login type the user is trying to perform. (Logging in, or signing up). The best way to implement this is to create an enum with these two cases and have the property's type be that enum.
    
    - In the segmented control's action, based on the new selected segment, change the login type property that you just made, and change the button's title to match the login type.
    
    - In the button's action, based on the `loginType` property, perform the corresponding method in the `gigController` to either sign them up or log them in. If the **sign up** is successful, present an alert telling them they can log in. If the **log in** is successful, dismiss the view controller to take them back to the `GigsTableViewController`.
    

**The API documentation only showed what was required for this module project. For the next module project, you will continue writing this project. The updated API documentation can be found in the day2 branch's README of this repo here: https://github.com/LambdaSchool/ios-gigs/blob/day2/APIDocumentation.md**

