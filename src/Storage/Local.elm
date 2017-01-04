module Storage.Local exposing (..)

{-| This is a library providing simple binding to LocalStorage

# Cache object
@docs object

# Functions
@docs put, get, isAvailable

-}

import Native.Storage.Local
import Json.Decode as Json

{-| Straight bind to LocalStorage.put -}
put : String -> Json.Value -> Result String ()
put =
    Native.Storage.Local.put

{-| Straight bind to LocalStorage.get -}
get : String -> Result String Json.Value
get =
    Native.Storage.Local.get

{-| Straight bind to LocalStorage.isAvailable -}
isAvailable : Bool
isAvailable =
    Native.Storage.Local.isAvailable

{-| Create a record with necessary put and get functions for data -}
object :
    String
    -> (a -> Json.Value)
    -> Json.Decoder a
    -> { put : a -> Result String a
       , get : () -> Result String a
       }
object key encode decoder =
    { put =
        \value ->
            put key (encode value)
                |> Result.map (always value)
    , get =
        \_ ->
            get key
                |> Result.andThen (Json.decodeValue decoder)
    }
