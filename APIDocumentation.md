# Gigs API Documentation

The base URL for this API is https://lambdagigapi.herokuapp.com/api

--- 

### Sign Up

**Endpoint:** `/users/signup`

**Method:** `POST`

**Auth Required:** NO

Creates a user whose credentials can then be used to log in to the API, giving them a bearer token.

JSON should be POSTed in the following format: 

``` JSON
{
  "username": "Tim",
  "password": "Apple"
}
```

#### Success Response

**Code:** `200 OK`

--- 

### Log In

**Endpoint:** `/users/login`

**Method:** `POST`

**Auth Required:** NO

**Description:** After creating a user, you may log in to the API using the same credentials as you used to sign up. e.g:

``` JSON 
{
  "username": "Tim",
  "password": "Apple"
}
```

#### Success Response

**Code:** `200 OK`

The `token` may be used to authenticate a request.

``` JSON
{
  "id": 1,
  "token": "fsMd9aHpoJ62vo4OvLC79MDqd38oE2ihkx6A1KeFwek=",
  "userId": 1
}
```

