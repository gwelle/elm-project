module Students exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JSON exposing (..)

--Enregistrement de type Person => les données que l'on veut récupérer uniquement du fichier json
type alias Person =
  { firstName : String
  , lastName : String
  , age : Int
  , phone : String
  }
-- Type personnalisé Student qui contient une liste de personnes
type alias Student = List Person

--Si le résultat est une erreur, on affiche un message d'erreur
--Si le résultat est un succès, on affiche la liste des personnes
type Msg
  = LoadData
  | Response (Result Http.Error Student)


type Model
  = Failure Http.Error
  | Loading
  | Success Student



-- On décode le résultat de la requête HTTP en JSON avec la fonction personEncoder
personEncoder : Decoder Person
personEncoder = 
  JSON.map4 Person
    (JSON.field "firstName" JSON.string)
    (JSON.field "lastName" JSON.string)
    (JSON.field "age" JSON.int)
    (JSON.field "phone" JSON.string)


-- On décode le résultat de la requête HTTP en JSON avec la fonction studentEncoder
studentEncoder : Decoder (List Person)
studentEncoder = 
    JSON.list personEncoder

getStudents : Cmd Msg
getStudents =
  Http.get
    { url = "http://localhost:4000/students"
    , expect = Http.expectJson Response studentEncoder
    }



init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getStudents)

update : Msg -> Model -> (Model, Cmd Msg)
update msg _ =
  case msg of
    LoadData ->
      (Loading, getStudents)

    Response result ->
      case result of
        Ok student ->
          (Success student, Cmd.none)

        Err error ->
          (Failure error, Cmd.none)


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "List of students" ]
    , showStudent model
    ]


showStudent : Model -> Html Msg
showStudent model =
  case model of
    Failure error ->
      div[style "color" "red"] [
        h1[style "color" "red"] [text "Error :  "], errorMessage error
        ]

    Loading ->
      text "Loading..."

    Success student ->
        div []
         [
          table[] [
            thead[] [
              tr[] [
                th[] [text "First Name"],
                th[] [text "Last Name"],
                th[] [text "Age"],
                th[] [text "Phone"]
              ]
            ],
            tbody[] (List.map showStudentRow student)
          ]
         ]


showStudentRow : Person -> Html Msg
showStudentRow person =
  tr[] [
    td[] [text person.firstName],
    td[] [text person.lastName],
    td[] [text (String.fromInt person.age)],
    td[] [text person.phone]
  ]     
      

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


errorMessage : Http.Error -> Html Msg
errorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            text message

        Http.Timeout ->
            text "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
           text  "Unable to reach server."

        Http.BadStatus statusCode ->
            text ("Request failed with status code: " ++ String.fromInt statusCode)


        Http.BadBody message ->
            text message

main : Program () Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
