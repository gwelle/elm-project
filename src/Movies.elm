module Movies exposing (..)
import Browser
import Html exposing (..)
import Http

-- model
type Model
  = Failure 
  | Loading 
  | Success String
  
type Msg
  = Response (Result Http.Error String)

-- init function
getMovies : () -> (Model, Cmd Msg)
getMovies _ =
  ( Loading
  , Http.get
        
      { url = "http://localhost:3000/Movies.txt"
      , expect = Http.expectString Response
      }
  )

-- update function
update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
  case msg of
    Response result ->
      case result of
        Ok data ->
          (Success data, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)

-- view function
view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "Error, when loading data."
    
    Loading ->
      text "Loading..."

    Success data ->
      div [] [pre [] [ text data ]]

  --subscriptions
subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- main function
main : Program () Model Msg
main =
  Browser.element
    { init = getMovies
    , update = update
    , subscriptions = subscriptions
    , view = view
    } 