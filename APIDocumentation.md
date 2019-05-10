# Gigs API Documentation

The base URL for this API is https://lambdagigs.vapor.cloud/api

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

---
### Get All Gigs


**Endpoint:** `/gigs/`

**Method:** `GET`

**Auth Required:** YES

**Required Header:** 

| Key | Example Value | Description |
|---|---|---|
| `Authorization` | `Bearer fsMd9aHpoJ62vo4OvLC79MDqd38oE2ihkx6A1KeFwek` | "Bearer " + The token returned from logging in | 

**Description:** Returns an array of `Gig` JSON objects.

#### Success Response

**Code:** `200 OK`

**Response:** 

``` JSON
[
  {
    "title": "Test Gig",
    "dueDate": "2019-05-10T05:29:01Z",
    "description": "This is just a test"
  },
  ...
]
```

#### Not Authenticated Response

**Code:** `401 Unauthorized`

**Description:** The user has not included their token in the `Authorization` header.

**Response:**

``` JSON
{
  "error": true,
  "reason": "User not authenticated."
}
```

---
### Create a Gig

**Endpoint:** `/gigs/`

**Method:** `POST`

**Auth Required:** YES

**Required Header:** 

| Key | Example Value | Description |
|---|---|---|
| `Authorization` | `Bearer fsMd9aHpoJ62vo4OvLC79MDqd38oE2ihkx6A1KeFwek` | "Bearer " + The token returned from logging in | 

**Description:** Creates a Gig in the API. Your request body should be in the following format:

``` JSON
{
  "title": "Test Gig",
  "description": "This is just a test",
  "dueDate": "2019-05-10T05:29:01Z"
}
```

#### Success Response

**Code:** `200 OK`

**Response:** 

``` JSON
{
  "title": "Test Gig",
  "description": "This is just a test",
  "dueDate": "2019-05-10T05:29:01Z"
}
```

#### Not Authenticated Response

**Code:** `401 Unauthorized`

**Description:** The user has not included their token in the `Authorization` header.

**Response:**

``` JSON
{
  "error": true,
  "reason": "User not authenticated."
}
```

