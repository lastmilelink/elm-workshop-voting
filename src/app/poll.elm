module App.Poll exposing (answerDecoder, getFirstPoll, pollDecoder, postAnswer)

import App.Message exposing (Msg(GetHttpPoll, PostHttpAnswer))
import App.Model exposing (Answer, Poll)
import Http
import Json.Decode exposing (Decoder, decodeString, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode exposing (encode, object, string)


--Constants


pollServer : String
pollServer =
    "workshop.lastmilelink.technology:8080"


pollId : String
pollId =
    "1234"



-- Decoders


answerDecoder : Decoder Answer
answerDecoder =
    let
        string =
            Json.Decode.string
    in
        decode Answer
            |> required "id" string
            |> required "answer" string
            |> required "votes" int


pollDecoder : Decoder Poll
pollDecoder =
    let
        string =
            Json.Decode.string
    in
        decode Poll
            |> required "id" string
            |> required "title" string
            |> required "answer" (list answerDecoder)



-- Requests


getFirstPoll : Cmd Msg
getFirstPoll =
    Http.send GetHttpPoll <| Http.get ("http://" ++ pollServer ++ "/poll?pollId=" ++ pollId) pollDecoder


postAnswer : String -> Cmd Msg
postAnswer answerId =
    let
        string =
            Json.Encode.string
    in
        let
            url =
                "http://" ++ pollServer ++ "/poll/vote"

            args =
                (object [ ( "pollId", string "1234" ), ( "answerId", string answerId ) ])

            body =
                Http.stringBody "application/json" (encode 0 args)
        in
            Http.send PostHttpAnswer <| (Http.post url body) pollDecoder
