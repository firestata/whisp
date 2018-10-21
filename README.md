# Whisp

## Backend API

| verb   | path                  | controller                 | handler func.                    |
|--------|-----------------------|----------------------------|----------------------------------|
| POST   | /api/sessions         | WhispWeb.SessionController | :create                          |
| DELETE | /api/sessions         | WhispWeb.SessionController | :delete                          |
| POST   | /api/sessions/refresh | WhispWeb.SessionController | :refresh                         |
| POST   | /api/users            | WhispWeb.UserController    | :create                          |
| GET    | /api/users/:id/rooms  | WhispWeb.UserController    | :rooms                           |
| GET    | /api/rooms            | WhispWeb.RoomController    | :index                           |
| POST   | /api/rooms            | WhispWeb.RoomController    | :create                          |
| POST   | /api/rooms/:id/join   | WhispWeb.RoomController    | :join                            |

### Create user via curl
```
curl -X POST -H "Content-Type: application/json" <domain>:<port>/api/users --data '{"username":"jsnow","email","jon.snow@youknownothing.org","password":"imadragonboi"}'
```
