
module Main exposing (..)
import Browser
import Html exposing (text, div)

init : { age : number, name : String }
init =
    {age = 29,
    name = "Jordan"}

view : { a | name : String } -> Html.Html msg
view model =
    div [] [text "my Texte"]
update : a -> a
update model =
    model

main : Program () { age : number, name : String } ({ age : number, name : String } -> { age : number, name : String })
main =
    Browser.sandbox
        {
            init = init,
            view = view,
            update = update
        }
