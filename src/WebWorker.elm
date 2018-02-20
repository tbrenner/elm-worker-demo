port module WebWorker exposing (..)

import Platform exposing (..)
import Process
import Task
import Time


type Msg
    = Input (List Float)
    | Delay (List Float)


add : Float -> Float -> Float
add a b =
    a + b


init : ( {}, Cmd Msg )
init =
    ( {}, Cmd.none )


port sendResult : Float -> Cmd msg


port receiveInput : (List Float -> msg) -> Sub msg


delay : Time.Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.perform (\_ -> msg)


update : Msg -> {} -> ( {}, Cmd Msg )
update msg model =
    case msg of
        Delay [ a, b ] ->
            ( model, delay (Time.second * 10) <| Input [ a, b ] )

        Input [ a, b ] ->
            ( model, (sendResult (add a b)) )

        _ ->
            ( model, Cmd.none )


subscriptions : {} -> Sub Msg
subscriptions _ =
    receiveInput Delay


main : Program Never {} Msg
main =
    Platform.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
