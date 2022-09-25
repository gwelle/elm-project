module Movies exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http

-- model
type Model
  = Failure Http.Error
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

        Err error ->
          (Failure error, Cmd.none)

-- view function
view : Model -> Html Msg
view model =
  case model of
    Failure error ->
      div[style "color" "red"] [
        h1[style "color" "red"] [text "Error :  "], buildErrorMessage error
        ]
    
    Loading ->
      text "Loading..."

    Success data ->
      div [] [pre [] [ text data ]]

buildErrorMessage : Http.Error -> Html Msg
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            text message

        Http.Timeout ->
           text  "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
           text  "Unable to reach server."

        Http.BadStatus statusCode ->
            text ("Request failed with status code: " ++ String.fromInt statusCode)

        Http.BadBody message ->
           text  message

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