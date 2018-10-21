# Whisp

## Backend API

| verb   | path                  | controller                 | handler func. | description                            |
|--------|-----------------------|----------------------------|---------------|----------------------------------------|
| POST   | /api/sessions         | WhispWeb.SessionController | :create       | log in user/create new session token   |
| DELETE | /api/sessions         | WhispWeb.SessionController | :delete       | log out user/delete session revoke     |
| POST   | /api/sessions/refresh | WhispWeb.SessionController | :refresh      | refresh session token                  |
| POST   | /api/users            | WhispWeb.UserController    | :create       | create new user                        |
| GET    | /api/users/:id/rooms  | WhispWeb.UserController    | :rooms        | list joined rooms of specified user ID |
| GET    | /api/rooms            | WhispWeb.RoomController    | :index        | list all rooms                         |
| POST   | /api/rooms            | WhispWeb.RoomController    | :create       | create new room                        |
| POST   | /api/rooms/:id/join   | WhispWeb.RoomController    | :join         | join room of specified ID              |

### Create user via curl
```
curl -X POST -H "Content-Type: application/json" <domain>:<port>/api/users --data '{"username":"jsnow","email":"jon.snow@youknownothing.org","password":"imadragonboi"}'
```
Returns user info and a JWT if sucessful:
```
{"data":{"id":<id>,
         "username":<username>
		 "email":<email>},
 "meta":<token>}
```

### Requesting protected information
Fetch joined rooms
```
curl -H "Content-Type: application/json" -H "Authorization: Bearer <token>" <domain>:<port>/api/users/<user_id>/rooms
```
