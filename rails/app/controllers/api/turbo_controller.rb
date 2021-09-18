class API::TurboController < ApplicationController
  def show
    render json: {
      "settings": {
        "navbar": {
          "background": "#888888",
          "foreground": "#ffffff"
        },
        "tabbar": {
          "background": "#888888",
          "selected": "#ffffff",
          "unselected": "#bbbbbb"
        },
        "tabs": [
          {
            "title": "Home",
            "visit": "/",
            "icon_ios": "house",
            "protected": false
          },
          {
            "title": "Profile",
            "visit": "/profile",
            "icon_ios": "person",
            "protected": true
          }
        ],
        "buttons": [
          {
            "path": "/",
            "side": "left",
            "icon_ios": "line.horizontal.3",
            "script": "window.bridge.showMenu();",
            "protected": false
          },
          {
            "path": "/",
            "side": "right",
            "title": "Add",
            "visit": "/posts/new",
            "protected": true
          }
        ]
      },
      "rules": [
        {
          "patterns": [
            "/new$",
            "/edit$"
          ],
          "properties": {
            "presentation": "modal"
          }
        },
        {
          "patterns": [
            "/sign_in$",
            "/sign_up$"
          ],
          "properties": {
            "presentation": "login"
          }
        },
        {
          "patterns": [
            "/users/logout"
          ],
          "properties": {
            "presentation": "replace"
          }
        }
      ]
    }
  end
end